import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/listing.dart';
import '../repositories/listings_repository.dart';

class GetAllListingsUseCase {
  final ListingsRepository repository;

  GetAllListingsUseCase(this.repository);

  // دالة call تسمح لنا باستدعاء الكلاس وكأنه دالة عادية
  Future<Either<Failure, List<Listing>>> call({String? searchString, String? city}) async {
    return await repository.getAllListings(searchString: searchString, city: city);
  }
}