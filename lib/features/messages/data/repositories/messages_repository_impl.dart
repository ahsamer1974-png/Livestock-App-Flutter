import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/contact.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/messages_repository.dart';
import '../datasources/messages_remote_data_source.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  final MessagesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo; // للتأكد من اتصال الإنترنت

  MessagesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Contact>>> getContacts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteContacts = await remoteDataSource.getContacts();
        return Right(remoteContacts); // إرجاع البيانات بنجاح في الطرف الأيمن
      } on ServerException {
        return Left(ServerFailure()); // إرجاع خطأ سيرفر في الطرف الأيسر
      }
    } else {
      return Left(OfflineFailure()); // إرجاع خطأ عدم وجود إنترنت
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getChatHistory(int receiverId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMessages = await remoteDataSource.getChatHistory(receiverId);
        return Right(remoteMessages);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage(int receiverId, String content, {int? listingId}) async {
    if (await networkInfo.isConnected) {
      try {
        final sentMessage = await remoteDataSource.sendMessage(
            receiverId,
            content,
            listingId: listingId
        );
        return Right(sentMessage);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}