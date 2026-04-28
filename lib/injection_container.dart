import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- 👤 استيرادات ميزة تسجيل الدخول (Auth) ---
import 'core/network/network_info.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';

// --- 💡 استيرادات ميزة الإعلانات (Listings) ---
import 'features/listings/data/datasources/listings_remote_data_source.dart';
import 'features/listings/data/repositories/listings_repository_impl.dart';
import 'features/listings/domain/repositories/listings_repository.dart';
import 'features/listings/domain/usecases/get_all_listings_usecase.dart';
import 'features/listings/domain/usecases/get_listing_details_usecase.dart';
import 'features/listings/presentation/controllers/listings_controller.dart';

// --- ✉️ استيرادات ميزة الرسائل (Messages) ---
import 'features/messages/data/datasources/messages_remote_data_source.dart';
import 'features/messages/data/repositories/messages_repository_impl.dart';
import 'features/messages/domain/repositories/messages_repository.dart';
import 'features/messages/domain/usecases/get_contacts.dart';
import 'features/messages/domain/usecases/get_chat_history.dart';
import 'features/messages/domain/usecases/send_message.dart';
import 'features/messages/presentation/controllers/messages_controller.dart';

// --- ❤️ استيرادات ميزة المفضلة (Favorites) ---
import 'features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'features/favorites/data/repositories/favorites_repository_impl.dart';
import 'features/favorites/domain/repositories/favorites_repository.dart';
import 'features/favorites/domain/usecases/get_my_favorites.dart';
import 'features/favorites/domain/usecases/toggle_favorite.dart';
import 'features/favorites/presentation/controllers/favorites_controller.dart';

// --- 🚚 استيرادات ميزة النقل والطلبات (Transport) ---
import 'features/transport/data/datasources/transport_remote_data_source.dart';
import 'features/transport/data/repositories/transport_repository_impl.dart';
import 'features/transport/domain/repositories/transport_repository.dart';
import 'features/transport/domain/usecases/request_transport_usecase.dart';
import 'features/transport/domain/usecases/get_my_orders_usecase.dart';
import 'features/transport/domain/usecases/get_incoming_orders_usecase.dart';
import 'features/transport/domain/usecases/start_delivery_usecase.dart';
import 'features/transport/presentation/controllers/transport_controller.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // =========================================================
  // 1. ميزة المستخدمين (Auth)
  // =========================================================
  sl.registerLazySingleton(() => AuthController(
    loginUseCase: sl(),
    registerUseCase: sl(),
  ));

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(client: sl()),
  );

  // =========================================================
  // 2. ميزة الإعلانات (Listings)
  // =========================================================
  sl.registerFactory(() => ListingsController(
    getAllListingsUseCase: sl(),
    getListingDetailsUseCase: sl(),
  ));

  sl.registerLazySingleton(() => GetAllListingsUseCase(sl()));
  sl.registerLazySingleton(() => GetListingDetailsUseCase(sl()));

  sl.registerLazySingleton<ListingsRepository>(
        () => ListingsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<ListingsRemoteDataSource>(
        () => ListingsRemoteDataSourceImpl(client: sl()),
  );

  // =========================================================
  // 3. ميزة الرسائل (Messages)
  // =========================================================
  sl.registerFactory(() => MessagesController(
    getContactsUseCase: sl(),
    getChatHistoryUseCase: sl(),
    sendMessageUseCase: sl(),
  ));

  sl.registerLazySingleton(() => GetContactsUseCase(sl()));
  sl.registerLazySingleton(() => GetChatHistoryUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));

  sl.registerLazySingleton<MessagesRepository>(
        () => MessagesRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<MessagesRemoteDataSource>(
        () => MessagesRemoteDataSourceImpl(client: sl()),
  );

  // =========================================================
  // 4. ميزة المفضلة (Favorites)
  // =========================================================
  sl.registerFactory(() => FavoritesController(
    getMyFavoritesUseCase: sl(),
    toggleFavoriteUseCase: sl(),
  ));

  sl.registerLazySingleton(() => GetMyFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));

  sl.registerLazySingleton<FavoritesRepository>(
        () => FavoritesRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<FavoritesRemoteDataSource>(
        () => FavoritesRemoteDataSourceImpl(client: sl()),
  );

  // =========================================================
  // 5. ميزة الطلبات والنقل (Transport) 🔴 [تم التعديل بإضافة sl رابع]
  // =========================================================
  sl.registerFactory(() => TransportController(
    getMyOrdersUseCase: sl(),
    getIncomingOrdersUseCase: sl(),
    startDeliveryUseCase: sl(),
    requestTransportUseCase: sl(), // ⬅️ إضافة هذا السطر لحل الإيرور
  ));

  // Use Cases
  sl.registerLazySingleton(() => RequestTransportUseCase(sl()));
  sl.registerLazySingleton(() => GetMyOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetIncomingOrdersUseCase(sl()));
  sl.registerLazySingleton(() => StartDeliveryUseCase(sl()));

  // Repository
  sl.registerLazySingleton<TransportRepository>(
        () => TransportRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Data Source
  sl.registerLazySingleton<TransportRemoteDataSource>(
        () => TransportRemoteDataSourceImpl(client: sl()),
  );

  // =========================================================
  // 6. الأساسيات والمكتبات (Core & External)
  // =========================================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}