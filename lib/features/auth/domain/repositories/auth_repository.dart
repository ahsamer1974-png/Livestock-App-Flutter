import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  // لاحظ استخدام Either: إما أن ترجع خطأ (Failure) على اليسار، أو مستخدم (User) على اليمين
  Future<Either<Failure, User>> login(String email, String password);

  // Unit في مكتبة dartz تعني (void) أي عملية نجحت بدون إرجاع بيانات
  Future<Either<Failure, Unit>> register(User user);
}