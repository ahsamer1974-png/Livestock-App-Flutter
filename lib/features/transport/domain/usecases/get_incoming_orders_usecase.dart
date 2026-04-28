import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transport_order.dart';
import '../repositories/transport_repository.dart';

class GetIncomingOrdersUseCase {
  final TransportRepository repository;

  GetIncomingOrdersUseCase(this.repository);

  Future<Either<Failure, List<TransportOrder>>> call() async {
    return await repository.getIncomingOrders();
  }
}