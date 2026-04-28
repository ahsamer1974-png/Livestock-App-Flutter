import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/listings_controller.dart';

class MyListingsPage extends GetView<ListingsController> {
  const MyListingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 💡 جلب إعلاناتي تلقائياً أول ما تفتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMyListings();
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('إعلاناتي'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Obx(() {
          // حالة التحميل
          if (controller.isMyListingsLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // حالة عدم وجود إعلانات
          if (controller.myListings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.post_add, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'لا يوجد لديك إعلانات حالياً',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          // عرض قائمة إعلاناتي
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.myListings.length,
            itemBuilder: (context, index) {
              final listing = controller.myListings[index];
              final imageUrl = listing.coverImage.isNotEmpty
                  ? "http://10.0.2.2:5230${listing.coverImage.replaceAll('\\', '/')}"
                  : "";

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  onTap: () {
                    // فتح تفاصيل الإعلان عند الضغط عليه
                    controller.fetchListingDetails(listing.id);
                    Get.toNamed('/listing_details');
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    children: [
                      // صورة الإعلان
                      ClipRRect(
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                        child: imageUrl.isNotEmpty
                            ? Image.network(imageUrl, width: 100, height: 100, fit: BoxFit.cover)
                            : Container(width: 100, height: 100, color: Colors.grey.shade200, child: const Icon(Icons.pets, color: Colors.grey)),
                      ),

                      // تفاصيل الإعلان
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listing.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${listing.price} ريال',
                                style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.category, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(listing.categoryName, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    ],
                                  ),
                                  Text(listing.dateAdded, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}