import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/transport_repository.dart';

class StartDeliveryUseCase {
  final TransportRepository repository;

  StartDeliveryUseCase(this.repository);

  Future<Either<Failure, String>> call(int orderId) async {
    return await repository.startDelivery(orderId);
  }
}