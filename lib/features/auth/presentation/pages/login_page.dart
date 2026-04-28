import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/auth_controller.dart';

// 💡 نستخدم GetView للوصول التلقائي للـ controller المحقون في الـ Binding
class LoginPage extends GetView<AuthController> {
  LoginPage({Key? key}) : super(key: key);

  // 1. للتحكم في النصوص المدخلة
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 2. مفتاح للتحقق من صحة البيانات (Validation)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // لون الخلفية الرمادي الفاتح
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- الشعار والعنوان ---
                  const Icon(
                    Icons.pets, // أيقونة مؤقتة تعبر عن المواشي
                    size: 80,
                    color: AppColors.primary, // الأخضر الفخم
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'سوق الحلال',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary, // تم توحيد اللون من ملف الألوان
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'سجل دخولك لمتابعة أفضل عروض المواشي',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey, // لون رمادي خفيف للنص الفرعي
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- حقل الإيميل ---
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.right, // ليدعم اللغة العربية
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      prefixIcon: const Icon(Icons.email, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // --- حقل الرقم السري ---
                  TextFormField(
                    controller: passwordController,
                    obscureText: true, // لإخفاء الباسورد بنجوم
                    textAlign: TextAlign.right, // ليدعم اللغة العربية
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // --- زر تسجيل الدخول ---
                  // 🔥 سحر GetX يبدأ هنا عبر Obx التي تراقب حالة التحميل
                  Obx(() {
                    return ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null // تعطيل الزر إذا كان يحمل
                          : () {
                        // إذا كانت الحقول غير فارغة، نفذ أمر الدخول
                        if (_formKey.currentState!.validate()) {
                          controller.login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'دخول',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),

                  // --- زر الانتقال لصفحة التسجيل ---
                  TextButton(
                    onPressed: () {
                      // 💡 هذا السطر ينقلك لصفحة إنشاء الحساب
                      Get.toNamed('/register');
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'ليس لديك حساب؟ ',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        children: [
                          TextSpan(
                            text: 'سجل الآن',
                            style: TextStyle(
                              color: AppColors.accent, // اللون الذهبي
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}