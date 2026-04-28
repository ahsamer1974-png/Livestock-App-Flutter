import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/transport_controller.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final TransportController controller = Get.find<TransportController>();

  @override
  void initState() {
    super.initState();
    controller.getMyOrders(); // جلب البيانات عند فتح الصفحة
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text('مشترياتي وطلباتي', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.myOrders.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => controller.getMyOrders(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.myOrders.length,
              itemBuilder: (context, index) {
                final order = controller.myOrders[index];
                return _buildOrderCard(order);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOrderCard(order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05), // تحديث لتجنب التحذيرات
              blurRadius: 10
          )
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "http://10.0.2.2:5230${order.listingImage?.replaceAll('\\', '/')}",
                width: 60, height: 60, fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(width: 60, height: 60, color: Colors.grey.shade200, child: const Icon(Icons.pets)),
              ),
            ),
            // ✅ تم إزالة سطر قيمة الطلب (subtitle) من هنا
            title: Text(order.listingTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _getStatusBadge(order.status),
                Text(order.createdAt.toString().split(' ')[0], style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getStatusBadge(int status) {
    String text;
    Color color;
    IconData icon;

    switch (status) {
      case 0: text = "قيد المراجعة"; color = Colors.orange; icon = Icons.hourglass_empty; break;
      case 1: text = "عند شركة التوصيل"; color = Colors.blue; icon = Icons.local_shipping; break;
      case 2: text = "في الطريق إليك"; color = Colors.purple; icon = Icons.map; break;
      case 3: text = "تم التوصيل"; color = Colors.green; icon = Icons.check_circle; break;
      default: text = "غير معروف"; color = Colors.grey; icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1), // تحديث لتجنب التحذيرات
          borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('لا توجد طلبات شراء حالياً', style: TextStyle(color: Colors.grey, fontSize: 18)),
        ],
      ),
    );
  }
}