import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, String>> submitOrder(
    OrderEntity order,
    String customerId, {
    String? paymentMethodId,
  });

  Future<Either<Failure, String>> submitOrderWithTransaction(
    OrderEntity order,
    String customerId, {
    String? paymentMethodId,
  });

  // New methods for proper payment flow
  Future<Either<Failure, String>> createPaymentIntentOnly(
    OrderEntity order,
    String customerId, {
    String? paymentMethodId,
  });

  Future<Either<Failure, void>> saveOrderAfterPayment(OrderEntity order);

  Future<Either<Failure, List<OrderEntity>>> getMyOrders(String userId);
  Future<Either<Failure, OrderEntity>> getOrderDetails(String orderId);
  Stream<Either<Failure, OrderEntity>> watchOrderStatus(String orderId);
}
