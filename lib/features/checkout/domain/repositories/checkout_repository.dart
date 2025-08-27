import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, String>> processCheckout({
    required String userId,
    required double cartTotal,
    String? idempotencyKey,
  });

  Future<Either<Failure, void>> initializePaymentSheet({
    required String clientSecret,
    required String customerId,
    String? ephemeralKey,
    dynamic defaultCard,
    dynamic defaultAddress,
  });

  Future<Either<Failure, void>> presentPaymentSheet();
}
