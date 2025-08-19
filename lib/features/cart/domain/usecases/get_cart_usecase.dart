import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase {
  GetCartUseCase(this.repository);
  final CartRepository repository;

  Future<Either<Failure, List<CartItemEntity>>> execute(String userId) =>
      repository.getCart(userId);
}
