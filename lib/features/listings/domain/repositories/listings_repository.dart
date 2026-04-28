import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/listing.dart';
import '../entities/listing_details.dart';

abstract class ListingsRepository {
  // 1. جلب كل الإعلانات
  Future<Either<Failure, List<Listing>>> getAllListings({String? searchString, String? city});

  // 2. جلب تفاصيل إعلان معين
  Future<Either<Failure, ListingDetails>> getListingDetails(int id);
}