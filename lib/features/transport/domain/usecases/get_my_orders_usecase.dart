import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transport_order.dart';
import '../repositories/transport_repository.dart';

class GetMyOrdersUseCase {
  final TransportRepository repository;

  GetMyOrdersUseCase(this.repository);

  Future<Either<Failure, List<TransportOrder>>> call() async {
    return await repository.getMyOrders();
  }
}