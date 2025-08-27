import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/order_entity.dart';
import '../../repositories/order_repository.dart';

class CreatePaymentIntentUseCase {
  CreatePaymentIntentUseCase({required this.orderRepo});
  final OrderRepository orderRepo;

  /// Creates a PaymentIntent without saving the order to Firestore
  /// This should be used when you want to show the payment sheet first
  Future<Either<Failure, String>> execute(
    OrderEntity order,
    String customerId,
    String? paymentMethodId,
  ) async => await orderRepo.createPaymentIntentOnly(
    order,
    customerId,
    paymentMethodId: paymentMethodId,
  );
}
