import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo; // أداة فحص الإنترنت

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    // 1. فحص الإنترنت أولاً
    if (await networkInfo.isConnected) {
      try {
        // 2. إذا فيه نت، حاول تسجل الدخول عبر الـ API
        final remoteUser = await remoteDataSource.login(email, password);
        return Right(remoteUser); // Right تعني: النجاح! خذ بيانات المستخدم
      } on ServerException {
        // 3. إذا السيرفر رفض (إيميل خطأ مثلاً)
        return Left(ServerFailure()); // Left تعني: فشل! خذ هذا الخطأ
      }
    } else {
      // 4. إذا ما فيه نت من البداية
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> register(User user) async {
    if (await networkInfo.isConnected) {
      try {
        // تحويل الكيان الصافي User إلى UserModel لكي نستطيع إرساله للـ API
        final userModel = UserModel(
          id: user.id,
          fullName: user.fullName,
          email: user.email,
          phoneNumber: user.phoneNumber,
          password: user.password,
          city: user.city,
          birthDate: user.birthDate,
          joinedDate: user.joinedDate,
        );

        await remoteDataSource.register(userModel);
        return const Right(unit); // unit تعني نجاح العملية (بدون بيانات راجعة)
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}