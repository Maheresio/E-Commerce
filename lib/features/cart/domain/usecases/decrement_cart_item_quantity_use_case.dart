import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class DecrementCartItemQuantityUseCase {
  DecrementCartItemQuantityUseCase(this.repository);
  final CartRepository repository;

  Future<Either<Failure, CartItemEntity>> execute(
    String userId,
    CartItemEntity item,
  ) async {
    // Get current cart to ensure we have the latest quantity
    final Either<Failure, List<CartItemEntity>> currentCartResult =
        await repository.getCart(userId);

    return currentCartResult.fold(Left.new, (
      List<CartItemEntity> currentItems,
    ) async {
      // Find current item or use passed item
      CartItemEntity currentItem;
      try {
        currentItem = currentItems.firstWhere(
          (CartItemEntity c) => c.id == item.id,
        );
      } catch (_) {
        currentItem = item;
      }

      if (currentItem.quantity <= 1) {
        return const Left(Failure('Cannot decrement quantity below 1'));
      }

      final CartItemEntity updatedItem = currentItem.copyWith(
        quantity: currentItem.quantity - 1,
      );

      final Either<Failure, void> updateResult = await repository.addOrUpdate(
        userId,
        updatedItem,
      );
      return updateResult.fold(Left.new, (success) => Right(updatedItem));
    });
  }
}
