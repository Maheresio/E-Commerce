import 'package:dartz/dartz.dart';
import '../../../home/domain/entities/product_entity.dart';

import '../../../../core/error/failure.dart';
import '../repositories/favorite_repository.dart';

class GetUserFavoritesUseCase {
  GetUserFavoritesUseCase(this.repository);
  final FavoriteRepository repository;

  Future<Either<Failure, List<ProductEntity>>> execute(String userId) =>
      repository.getUserFavorites(userId);
}
