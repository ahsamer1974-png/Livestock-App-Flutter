import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transport_order.dart';

abstract class TransportRepository {
  // 1. طلب شراء / توصيل
  Future<Either<Failure, String>> requestTransport(int listingId, String address, double fee);

  // 2. جلب مشترياتي
  Future<Either<Failure, List<TransportOrder>>> getMyOrders();

  // 3. جلب الطلبات الواردة (للبائع)
  Future<Either<Failure, List<TransportOrder>>> getIncomingOrders();

  // 4. موافقة البائع وبدء التوصيل
  Future<Either<Failure, String>> startDelivery(int orderId);
}