import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/handle_repository_exceptions.dart';
import '../repositories/cart_repository.dart';

class CalculateCartTotalUseCase {
  CalculateCartTotalUseCase(this.repository);
  final CartRepository repository;

  Future<Either<Failure, double>> execute(String userId) async =>
      handleRepositoryExceptions(() async {
        final result = await repository.getCart(userId);

        return result.fold((failure) => throw failure, (cartItems) {
          double total = 0.0;

          for (final item in cartItems) {
            total += item.price * item.quantity;
          }

          return total;
        });
      });
}
