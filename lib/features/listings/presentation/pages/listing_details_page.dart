import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/listings_controller.dart';
import 'package:livestock_marketplace_app/features/favorites/presentation/controllers/favorites_controller.dart';
import 'package:livestock_marketplace_app/features/auth/presentation/controllers/auth_controller.dart';

class ListingDetailsPage extends GetView<ListingsController> {
  const ListingDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // جلب الكنترولرات
    final favController = Get.find<FavoritesController>();
    final authController = Get.find<AuthController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('تفاصيل الإعلان', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        body: Obx(() {
          if (controller.isDetailsLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final details = controller.selectedListing.value;
          if (details == null) return const Center(child: Text('عذراً، الإعلان غير متوفر'));

          final imageUrl = details.images.isNotEmpty
              ? "http://10.0.2.2:5230${details.images.first.replaceAll('\\', '/')}"
              : "";

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. صورة الإعلان
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: imageUrl.isNotEmpty
                      ? Image.network(imageUrl, fit: BoxFit.contain)
                      : const Icon(Icons.pets, size: 80, color: Colors.grey),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. العنوان والسعر
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              details.title,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${details.price} ريال',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // 🌟 3. وصف الإعلان 🌟
                      const Text('وصف الإعلان', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 8),
                      Text(
                        details.description,
                        style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black54),
                      ),

                      const SizedBox(height: 25),

                      // 4. معلومات الإعلان
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade200)
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(Icons.category_outlined, 'القسم', details.categoryName),
                            _buildInfoRow(Icons.location_on_outlined, 'المدينة', details.city),
                            if (details.age != null && details.age!.isNotEmpty) _buildInfoRow(Icons.history, 'العمر', details.age!),
                            // ✅ استخدام دالة الوقت المحدثة
                            _buildInfoRow(Icons.access_time_outlined, 'تاريخ النشر', _getTimeAgo(details.dateAdded)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 🌟 5. زر المفضلة بعرض الشاشة 🌟
                      Obx(() {
                        bool isFav = favController.favorites.any((fav) => fav.listingId == details.id);
                        return ElevatedButton.icon(
                          onPressed: () => favController.toggleFavorite(details.id),
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 24,
                          ),
                          label: Text(
                            isFav ? 'محفوظ في المفضلة' : 'أضف للمفضلة',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFav ? Colors.red.shade500 : Colors.white,
                            foregroundColor: isFav ? Colors.white : Colors.orange.shade600,
                            elevation: isFav ? 3 : 0,
                            side: BorderSide(
                              color: isFav ? Colors.red.shade500 : Colors.orange.shade600,
                              width: 1.5,
                            ),
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                        );
                      }),

                      const SizedBox(height: 30),

                      // 6. بطاقة البائع
                      _buildSellerCard(details, authController),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // كرت معلومات البائع
  Widget _buildSellerCard(details, authController) {
    final currentUserId = authController.currentUser.value?.id;
    final isOwner = currentUserId != null && currentUserId.toString() == details.sellerId.toString();

    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade200)
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, color: Colors.white, size: 30)
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(details.sellerName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(details.city, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (isOwner)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('هذا إعلانك الشخصي', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed('/chat', arguments: {
                    'receiverId': details.sellerId,
                    'contactName': details.sellerName,
                  });
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('مراسلة البائع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // صفوف المعلومات
  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Text('$title: ', style: const TextStyle(fontSize: 15, color: Colors.black54)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // 💡 الدالة الذكية (تم حذف "الآن" واستبدالها بـ "منذ دقيقة")
  String _getTimeAgo(String dateString) {
    try {
      // 1. تنظيف التاريخ
      String cleanDate = dateString.replaceAll('/', '-');
      cleanDate = cleanDate.replaceFirst(' ', 'T');

      // 2. التحقق هل السيرفر أرسل وقت أم تاريخ فقط؟
      bool hasTime = cleanDate.contains('T') || cleanDate.contains(':');

      DateTime parsedDate;
      DateTime now = DateTime.now();

      if (hasTime) {
        parsedDate = DateTime.parse(cleanDate);
      } else {
        parsedDate = DateTime.parse(cleanDate);
        now = DateTime(now.year, now.month, now.day);
        parsedDate = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
      }

      // 3. أخذ الفرق المطلق
      Duration diff = now.difference(parsedDate).abs();

      // 4. الحسابات اللغوية
      if (diff.inDays > 365) {
        return 'منذ ${diff.inDays ~/ 365} سنة';
      } else if (diff.inDays > 30) {
        return 'منذ ${diff.inDays ~/ 30} شهر';
      } else if (diff.inDays > 0) {
        if (diff.inDays == 1) return 'أمس';
        if (diff.inDays == 2) return 'منذ يومين';
        if (diff.inDays >= 3 && diff.inDays <= 10) return 'منذ ${diff.inDays} أيام';
        return 'منذ ${diff.inDays} يوماً';
      }

      // إذا كان نفس اليوم والسيرفر لم يرسل وقت، نعرض "اليوم"
      if (!hasTime) {
        return 'اليوم';
      }

      // حساب الساعات والدقائق
      if (diff.inHours > 0) {
        if (diff.inHours == 1) return 'منذ ساعة';
        if (diff.inHours == 2) return 'منذ ساعتين';
        if (diff.inHours >= 3 && diff.inHours <= 10) return 'منذ ${diff.inHours} ساعات';
        return 'منذ ${diff.inHours} ساعة';
      } else if (diff.inMinutes > 0) {
        if (diff.inMinutes == 1) return 'منذ دقيقة';
        if (diff.inMinutes == 2) return 'منذ دقيقتين';
        if (diff.inMinutes >= 3 && diff.inMinutes <= 10) return 'منذ ${diff.inMinutes} دقائق';
        return 'منذ ${diff.inMinutes} دقيقة';
      }

      // 🌟 التعديل هنا: إذا كان الإعلان أقل من دقيقة، نكتب "منذ دقيقة" بدل "الآن"
      return 'منذ دقيقة';
    } catch (e) {
      return dateString;
    }
  }
}