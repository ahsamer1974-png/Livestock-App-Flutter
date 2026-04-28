import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/entities/user.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthController({
    required this.loginUseCase,
    required this.registerUseCase,
  });

  var isLoading = false.obs;
  var currentUser = Rxn<User>();

  // --- 🌟 حالة تعديل الملف الشخصي ---
  var isEditingProfile = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    final result = await loginUseCase(email, password);

    result.fold(
          (failure) {
        isLoading.value = false;
        Get.snackbar(
          'خطأ',
          'تأكد من صحة البيانات أو اتصالك بالإنترنت',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
          (user) {
        isLoading.value = false;
        currentUser.value = user;
        Get.snackbar(
          'نجاح',
          'مرحباً بك يا ${user.fullName} في سوق الحلال!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        Get.offAllNamed('/home');
      },
    );
  }

  // 💡 الدالة الصحيحة التي تجمع البيانات في كائن User وترسله
  Future<void> register(String fullName, String email, String phoneNumber, String password, {String? city, String? birthDate}) async {
    isLoading.value = true;

    // 1. تجميع البيانات في كائن User
    final newUser = User(
      id: 0,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      city: city,
      birthDate: birthDate,
    );

    // 2. إرسال الكائن للـ UseCase
    final result = await registerUseCase(newUser);

    result.fold(
          (failure) {
        // ✅ إيقاف التحميل داخل بلوك الفشل
        isLoading.value = false;

        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء إنشاء الحساب، ربما البريد مستخدم مسبقاً',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
          (_) {
        // ✅ إيقاف التحميل داخل بلوك النجاح لكي تظهر الرسالة
        isLoading.value = false;

        Get.snackbar(
          'نجاح',
          'تم إنشاء الحساب بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );

        // العودة لصفحة تسجيل الدخول بعد النجاح
        Get.back();
      },
    );
  }

  // ==========================================
  // ✏️ دالة تعديل الملف الشخصي
  // ==========================================
  Future<bool> editProfile(String newName, String newCity) async {
    final user = currentUser.value;
    if (user == null) return false;

    isEditingProfile.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final cookie = prefs.getString('auth_cookie') ?? '';

      final response = await http.put(
        Uri.parse('http://10.0.2.2:5230/api/SettingsApi/EditProfile/${user.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': cookie,
        },
        body: json.encode({
          'FullName': newName,
          'City': newCity,
        }),
      );

      if (response.statusCode == 200) {
        // 🔥 تحديث بيانات المستخدم محلياً عشان تتغير في الواجهة فوراً
        final updatedUser = User(
          id: user.id,
          fullName: newName, // الاسم الجديد
          email: user.email,
          phoneNumber: user.phoneNumber, // نحافظ على الرقم الحالي بما أننا لا نعدله هنا
          password: user.password,
          city: newCity, // المدينة الجديدة
          birthDate: user.birthDate,
        );

        currentUser.value = updatedUser;

        Get.back(); // الخروج من صفحة التعديل والعودة للإعدادات
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.snackbar(
            'نجاح',
            'تم تحديث بياناتك بنجاح! 🚀',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
          );
        });
        return true;
      } else {
        Get.snackbar('تنبيه', 'حدث خطأ أثناء تحديث البيانات', snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      Get.snackbar('خطأ', 'تأكد من اتصالك بالإنترنت', snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isEditingProfile.value = false;
    }
  }
}