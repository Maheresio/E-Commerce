import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class AddOrUpdateCartItemUseCase {
  AddOrUpdateCartItemUseCase(this.repository);
  final CartRepository repository;

  Future<Either<Failure, void>> execute(String userId, CartItemEntity item) =>
      repository.addOrUpdate(userId, item);
}
