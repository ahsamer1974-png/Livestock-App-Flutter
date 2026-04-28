import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/contact.dart';
import '../repositories/messages_repository.dart';

class GetContactsUseCase {
  final MessagesRepository repository;

  GetContactsUseCase(this.repository);

  Future<Either<Failure, List<Contact>>> call() async {
    return await repository.getContacts();
  }
}