import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/messages_controller.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MessagesController controller = Get.find<MessagesController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('الرسائل', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary, // 🟢 رجعناه للون الأخضر
        foregroundColor: Colors.white,      // ⚪️ لون النص أبيض
        elevation: 1,
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isContactsLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.contactsErrorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.contactsErrorMessage.value));
        }

        if (controller.contacts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.message_outlined, size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text('لا توجد محادثات، ابدأ دردشة جديدة', style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchContacts(),
          child: ListView.separated(
            itemCount: controller.contacts.length,
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(right: 80),
              child: Divider(height: 1, color: Color(0xFFEEEEEE)),
            ),
            itemBuilder: (context, index) {
              final contact = controller.contacts[index];
              return InkWell(
                onTap: () {
                  Get.toNamed('/chat', arguments: {
                    'receiverId': contact.contactId,
                    'contactName': contact.contactName,
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      _buildInitialAvatar(contact.contactName),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contact.contactName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            // 🔥 التعديل هنا: جلب آخر رسالة حقيقية من السيرفر
                            Text(
                              contact.lastMessage,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildInitialAvatar(String name) {
    String initial = name.trim().isNotEmpty ? name.trim().characters.first.toUpperCase() : '?';
    final List<Color> avatarColors = [
      Colors.red.shade400, Colors.blue.shade400, Colors.green.shade400,
      Colors.orange.shade400, Colors.purple.shade400, Colors.teal.shade400, Colors.pink.shade400,
    ];
    Color color = avatarColors[name.length % avatarColors.length];

    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}