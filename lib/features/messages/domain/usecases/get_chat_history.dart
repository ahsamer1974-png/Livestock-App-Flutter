import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/message.dart';
import '../repositories/messages_repository.dart';

class GetChatHistoryUseCase {
  final MessagesRepository repository;

  GetChatHistoryUseCase(this.repository);

  // نمرر الـ receiverId (رقم الشخص الآخر) عشان نجيب المحادثة معه
  Future<Either<Failure, List<Message>>> call(int receiverId) async {
    return await repository.getChatHistory(receiverId);
  }
}