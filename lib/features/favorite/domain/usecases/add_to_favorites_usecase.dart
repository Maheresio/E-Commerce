import 'package:dartz/dartz.dart';
import '../../../home/domain/entities/product_entity.dart';

import '../../../../core/error/failure.dart';
import '../repositories/favorite_repository.dart';

class AddToFavoritesUseCase {
  AddToFavoritesUseCase(this.repository);
  final FavoriteRepository repository;

  Future<Either<Failure, void>> execute(String userId, ProductEntity product) =>
      repository.addToFavorites(userId, product);
}
