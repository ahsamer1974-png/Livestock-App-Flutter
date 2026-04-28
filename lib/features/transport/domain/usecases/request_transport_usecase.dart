import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/transport_repository.dart';

class RequestTransportUseCase {
  final TransportRepository repository;

  RequestTransportUseCase(this.repository);

  Future<Either<Failure, String>> call(int listingId, String address, double fee) async {
    return await repository.requestTransport(listingId, address, fee);
  }
}