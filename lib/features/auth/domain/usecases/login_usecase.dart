import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

// كلاس تسجيل الدخول
class LoginUseCase {
  final AuthRepository repository;

  // نستقبل الـ Repository عبر الـ Constructor
  LoginUseCase(this.repository);

  // نستخدم كلمة call لكي نستطيع استدعاء الكلاس وكأنه دالة
  Future<Either<Failure, User>> call(String email, String password) async {
    // ببساطة، نمرر الإيميل والباسورد للمستودع وننتظر النتيجة
    return await repository.login(email, password);
  }
}