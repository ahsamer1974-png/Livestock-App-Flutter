import 'package:dartz/dartz.dart'; // تأكد من وجود مكتبة dartz للتعامل مع الأخطاء
import '../../../../core/errors/failures.dart';
import '../entities/favorite.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<Favorite>>> getMyFavorites();
  Future<Either<Failure, bool>> toggleFavorite(int listingId);
}