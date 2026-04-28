import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/messages_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final MessagesController controller = Get.find<MessagesController>();
  final TextEditingController textController = TextEditingController();

  late int receiverId;
  late String contactName;

  @override
  void initState() {
    super.initState();
    receiverId = Get.arguments['receiverId'];
    contactName = Get.arguments['contactName'];
    // جلب الرسائل أول ما تفتح الشاشة
    controller.fetchChatHistory(receiverId);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // 💡 لون خلفية المحادثة (زي واتساب)
      appBar: AppBar(
        title: Text(contactName, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary, // 🟢 اللون الأخضر
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isChatLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.chatErrorMessage.value.isNotEmpty) {
                return Center(child: Text(controller.chatErrorMessage.value));
              }

              if (controller.chatHistory.isEmpty) {
                return const Center(child: Text('لا توجد رسائل سابقة. ابدأ المحادثة الآن!', style: TextStyle(color: Colors.grey)));
              }

              return ListView.builder(
                reverse: false,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: controller.chatHistory.length,
                itemBuilder: (context, index) {
                  final msg = controller.chatHistory[index];
                  bool isMe = msg.isMine;
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isMe ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(15),
                          topRight: const Radius.circular(15),
                          bottomLeft: isMe ? const Radius.circular(15) : const Radius.circular(0),
                          bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        msg.content,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          // 🔥 استدعاء مربع إدخال النص
          _buildMessageInput(),
        ],
      ),
    );
  }

  // 💡 مربع إدخال النص مع SafeArea لحل مشكلة الكيبورد
  Widget _buildMessageInput() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'اكتب رسالتك...',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Obx(() => CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 24,
              child: controller.isSending.value
                  ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
                  : IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () {
                  if (textController.text.trim().isNotEmpty) {
                    controller.sendMessage(receiverId, textController.text.trim());
                    textController.clear();
                  }
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}