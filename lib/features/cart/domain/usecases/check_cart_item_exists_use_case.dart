import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class CheckCartItemExistsUseCase {
  CheckCartItemExistsUseCase(this.repository);
  final CartRepository repository;

  Future<Either<Failure, CartItemEntity?>> execute(
    String userId,
    String productId,
    String selectedSize,
    String selectedColor,
  ) async {
    final Either<Failure, List<CartItemEntity>> result = await repository
        .getCart(userId);

    return result.fold(Left.new, (List<CartItemEntity> cartItems) {
      try {
        final CartItemEntity existingItem = cartItems.firstWhere(
          (CartItemEntity item) =>
              item.productId == productId &&
              item.selectedSize == selectedSize &&
              item.selectedColor == selectedColor,
        );
        return Right(existingItem);
      } catch (e) {
        return const Right(null);
      }
    });
  }
}
