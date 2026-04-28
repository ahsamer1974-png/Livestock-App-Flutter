import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/message.dart';
import '../repositories/messages_repository.dart';

class SendMessageUseCase {
  final MessagesRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, Message>> call(int receiverId, String content, {int? listingId}) async {
    return await repository.sendMessage(receiverId, content, listingId: listingId);
  }
}