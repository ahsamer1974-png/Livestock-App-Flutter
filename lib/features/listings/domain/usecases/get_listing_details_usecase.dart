import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/listing_details.dart';
import '../repositories/listings_repository.dart';

class GetListingDetailsUseCase {
  final ListingsRepository repository;

  GetListingDetailsUseCase(this.repository);

  Future<Either<Failure, ListingDetails>> call(int id) async {
    return await repository.getListingDetails(id);
  }
}