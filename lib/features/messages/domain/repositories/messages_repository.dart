import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/contact.dart';
import '../entities/message.dart';

abstract class MessagesRepository {
  // جلب جهات الاتصال
  Future<Either<Failure, List<Contact>>> getContacts();

  // جلب محادثة معينة
  Future<Either<Failure, List<Message>>> getChatHistory(int receiverId);

  // إرسال رسالة
  Future<Either<Failure, Message>> sendMessage(int receiverId, String content, {int? listingId});
}