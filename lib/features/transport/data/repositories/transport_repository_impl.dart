import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/transport_order.dart';
import '../../domain/repositories/transport_repository.dart';
import '../datasources/transport_remote_data_source.dart';

class TransportRepositoryImpl implements TransportRepository {
  final TransportRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;

  TransportRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.sharedPreferences,
  });


  String _getToken() {
    final token = sharedPreferences.getString('auth_cookie') ?? '';
    print('=== 🔑 الكوكي المستخدم: ${token.isNotEmpty ? "موجود" : "فارغ!!"} ===');
    return token;
  }

  @override
  Future<Either<Failure, String>> requestTransport(int listingId, String address, double fee) async {
    try {
      final token = _getToken();
      final message = await remoteDataSource.requestTransport(listingId, address, fee, token);
      return Right(message);
    } catch (e) {
      print("❌ خطأ في إرسال الطلب: $e");
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<TransportOrder>>> getMyOrders() async {
    // 💡 تم إلغاء فحص (networkInfo.isConnected) مؤقتاً لتجنب مشاكل المحاكي
    try {
      final token = _getToken();
      print("🔄 جاري طلب مشترياتي من السيرفر...");
      final orders = await remoteDataSource.getMyOrders(token);
      print("✅ تم جلب ${orders.length} طلبات بنجاح");
      return Right(orders);
    } catch (e) {
      print("❌ خطأ في جلب مشترياتي: $e");
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<TransportOrder>>> getIncomingOrders() async {
    try {
      final token = _getToken();
      print("🔄 جاري طلب الطلبات الواردة من السيرفر...");
      final orders = await remoteDataSource.getIncomingOrders(token);
      print("✅ تم جلب ${orders.length} طلبات واردة بنجاح");
      return Right(orders);
    } catch (e) {
      print("❌ خطأ في جلب الطلبات الواردة: $e");
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> startDelivery(int orderId) async {
    try {
      final token = _getToken();
      final message = await remoteDataSource.startDelivery(orderId, token);
      return Right(message);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}