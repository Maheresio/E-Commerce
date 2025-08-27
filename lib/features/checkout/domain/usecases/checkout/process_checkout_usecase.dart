import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../repositories/checkout_repository.dart';

class ProcessCheckoutUsecase {
  ProcessCheckoutUsecase(this.repository);
  final CheckoutRepository repository;

  Future<Either<Failure, String>> execute({
    required String userId,
    required double cartTotal,
    String? idempotencyKey,
  }) => repository.processCheckout(
    userId: userId,
    cartTotal: cartTotal,
    idempotencyKey: idempotencyKey,
  );
}
