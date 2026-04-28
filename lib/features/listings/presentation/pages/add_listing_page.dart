import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/listings_controller.dart';

class AddListingPage extends StatefulWidget {
  const AddListingPage({Key? key}) : super(key: key);

  @override
  State<AddListingPage> createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  final ListingsController controller = Get.find<ListingsController>();
  final _formKey = GlobalKey<FormState>();

  // المتغيرات
  String title = '';
  String description = '';
  double price = 0;
  String city = 'الرياض'; // قيمة افتراضية
  String age = '';
  int? selectedCategoryId;

  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  // جلب الصور من المعرض
  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((e) => File(e.path)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('إضافة إعلان جديد', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // اختيار الصور
              InkWell(
                onTap: _pickImages,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  ),
                  child: _selectedImages.isEmpty
                      ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('اضغط لإضافة صور للإعلان', style: TextStyle(color: Colors.grey)),
                    ],
                  )
                      : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_selectedImages[index], width: 100, height: 100, fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // العنوان
              TextFormField(
                decoration: const InputDecoration(labelText: 'عنوان الإعلان', border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
                onSaved: (val) => title = val!,
              ),
              const SizedBox(height: 16),

              // الوصف
              TextFormField(
                decoration: const InputDecoration(labelText: 'الوصف', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (val) => val!.isEmpty ? 'مطلوب' : null,
                onSaved: (val) => description = val!,
              ),
              const SizedBox(height: 16),

              // السعر والعمر
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'السعر (ريال)', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (val) => val!.isEmpty ? 'مطلوب' : null,
                      onSaved: (val) => price = double.parse(val!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'العمر (مثال: سنتين)', border: OutlineInputBorder()),
                      onSaved: (val) => age = val ?? '',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // القسم
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'القسم', border: OutlineInputBorder()),
                items: controller.categories.map((cat) {
                  return DropdownMenuItem<int>(
                    value: cat['id'] as int,
                    child: Text(cat['name'].toString()),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedCategoryId = val),
                validator: (val) => val == null ? 'اختر القسم' : null,
              ),
              const SizedBox(height: 16),

              // المدينة
              TextFormField(
                initialValue: city,
                decoration: const InputDecoration(labelText: 'المدينة', border: OutlineInputBorder()),
                onSaved: (val) => city = val!,
              ),
              const SizedBox(height: 30),

              // زر الإرسال
              Obx(() => ElevatedButton(
                onPressed: controller.isAddingListing.value
                    ? null
                    : () async {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedImages.isEmpty) {
                      Get.snackbar('تنبيه', 'الرجاء اختيار صورة واحدة على الأقل');
                      return;
                    }
                    _formKey.currentState!.save();

                    bool success = await controller.createNewListing(
                      title: title,
                      description: description,
                      price: price,
                      city: city,
                      age: age,
                      categoryId: selectedCategoryId!,
                      images: _selectedImages,
                    );

                    if (success) {
                      Get.back(); // العودة للشاشة السابقة بعد النجاح
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: controller.isAddingListing.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('نشر الإعلان', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              )),
            ],
          ),
        ),
      ),
    );
  }
}