import 'package:get/get.dart';
import 'auth_controller.dart';
import '../../../../injection_container.dart' as di;

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // نستخدم lazyPut لضمان استدعاء الـ sl فقط عند الحاجة
    Get.lazyPut(() => di.sl<AuthController>());
  }
}