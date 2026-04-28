import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/listing_model.dart';
import '../models/listing_details_model.dart';

// 1. العقد (Contract) الذي يحدد الدوال المطلوبة
abstract class ListingsRemoteDataSource {
  Future<List<ListingModel>> getAllListings({String? searchString, String? city});
  Future<ListingDetailsModel> getListingDetails(int id);
}

// 2. التنفيذ الفعلي للاتصال بالسيرفر
class ListingsRemoteDataSourceImpl implements ListingsRemoteDataSource {
  final http.Client client;

  ListingsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ListingModel>> getAllListings({String? searchString, String? city}) async {
    // تجهيز الرابط الأساسي من ملف الثوابت الخاص بك
    Uri uri = Uri.parse(ApiConstants.listings);

    // إضافة الفلاتر (البحث والمدينة) إذا كانت موجودة
    Map<String, String> queryParams = {};
    if (searchString != null && searchString.isNotEmpty) {
      queryParams['searchString'] = searchString;
    }
    if (city != null && city.isNotEmpty) {
      queryParams['city'] = city;
    }
    if (queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    // إرسال الطلب للسيرفر
    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // تحويل النص القادم من السيرفر إلى JSON
      final List decodedJson = json.decode(response.body);
      // تحويل الـ JSON إلى قائمة من الموديلات
      return decodedJson.map((json) => ListingModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ListingDetailsModel> getListingDetails(int id) async {
    // دمج الرابط الأساسي مع رقم الإعلان (مثال: /api/ListingsApi/5)
    final response = await client.get(
      Uri.parse('${ApiConstants.listings}/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);

      if (decodedJson['success'] == true) {
        return ListingDetailsModel.fromJson(decodedJson['data']);
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }
}