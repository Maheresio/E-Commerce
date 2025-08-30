import 'package:equatable/equatable.dart';

import '../../../cart/domain/entities/cart_item_entity.dart';
import 'delivery_method_entity.dart';
import 'payment_entity.dart';
import 'shipping_address_entity.dart';
import 'visa_card_entity.dart';

enum OrderStatus {
  pending, // Order created but payment not started
  processing, // Payment in progress
  completed, // Payment successful and order confirmed
  delivered, // Order has been delivered
  cancelled, // Order was cancelled
  failed, // Payment failed
}

enum OrderCreationStatus {
  draft, // Order being prepared
  submitted, // Order submitted to system
  confirmed, // Order confirmed and saved
  duplicate, // Duplicate order detected
}

class OrderEntity extends Equatable {
  const OrderEntity({
    required this.userId,
    required this.id,
    required this.code,
    required this.trackingNumber,
    required this.date,
    required this.totalAmount,
    required this.quantity,
    required this.cartItems, // Changed from products to cartItems
    required this.shippingAddress,
    required this.paymentMethod,
    required this.deliveryMethod,
    required this.status,
    required this.payment,
    this.idempotencyKey,
    required this.createdAt,
    this.updatedAt,
  });

  // Factory for creating an order with deterministic ID
  factory OrderEntity.createWithDeterministicId({
    required String userId,
    required double totalAmount,
    required int quantity,
    required List<CartItemEntity>
    cartItems, // Changed from products to cartItems
    required ShippingAddressEntity shippingAddress,
    required VisaCardEntity paymentMethod,
    required DeliveryMethodEntity deliveryMethod,
    required PaymentEntity payment,
    String? idempotencyKey,
  }) {
    final now = DateTime.now();
    final productIds =
        cartItems
            .map((cartItem) => cartItem.productId)
            .toList(); // Extract product IDs for deterministic ID generation
    final deterministicId = _generateDeterministicId(
      userId: userId,
      productIds: productIds,
      totalAmount: totalAmount,
      timestamp: now,
      idempotencyKey: idempotencyKey,
    );

    return OrderEntity(
      userId: userId,
      id: deterministicId,
      code: _generateOrderCode(deterministicId),
      trackingNumber: _generateTrackingNumber(deterministicId),
      date: now,
      totalAmount: totalAmount,
      quantity: quantity,
      cartItems: cartItems, // Changed from products to cartItems
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      deliveryMethod: deliveryMethod,
      status: OrderStatus.pending,
      payment: payment,
      idempotencyKey: idempotencyKey,
      createdAt: now,
      updatedAt: null,
    );
  }
  final String id;
  final String code;
  final String trackingNumber;
  final DateTime date;
  final double totalAmount;
  final int quantity;
  final List<CartItemEntity> cartItems; // Changed from products to cartItems
  final ShippingAddressEntity shippingAddress;
  final VisaCardEntity paymentMethod;
  final DeliveryMethodEntity deliveryMethod;
  final OrderStatus status;
  final PaymentEntity payment;
  final String userId;
  final String? idempotencyKey; // For preventing duplicates
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Generate deterministic ID based on order content
  static String _generateDeterministicId({
    required String userId,
    required List<String> productIds,
    required double totalAmount,
    required DateTime timestamp,
    String? idempotencyKey,
  }) {
    final List<String> sortedProductIds = List<String>.from(productIds)..sort();
    final String content = <String>[
      userId,
      ...sortedProductIds,
      totalAmount.toStringAsFixed(2),
      timestamp.millisecondsSinceEpoch.toString(),
      idempotencyKey ?? '',
    ].join('|');

    // Create hash-based deterministic ID
    return 'order_${content.hashCode.abs()}';
  }

  static String _generateOrderCode(String orderId) {
    final String suffix = orderId.hashCode
        .abs()
        .toString()
        .padLeft(6, '0')
        .substring(0, 6);
    return 'ORD$suffix';
  }

  static String _generateTrackingNumber(String orderId) {
    final String suffix = orderId.hashCode
        .abs()
        .toString()
        .padLeft(8, '0')
        .substring(0, 8);
    return 'TRK$suffix';
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    code,
    trackingNumber,
    date,
    totalAmount,
    quantity,
    cartItems, // Changed from products to cartItems
    shippingAddress,
    paymentMethod,
    deliveryMethod,
    status,
    payment,
    userId,
    idempotencyKey,
    createdAt,
    updatedAt,
  ];
}
