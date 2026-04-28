import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// استيرادات الملفات الخاصة بمشروعك
import 'core/constants/app_colors.dart';
import 'features/auth/presentation/controllers/auth_binding.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'injection_container.dart' as di;
import 'features/auth/presentation/pages/home_page.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/listings/presentation/controllers/listings_controller.dart';
import 'features/listings/presentation/pages/listing_details_page.dart';

// استيرادات قسم الرسائل
import 'features/messages/presentation/controllers/messages_controller.dart';
import 'features/messages/presentation/pages/chat_page.dart';

// استيرادات قسم المفضلة
import 'features/favorites/presentation/controllers/favorites_controller.dart';
import 'features/favorites/presentation/pages/favorites_page.dart';

// 🚚 استيراد كنترولر التوصيل (Transport)
import 'features/transport/presentation/controllers/transport_controller.dart';

// حل مشكلة شهادات الأمان (HTTPS) للمحاكي
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  try {
    await di.init();
  } catch (e) {
    debugPrint("Error during DI initialization: $e");
  }

  runApp(const HalalMarketApp());
}

class HalalMarketApp extends StatelessWidget {
  const HalalMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'سوق الحلال',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('ar', 'SA'),
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Cairo', // اختياري لو كنت تستخدم خط عربي
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginPage(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/register',
          page: () => RegisterPage(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          binding: BindingsBuilder(() {
            Get.put(di.sl<AuthController>(), permanent: true);
            Get.put(di.sl<ListingsController>());
            Get.put(di.sl<MessagesController>());
            Get.put(di.sl<FavoritesController>());
            // 🚚 إضافة كنترولر التوصيل هنا ليعمل في كامل التطبيق
            Get.put(di.sl<TransportController>());
          }),
        ),
        GetPage(
          name: '/listing_details',
          page: () => const ListingDetailsPage(),
        ),
        GetPage(
          name: '/chat',
          page: () => const ChatPage(),
        ),
      ],
    );
  }
}