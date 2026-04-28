import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/favorites_controller.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // استدعاء الكنترولر
    final FavoritesController controller = Get.find<FavoritesController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('المفضلة', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text('لا توجد إعلانات في المفضلة حالياً', style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.favorites.length,
          itemBuilder: (context, index) {
            final fav = controller.favorites[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: fav.coverImage.isNotEmpty
                      ? Image.network(
                    "http://10.0.2.2:5230${fav.coverImage.replaceAll('\\', '/')}",
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildFallbackImage(),
                  )
                      : _buildFallbackImage(),
                ),
                title: Text(fav.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('${fav.price} ريال', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                    Text('${fav.categoryName} • ${fav.city}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                // أيقونة الحذف من المفضلة
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red, size: 30),
                  onPressed: () {
                    // استدعاء دالة الحذف من الكنترولر
                    controller.toggleFavorite(fav.listingId);
                  },
                ),
                onTap: () {
                  // فتح تفاصيل الإعلان عند الضغط عليه
                  Get.toNamed('/listing_details', arguments: fav.listingId);
                },
              ),
            );
          },
        );
      }),
    );
  }

  // صورة بديلة في حال الإعلان ما فيه صورة
  Widget _buildFallbackImage() {
    return Container(
      width: 70,
      height: 70,
      color: Colors.grey.shade200,
      child: const Icon(Icons.pets, color: Colors.grey),
    );
  }
}