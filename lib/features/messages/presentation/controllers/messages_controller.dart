import 'package:get/get.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/contact.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/get_contacts.dart';
import '../../domain/usecases/get_chat_history.dart';
import '../../domain/usecases/send_message.dart';

class MessagesController extends GetxController {
  // 💡 استدعاء حالات الاستخدام (Use Cases)
  final GetContactsUseCase getContactsUseCase;
  final GetChatHistoryUseCase getChatHistoryUseCase;
  final SendMessageUseCase sendMessageUseCase;

  MessagesController({
    required this.getContactsUseCase,
    required this.getChatHistoryUseCase,
    required this.sendMessageUseCase,
  });

  // =========================================
  // 🔻 المتغيرات التفاعلية (State) 🔻
  // =========================================

  // 1. جهات الاتصال (المحادثات السابقة)
  var isContactsLoading = false.obs;
  var contacts = <Contact>[].obs;
  var contactsErrorMessage = ''.obs;

  // 2. تفاصيل محادثة معينة
  var isChatLoading = false.obs;
  var chatHistory = <Message>[].obs;
  var chatErrorMessage = ''.obs;

  // 3. حالة إرسال رسالة جديدة
  var isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    // جلب قائمة جهات الاتصال بمجرد فتح التطبيق/الكنترولر
    fetchContacts();
  }

  // =========================================
  // 🔻 الدوال (Functions) 🔻
  // =========================================

  // 1. جلب جهات الاتصال
  Future<void> fetchContacts() async {
    isContactsLoading.value = true;
    contactsErrorMessage.value = '';

    final result = await getContactsUseCase(); // استدعاء الـ UseCase

    result.fold(
          (failure) {
        if (failure is OfflineFailure) {
          contactsErrorMessage.value = 'تأكد من اتصالك بالإنترنت';
        } else {
          contactsErrorMessage.value = 'حدث خطأ أثناء جلب المحادثات';
        }
      },
          (data) {
        contacts.value = data;
      },
    );

    isContactsLoading.value = false;
  }

  // 2. جلب تاريخ المحادثة مع شخص معين
  Future<void> fetchChatHistory(int receiverId) async {
    isChatLoading.value = true;
    chatErrorMessage.value = '';
    chatHistory.clear(); // تفريغ المحادثة السابقة حتى لا تتداخل

    final result = await getChatHistoryUseCase(receiverId);

    result.fold(
          (failure) {
        if (failure is OfflineFailure) {
          chatErrorMessage.value = 'تأكد من اتصالك بالإنترنت';
        } else {
          chatErrorMessage.value = 'حدث خطأ أثناء جلب الرسائل';
        }
      },
          (data) {
        chatHistory.value = data;
      },
    );

    isChatLoading.value = false;
  }

  // 3. إرسال رسالة جديدة
  Future<void> sendMessage(int receiverId, String content, {int? listingId}) async {
    if (content.trim().isEmpty) return; // منع إرسال رسالة فارغة

    isSending.value = true;

    final result = await sendMessageUseCase(receiverId, content, listingId: listingId);

    result.fold(
          (failure) {
        Get.snackbar('خطأ', 'لم يتم إرسال الرسالة، حاول مرة أخرى',
            snackPosition: SnackPosition.BOTTOM);
      },
          (sentMessage) {
        // 🔥 ميزة رهيبة: بمجرد نجاح الإرسال في السيرفر، نضيف الرسالة للقائمة فوراً
        // لكي تظهر في الشاشة بدون الحاجة لعمل تحديث (Refresh) للمحادثة كاملة!
        chatHistory.add(sentMessage);
      },
    );

    isSending.value = false;
  }
}