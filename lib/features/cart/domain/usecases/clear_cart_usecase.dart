import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/cart_repository.dart';

class ClearCartUseCase {
  ClearCartUseCase(this.repository);
  final CartRepository repository;

  Future<Either<Failure, void>> execute(String userId) =>
      repository.clear(userId);
}
