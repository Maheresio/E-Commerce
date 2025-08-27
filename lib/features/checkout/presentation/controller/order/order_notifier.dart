import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/order_entity.dart';
import 'order_actions.dart';

class OrderNotifier extends Notifier<AsyncValue<List<OrderEntity>>> {
  late final OrderActions _actions;

  @override
  AsyncValue<List<OrderEntity>> build() {
    _actions = OrderActions(ref);
    // Auto-load orders when notifier is built
    _loadOrders();
    return const AsyncLoading();
  }

  /// Load orders for the current user
  Future<void> _loadOrders() async {
    state = const AsyncLoading();

    final Either<Failure, List<OrderEntity>> result =
        await _actions.fetchOrders();

    state = result.fold(
      (Failure failure) => AsyncError(failure.message, StackTrace.current),
      AsyncData.new,
    );
  }

  /// Refresh orders (public method)
  Future<void> refreshOrders() async {
    await _loadOrders();
  }

  /// Submit an order and return client secret for payment
  /// Note: This doesn't affect the orders list state
  Future<String> submitOrder(
    OrderEntity order,
    String customerId,
    String userId,
  ) async {
    final Either<Failure, String> result = await _actions.submitOrder(
      order,
      customerId,
      userId,
    );

    return result.fold((Failure failure) => throw failure, (
      String clientSecret,
    ) {
      // Refresh orders list after successful submission
      _loadOrders();
      return clientSecret;
    });
  }

  /// Submit an order with transaction and return client secret for payment
  /// Note: This doesn't affect the orders list state
  Future<String> submitOrderWithTransaction(
    OrderEntity order,
    String customerId,
    String userId,
  ) async {
    final Either<Failure, String> result = await _actions
        .submitOrderWithTransaction(order, customerId, userId);

    return result.fold((Failure failure) => throw failure, (
      String clientSecret,
    ) {
      // Refresh orders list after successful submission
      _loadOrders();
      return clientSecret;
    });
  }

  /// Fetch details for a specific order
  Future<OrderEntity> fetchOrderDetails(String orderId) async {
    final Either<Failure, OrderEntity> result = await _actions
        .fetchOrderDetails(orderId);

    return result.fold(
      (Failure failure) => throw failure,
      (OrderEntity order) => order,
    );
  }

  /// Watch order status changes
  Stream<OrderEntity> watchOrderStatus(String orderId) =>
      _actions.watchOrderStatus(orderId).map((either) {
        return either.fold((failure) => throw failure, (order) => order);
      });
}

final orderNotifierProvider =
    NotifierProvider<OrderNotifier, AsyncValue<List<OrderEntity>>>(
      OrderNotifier.new,
    );
