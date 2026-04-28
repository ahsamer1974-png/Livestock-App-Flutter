import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends GetView<AuthController> {
  RegisterPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final cityController = TextEditingController(); // المتحكم الجديد للمدينة

  // متحكم ومُتغير لمراقبة تاريخ الميلاد المختار
  final birthDateController = TextEditingController();
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('إنشاء حساب جديد', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.primary,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.person_add, size: 80, color: AppColors.primary),
                const SizedBox(height: 30),

                // 1. حقل الاسم
                TextFormField(
                  controller: nameController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: 'الاسم الكامل',
                    prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v!.isEmpty ? 'الاسم مطلوب' : null,
                ),
                const SizedBox(height: 15),

                // 2. حقل البريد
                TextFormField(
                  controller: emailController,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: const Icon(Icons.email, color: AppColors.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v!.isEmpty ? 'البريد مطلوب' : null,
                ),
                const SizedBox(height: 15),

                // 3. حقل الجوال
                TextFormField(
                  controller: phoneController,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'رقم الجوال',
                    prefixIcon: const Icon(Icons.phone, color: AppColors.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v!.isEmpty ? 'رقم الجوال مطلوب' : null,
                ),
                const SizedBox(height: 15),

                // 4. حقل كلمة المرور
                TextFormField(
                  controller: passwordController,
                  textAlign: TextAlign.right,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v!.length < 6 ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل' : null,
                ),
                const SizedBox(height: 15),

                // 5. حقل المدينة (اختياري)
                TextFormField(
                  controller: cityController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: 'المدينة (اختياري)',
                    prefixIcon: const Icon(Icons.location_city, color: AppColors.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 15),

                // 6. حقل تاريخ الميلاد (يفتح تقويم)
                TextFormField(
                  controller: birthDateController,
                  readOnly: true, // يمنع الكتابة اليدوية لضمان تنسيق التاريخ
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: 'تاريخ الميلاد (اختياري)',
                    prefixIcon: const Icon(Icons.calendar_today, color: AppColors.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900), // أقدم تاريخ ممكن
                      lastDate: DateTime.now(), // لا يمكن اختيار تاريخ في المستقبل
                    );

                    if (pickedDate != null) {
                      selectedDate.value = pickedDate;
                      // صيغة التاريخ المناسبة لقواعد البيانات (YYYY-MM-DD)
                      birthDateController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    }
                  },
                ),
                const SizedBox(height: 30),

                // زر إنشاء الحساب
                Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () {
                    if (_formKey.currentState!.validate()) {
                      // 💡 تعديل مهم: يجب أن نمرر المدينة وتاريخ الميلاد للكنترولر
                      // إذا لم يتم اختيارها، نرسل قيمة فارغة
                      controller.register(
                        nameController.text.trim(),
                        emailController.text.trim(),
                        phoneController.text.trim(),
                        passwordController.text.trim(),
                        city: cityController.text.trim(),
                        birthDate: birthDateController.text.trim().isNotEmpty ? birthDateController.text.trim() : null,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('إنشاء الحساب', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}