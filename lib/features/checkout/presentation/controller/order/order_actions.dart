import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/usecases/order/get_my_orders_usecase.dart';
import '../../../domain/usecases/order/get_order_details_usecase.dart';
import '../../../domain/usecases/order/submit_order_usecase.dart';
import '../../../domain/usecases/order/watch_order_status_usecase.dart';
import '../visa_card/visa_card_providers.dart';
import 'order_usecase_providers.dart';

class OrderActions {
  OrderActions(this.ref) {
    _submitOrder = ref.read(submitOrderUseCaseProvider);
    _getMyOrders = ref.read(getMyOrdersUseCaseProvider);
    _getOrderDetails = ref.read(getOrderDetailsUseCaseProvider);
    _watchOrderStatus = ref.read(watchOrderStatusUseCaseProvider);
  }
  final Ref ref;
  late final SubmitOrderUseCase _submitOrder;
  late final GetMyOrdersUseCase _getMyOrders;
  late final GetOrderDetailsUseCase _getOrderDetails;
  late final WatchOrderStatusUseCase _watchOrderStatus;

  /// Submit an order and return client secret for payment
  Future<Either<Failure, String>> submitOrder(
    OrderEntity order,
    String customerId,
    String userId,
  ) async => await _submitOrder.execute(order, customerId, userId);

  /// Submit an order with transaction and return client secret for payment
  Future<Either<Failure, String>> submitOrderWithTransaction(
    OrderEntity order,
    String customerId,
    String userId,
  ) async =>
      await _submitOrder.executeWithTransaction(order, customerId, userId);

  /// Fetch all orders for the current user
  Future<Either<Failure, List<OrderEntity>>> fetchOrders() async {
    final String? userId = ref.read(currentUserServiceProvider).currentUserId;

    if (userId == null) {
      return const Left(Failure('User not logged in'));
    }

    return _getMyOrders.execute(userId);
  }

  /// Fetch details for a specific order
  Future<Either<Failure, OrderEntity>> fetchOrderDetails(
    String orderId,
  ) async => await _getOrderDetails.execute(orderId);

  /// Watch order status changes
  Stream<Either<Failure, OrderEntity>> watchOrderStatus(String orderId) =>
      _watchOrderStatus.execute(orderId);
}
