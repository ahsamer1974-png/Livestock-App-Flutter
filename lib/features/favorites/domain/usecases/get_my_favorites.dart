import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/favorite.dart';
import '../repositories/favorites_repository.dart';

class GetMyFavoritesUseCase {
  final FavoritesRepository repository;

  GetMyFavoritesUseCase(this.repository);

  Future<Either<Failure, List<Favorite>>> call() async {
    return await repository.getMyFavorites();
  }
}