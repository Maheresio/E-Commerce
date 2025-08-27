import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/handle_repository_exceptions.dart';
import '../../../../core/services/current_user_service.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl({required this.remote, required this.currentUserService});
  final OrderRemoteDataSource remote;
  final CurrentUserService currentUserService;

  @override
  Future<Either<Failure, String>> submitOrder(
    OrderEntity order,
    String customerId, {
    String? paymentMethodId,
  }) async => handleRepositoryExceptions<String>(() async {
    final userId = currentUserService.currentUserId;
    if (userId == null) throw Exception('User not logged in');

    final model = OrderModel.fromEntity(
      order,
      userId,
    ).copyWith(status: order.status);

    // Save order in Firestore
    await remote.submitOrder(model);

    // Create PaymentIntent (with or without card)
    final clientSecret = await remote.createPaymentIntent(
      orderId: order.id,
      customerId: customerId,
      amount: order.totalAmount,
      paymentMethodId: paymentMethodId,
    );

    return clientSecret;
  });

  @override
  Future<Either<Failure, String>> submitOrderWithTransaction(
    OrderEntity order,
    String customerId, {
    String? paymentMethodId,
  }) async => handleRepositoryExceptions<String>(() async {
    final userId = currentUserService.currentUserId;
    if (userId == null) throw Exception('User not logged in');

    final model = OrderModel.fromEntity(
      order,
      userId,
    ).copyWith(status: order.status);

    // Check for existing order with same ID (idempotency check)
    final existingOrder = await remote.checkOrderExists(order.id);
    if (existingOrder != null) {
      // Order already exists, return existing payment intent
      return await remote.getExistingPaymentIntent(order.id);
    }

    // Use Firestore transaction for atomic order creation
    final clientSecret = await remote.submitOrderWithTransaction(
      model,
      customerId: customerId,
      amount: order.totalAmount,
      paymentMethodId: paymentMethodId,
    );

    return clientSecret;
  });

  @override
  Future<Either<Failure, String>> createPaymentIntentOnly(
    OrderEntity order,
    String customerId, {
    String? paymentMethodId,
  }) async => handleRepositoryExceptions<String>(() async {
    final userId = currentUserService.currentUserId;
    if (userId == null) throw Exception('User not logged in');

    // Create PaymentIntent WITHOUT saving order to Firestore
    final clientSecret = await remote.createPaymentIntent(
      orderId: order.id,
      customerId: customerId,
      amount: order.totalAmount,
      paymentMethodId: paymentMethodId,
    );

    return clientSecret;
  });

  @override
  Future<Either<Failure, void>> saveOrderAfterPayment(
    OrderEntity order,
  ) async => handleRepositoryExceptions<void>(() async {
    final userId = currentUserService.currentUserId;
    if (userId == null) throw Exception('User not logged in');

    final model = OrderModel.fromEntity(order, userId).copyWith(
      status: OrderStatus.completed,
    ); // Mark as completed after payment

    // Save order to Firestore after successful payment
    await remote.submitOrder(model);
  });

  @override
  Future<Either<Failure, List<OrderEntity>>> getMyOrders(String userId) async =>
      handleRepositoryExceptions<List<OrderEntity>>(() async {
        final models = await remote.getMyOrders(userId);
        return models.map((m) => m.toEntity()).toList();
      });

  @override
  Future<Either<Failure, OrderEntity>> getOrderDetails(String orderId) async =>
      handleRepositoryExceptions<OrderEntity>(() async {
        final model = await remote.getOrderDetails(orderId);
        return model.toEntity();
      });

  @override
  Stream<Either<Failure, OrderEntity>> watchOrderStatus(String orderId) =>
      remote.watchOrderStatus(orderId).map((model) {
        try {
          return Right(model.toEntity());
        } catch (e) {
          return Left(Failure('Failed to parse order status: $e'));
        }
      });
}
