import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../entities/order_entity.dart';
import '../../repositories/order_repository.dart';

class SaveOrderAfterPaymentUseCase {
  SaveOrderAfterPaymentUseCase({required this.orderRepo});
  final OrderRepository orderRepo;

  /// Saves the order to Firestore after successful payment
  /// This should be called only after payment confirmation
  Future<Either<Failure, void>> execute(OrderEntity order) async =>
      await orderRepo.saveOrderAfterPayment(order);
}
