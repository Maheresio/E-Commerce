import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../favorite/domain/repositories/favorite_repository.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../../home/domain/repositories/home_repository.dart';

class AddToFavoritesUseCase {
  AddToFavoritesUseCase({
    required this.homeRepository,
    required this.favoriteRepository,
  });
  final HomeRepository homeRepository;
  final FavoriteRepository favoriteRepository;

  Future<Either<Failure, void>> execute(String userId, String productId) async {
    // First, get the product by ID
    final Either<Failure, ProductEntity> productResult = await homeRepository
        .getProductById(productId);

    return productResult.fold(Left.new, (ProductEntity product) async {
      // Add the product to favorites
      final Either<Failure, void> addResult = await favoriteRepository
          .addToFavorites(userId, product);
      return addResult.fold(Left.new, (success) => const Right(null));
    });
  }
}
