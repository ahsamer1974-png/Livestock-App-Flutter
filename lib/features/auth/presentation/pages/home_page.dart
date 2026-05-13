import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../../../listings/presentation/controllers/listings_controller.dart';
import '../../../messages/presentation/pages/contacts_page.dart';
import '../../../favorites/presentation/pages/favorites_page.dart';
import 'package:livestock_marketplace_app/features/listings/presentation/pages/add_listing_page.dart';
import 'package:livestock_marketplace_app/features/listings/presentation/pages/my_listings_page.dart';
import 'package:livestock_marketplace_app/features/auth/presentation/pages/edit_profile_page.dart';
import 'package:livestock_marketplace_app/features/drivers/presentation/pages/drivers_page.dart';
// --- 🚚 استيرادات ميزة الطلبات والتوصيل الجديدة ---
// import 'package:livestock_marketplace_app/features/transport/presentation/pages/my_orders_page.dart';
// import 'package:livestock_marketplace_app/features/transport/presentation/pages/incoming_orders_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(),
    const DriversPage(),
    const MessagesTab(),
    const FavoritesTab(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الرئيسية',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping),
              label: 'tran sport',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'الرسائل',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'المفضلة',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 🔻 تبويب الرئيسية (مع شريط الأقسام المطور) 🔻
// ==========================================

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  // 💡 دالة الوقت الذكية (تم حذف "الآن" واستبدالها بـ "منذ دقيقة")
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

  @override
  Widget build(BuildContext context) {
    final ListingsController listingsController = Get.find<ListingsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('سوق الحلال', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            final allCategory = {'id': 0, 'name': 'الكل'};
            final displayCategories = [allCategory, ...listingsController.categories];

            if (listingsController.categories.isEmpty) {
              return const SizedBox(height: 10);
            }

            return Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))
                ],
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: displayCategories.length,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemBuilder: (context, index) {
                  final cat = displayCategories[index];
                  final isSelected = listingsController.selectedCategoryId.value == cat['id'];

                  return GestureDetector(
                    onTap: () {
                      listingsController.selectCategory(cat['id'] as int);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          cat['name'].toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          Expanded(
            child: Obx(() {
              if (listingsController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (listingsController.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 70, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(listingsController.errorMessage.value),
                      ElevatedButton(
                        onPressed: () => listingsController.fetchAllListings(),
                        child: const Text('إعادة المحاولة'),
                      )
                    ],
                  ),
                );
              }

              var displayListings = listingsController.listings.toList();

              if (listingsController.selectedCategoryId.value > 0) {
                final selectedCat = listingsController.categories.firstWhere(
                      (c) => c['id'] == listingsController.selectedCategoryId.value,
                  orElse: () => {'name': ''},
                );

                displayListings = listingsController.listings
                    .where((ad) => ad.categoryName == selectedCat['name'])
                    .toList();
              }

              if (displayListings.isEmpty) {
                return const Center(
                  child: Text('لا توجد إعلانات في هذا القسم', style: TextStyle(fontSize: 16, color: Colors.grey)),
                );
              }

              return RefreshIndicator(
                onRefresh: () => listingsController.fetchAllListings(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: displayListings.length,
                  itemBuilder: (context, index) {
                    final ad = displayListings[index];
                    final imageUrl = ad.coverImage.isNotEmpty
                        ? "http://10.0.2.2:5230${ad.coverImage.replaceAll('\\', '/')}"
                        : "";

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () {
                          listingsController.fetchListingDetails(ad.id);
                          Get.toNamed('/listing_details');
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                imageUrl,
                                width: 110, height: 110, fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 110, height: 110, color: Colors.grey.shade200,
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                ),
                              )
                                  : Container(
                                width: 110, height: 110, color: Colors.grey.shade200,
                                child: const Icon(Icons.pets, color: Colors.grey),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ad.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 5),
                                    Text('${ad.price} ريال', style: const TextStyle(fontSize: 15, color: AppColors.accent, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(ad.city, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time, size: 12, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(_getTimeAgo(ad.dateAdded), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 🔻 بقية التبويبات 🔻
// ==========================================

class MessagesTab extends StatelessWidget {
  const MessagesTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const ContactsPage();
  }
}

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const FavoritesPage();
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        title: const Text('لوحة التحكم', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        final user = authController.currentUser.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.fullName ?? 'مستخدم',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'جاري التحميل...',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _buildDashboardTile(
                title: 'إضافة إعلان جديد',
                subtitle: 'انشر إعلانك الآن',
                icon: Icons.add_circle,
                iconColor: Colors.amber.shade600,
                onTap: () {
                  Get.to(() => AddListingPage());
                },
              ),

              _buildDashboardTile(
                title: 'إعلاناتي',
                subtitle: 'إدارة وتعديل إعلاناتك',
                icon: Icons.list_alt,
                iconColor: Colors.blue.shade600,
                onTap: () {
                  Get.to(() => MyListingsPage());
                },
              ),

              // _buildDashboardTile(
              //   title: 'طلباتي ومشترياتي',
              //   subtitle: 'متابعة حالة مشترياتك',
              //   icon: Icons.shopping_cart,
              //   iconColor: Colors.green.shade600,
              //   onTap: () {
              //     Get.to(() => MyOrdersPage());
              //   },
              // ),
              //
              // _buildDashboardTile(
              //   title: 'الطلبات الواردة',
              //   subtitle: 'إدارة طلبات شراء إعلاناتك',
              //   icon: Icons.inbox_outlined,
              //   iconColor: Colors.teal.shade600,
              //   onTap: () {
              //     Get.to(() => IncomingOrdersPage());
              //   },
              // ),

              _buildDashboardTile(
                title: 'تعديل الملف الشخصي',
                subtitle: 'تغيير الاسم أو المدينة',
                icon: Icons.edit_note,
                iconColor: AppColors.primary,
                onTap: () {
                  Get.to(() => EditProfilePage());
                },
              ),

              const SizedBox(height: 24),

              InkWell(
                onTap: () {
                  authController.currentUser.value = null;
                  Get.offAllNamed('/login');
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.red.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'تسجيل الخروج',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDashboardTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}