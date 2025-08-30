import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../home/domain/entities/product_entity.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, void>> addToFavorites(
    String userId,
    ProductEntity product,
  );
  Future<Either<Failure, void>> removeFromFavorites(
    String userId,
    String productId,
  );
  Future<Either<Failure, bool>> isFavorite(String userId, String productId);
  Future<Either<Failure, List<ProductEntity>>> getUserFavorites(String userId);
}
