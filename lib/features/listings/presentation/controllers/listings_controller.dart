import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/listing.dart';
import '../../domain/entities/listing_details.dart';
import '../../domain/usecases/get_all_listings_usecase.dart';
import '../../domain/usecases/get_listing_details_usecase.dart';
import 'package:flutter/material.dart';

class ListingsController extends GetxController {
  final GetAllListingsUseCase getAllListingsUseCase;
  final GetListingDetailsUseCase getListingDetailsUseCase;

  ListingsController({
    required this.getAllListingsUseCase,
    required this.getListingDetailsUseCase,
  });

  // --- حالات الإعلانات ---
  var isLoading = false.obs;
  var listings = <Listing>[].obs;
  var errorMessage = ''.obs;

  // --- حالات تفاصيل الإعلان ---
  var isDetailsLoading = false.obs;
  var selectedListing = Rxn<ListingDetails>();

  // --- حالات الأقسام (Categories) ---
  var categories = <Map<String, dynamic>>[].obs;
  var selectedCategoryId = 0.obs;

  // --- حالة إضافة إعلان جديد ---
  var isAddingListing = false.obs;

  // --- 🌟 حالات "إعلاناتي" الجديدة 🌟 ---
  var isMyListingsLoading = false.obs;
  var myListings = <Listing>[].obs;

  @override
  void onInit() {
    super.onInit();
    _setInitialCategories();
    fetchCategories();
    fetchAllListings();
  }

  void _setInitialCategories() {
    categories.value = [
      {'id': 1, 'name': 'طيور'},
      {'id': 2, 'name': 'أغنام'},
      {'id': 3, 'name': 'إبل'},
      {'id': 4, 'name': 'أبقار'},
    ];
  }

  Future<void> fetchCategories() async {
    try {
      final url = 'http://10.0.2.2:5230/api/ListingsApi/Categories';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          categories.value = data.map((e) => e as Map<String, dynamic>).toList();
        }
      }
    } catch (e) {
      print('⚠️ خطأ في اتصال الأقسام: $e');
    }
  }

  void selectCategory(int id) {
    selectedCategoryId.value = id;
    fetchAllListings(categoryId: id == 0 ? null : id);
  }

  Future<void> fetchAllListings({String? searchString, String? city, int? categoryId}) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getAllListingsUseCase(
      searchString: searchString,
      city: city,
    );

    result.fold(
          (failure) {
        isLoading.value = false;
        if (failure is OfflineFailure) {
          errorMessage.value = 'تأكد من اتصالك بالإنترنت';
        } else {
          errorMessage.value = 'حدث خطأ أثناء جلب البيانات من السيرفر';
        }
      },
          (data) {
        isLoading.value = false;
        listings.value = data;
      },
    );
  }

  Future<void> fetchListingDetails(int id) async {
    isDetailsLoading.value = true;
    selectedListing.value = null;

    final result = await getListingDetailsUseCase(id);

    result.fold(
          (failure) {
        Get.snackbar('خطأ', 'لم نتمكن من جلب التفاصيل',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white);
      },
          (details) {
        selectedListing.value = details;
      },
    );

    isDetailsLoading.value = false;
  }

  // ==========================================
  // 🌟 دالة جلب إعلاناتي الخاصة (My Listings)
  // ==========================================
  Future<void> fetchMyListings() async {
    isMyListingsLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final cookie = prefs.getString('auth_cookie') ?? '';

      final response = await http.get(
        Uri.parse('http://10.0.2.2:5230/api/SettingsApi/MyListings'),
        headers: {
          'Cookie': cookie,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        myListings.value = data.map((e) => Listing(
          id: e['id'] ?? 0,
          title: e['title'] ?? '',
          price: (e['price'] ?? 0).toDouble(),
          city: e['city'] ?? '',
          age: e['age'],
          categoryName: e['categoryName'] ?? '',
          dateAdded: e['dateAdded'] ?? '',
          coverImage: e['coverImage'] ?? '',
        )).toList();
      } else if (response.statusCode == 401) {
        Get.snackbar('تنبيه', 'انتهت الجلسة، الرجاء تسجيل الدخول مجدداً', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('⚠️ خطأ في جلب إعلاناتي: $e');
    } finally {
      isMyListingsLoading.value = false;
    }
  }

  // ==========================================
  // ➕ دالة إضافة إعلان جديد
  // ==========================================
  Future<bool> createNewListing({
    required String title,
    required String description,
    required double price,
    required String city,
    required String age,
    required int categoryId,
    required List<File> images,
  }) async {
    isAddingListing.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final cookie = prefs.getString('auth_cookie') ?? '';

      var request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:5230/api/ListingsApi'));

      request.headers.addAll({'Cookie': cookie});

      request.fields['Title'] = title;
      request.fields['Description'] = description;
      request.fields['Price'] = price.toInt().toString();
      request.fields['City'] = city;
      request.fields['Age'] = age;
      request.fields['CategoryId'] = categoryId.toString();

      for (var image in images) {
        request.files.add(await http.MultipartFile.fromPath('images', image.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      var responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        fetchAllListings();
        fetchMyListings(); // تحديث قائمة إعلاناتي أيضاً بعد الإضافة
        isAddingListing.value = false;
        Get.back();
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.snackbar(
            'نجاح', 'تم نشر الإعلان بنجاح! 🚀',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
          );
        });
        return true;
      } else {
        Get.snackbar('تنبيه', 'حدث خطأ أثناء الرفع', snackPosition: SnackPosition.BOTTOM);
        isAddingListing.value = false;
        return false;
      }
    } catch (e) {
      Get.snackbar('خطأ', 'تأكد من اتصالك بالإنترنت', snackPosition: SnackPosition.BOTTOM);
      isAddingListing.value = false;
      return false;
    }
  }
}