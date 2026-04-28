import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/transport_controller.dart';

class IncomingOrdersPage extends StatefulWidget {
  const IncomingOrdersPage({Key? key}) : super(key: key);

  @override
  State<IncomingOrdersPage> createState() => _IncomingOrdersPageState();
}

class _IncomingOrdersPageState extends State<IncomingOrdersPage> {
  final TransportController controller = Get.find<TransportController>();

  @override
  void initState() {
    super.initState();
    controller.getIncomingOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text('الطلبات الواردة', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Obx(() {
          if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
          if (controller.incomingOrders.isEmpty) return _buildEmptyState();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.incomingOrders.length,
            itemBuilder: (context, index) {
              final order = controller.incomingOrders[index];
              return _buildIncomingOrderCard(order);
            },
          );
        }),
      ),
    );
  }

  Widget _buildIncomingOrderCard(order) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(order.listingTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(order.deliveryAddress, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 16),
          if (order.status == 0)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.acceptOrder(order.id),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Text('قبول الطلب وبدء التوصيل', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          else
            _getStatusInfo(order.status),
        ],
      ),
    );
  }

  Widget _getStatusInfo(int status) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
      child: const Center(child: Text("تم قبول الطلب وجاري التحديث التلقائي", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text('لا توجد طلبات واردة حالياً', style: TextStyle(color: Colors.grey)));
  }
}