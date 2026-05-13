import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/drivers_controller.dart';

class DriversPage extends StatefulWidget {
  const DriversPage({super.key});

  @override
  State<DriversPage> createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage> {
  final DriversController controller = Get.find<DriversController>();

  @override
  void initState() {
    super.initState();
    controller.fetchDrivers();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('السائقين'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () => Get.toNamed('/add-driver'),
          label: const Text('إضافة'),
          icon: const Icon(Icons.add),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.drivers.isEmpty) {
            return const Center(child: Text('لا يوجد سائقين حالياً'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.drivers.length,
            itemBuilder: (context, index) {
              final driver = controller.drivers[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/chat', arguments: {
                          'receiverId': driver.userId,
                          'contactName': driver.fullName,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue.shade100,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('مراسلة'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            driver.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(driver.region),
                          Text(driver.carType),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}