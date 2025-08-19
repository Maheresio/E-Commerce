import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/favorite_repository.dart';

class RemoveFromFavoritesUseCase {
  RemoveFromFavoritesUseCase(this.repository);
  final FavoriteRepository repository;

  Future<Either<Failure, void>> execute(String userId, String productId) =>
      repository.removeFromFavorites(userId, productId);
}
