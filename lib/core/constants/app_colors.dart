import 'package:flutter/material.dart';

class AppColors {
  // ==================== الألوان الأساسية ====================
  // اللون الأخضر الأساسي للتطبيق (مريح للعين ومناسب لسوق الحلال)
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF60AD5E);
  static const Color primaryDark = Color(0xFF005005);

  // اللون الثانوي (ذهبي/رملي للأزرار والأيقونات المميزة)
  static const Color accent = Color(0xFFD4AF37);

  // ==================== ألوان الخلفيات ====================
  static const Color background = Color(0xFFF5F6F8); // رمادي فاتح جداً للخلفيات يبرز الكروت الأبيض
  static const Color cardWhite = Colors.white; // لون كروت الإعلانات

  // ==================== ألوان النصوص ====================
  static const Color textDark = Color(0xFF212121); // أسود داكن للعناوين (اسم الإعلان)
  static const Color textGrey = Color(0xFF757575); // رمادي للنصوص الفرعية (مثل المدينة والتاريخ)

  // ==================== ألوان الإشعارات والحالات ====================
  static const Color favoriteRed = Color(0xFFE53935); // أحمر لأيقونة القلب (المفضلة)
  static const Color error = Color(0xFFD32F2F); // أحمر لرسائل الخطأ
  static const Color success = Color(0xFF388E3C); // أخضر لرسائل النجاح
}