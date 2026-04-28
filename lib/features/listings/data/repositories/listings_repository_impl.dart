import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/listing.dart';
import '../../domain/entities/listing_details.dart';
import '../../domain/repositories/listings_repository.dart';
import '../datasources/listings_remote_data_source.dart';

class ListingsRepositoryImpl implements ListingsRepository {
  final ListingsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ListingsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Listing>>> getAllListings({String? searchString, String? city}) async {
    // 1. فحص اتصال الإنترنت
    if (await networkInfo.isConnected) {
      try {
        // 2. طلب الإعلانات من السيرفر
        final remoteListings = await remoteDataSource.getAllListings(searchString: searchString, city: city);
        return Right(remoteListings);
      } on ServerException {
        // 3. في حال وجود خطأ من السيرفر
        return Left(ServerFailure());
      }
    } else {
      // 4. في حال عدم وجود إنترنت
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, ListingDetails>> getListingDetails(int id) async {
    // فحص اتصال الإنترنت لجلب تفاصيل إعلان معين
    if (await networkInfo.isConnected) {
      try {
        final remoteListingDetails = await remoteDataSource.getListingDetails(id);
        return Right(remoteListingDetails);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}