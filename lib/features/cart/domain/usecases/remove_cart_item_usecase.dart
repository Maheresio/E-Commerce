import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/cart_repository.dart';

class RemoveCartItemUseCase {
  RemoveCartItemUseCase(this.repository);
  final CartRepository repository;

  Future<Either<Failure, void>> execute(String userId, String itemId) =>
      repository.remove(userId, itemId);
}
