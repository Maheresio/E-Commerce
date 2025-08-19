import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCart(String userId);
  Future<Either<Failure, void>> addOrUpdate(String userId, CartItemEntity item);
  Future<Either<Failure, void>> remove(String userId, String itemId);
  Future<Either<Failure, void>> clear(String userId);
}
