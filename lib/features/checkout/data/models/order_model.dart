import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../domain/entities/delivery_method_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/shipping_address_entity.dart';
import '../../domain/entities/visa_card_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.code,
    required super.trackingNumber,
    required super.date,
    required super.totalAmount,
    required super.quantity,
    required super.cartItems, // Changed from products to cartItems
    required super.shippingAddress,
    required super.paymentMethod,
    required super.deliveryMethod,
    required super.status,
    required super.payment,
    required super.userId,
    required super.idempotencyKey,
    required super.createdAt,
    required super.updatedAt,
  });

  factory OrderModel.fromMap(String id, Map<String, dynamic> json) =>
      OrderModel(
        id: id,
        code: json['code'],
        date: DateTime.parse(json['date']),
        trackingNumber: json['trackingNumber'] ?? 'PENDING',
        totalAmount: (json['totalAmount'] as num).toDouble(),
        quantity: json['quantity'] as int,
        cartItems:
            json['cartItems'] != null
                ? (json['cartItems'] as List).map((cartItemJson) {
                  // Create CartItemEntity directly from stored data
                  return CartItemEntity(
                    id: cartItemJson['id'] ?? '',
                    productId: cartItemJson['productId'] ?? '',
                    quantity: cartItemJson['quantity'] ?? 1,
                    selectedSize: cartItemJson['selectedSize'] ?? '',
                    selectedColor: cartItemJson['selectedColor'] ?? '',
                    imageUrl: cartItemJson['imageUrl'] ?? '',
                    name: cartItemJson['name'] ?? '',
                    price: (cartItemJson['price'] as num?)?.toDouble() ?? 0.0,
                    brand:
                        cartItemJson['brand'] ??
                        '', // Default to empty string if not provided
                  );
                }).toList()
                : [], // Fallback to empty list if no products
        shippingAddress: ShippingAddressEntity(
          id: json['shippingAddress']['id'],
          name: json['shippingAddress']['name'],
          street: json['shippingAddress']['street'],
          city: json['shippingAddress']['city'],
          state: json['shippingAddress']['state'],
          zipCode: json['shippingAddress']['zipCode'],
          country: json['shippingAddress']['country'],
          isDefault: json['shippingAddress']['isDefault'],
        ),
        paymentMethod: VisaCardEntity(
          id: json['paymentMethod']['id'],
          last4: json['paymentMethod']['last4'],
          expMonth: json['paymentMethod']['expMonth'],
          expYear: json['paymentMethod']['expYear'],
          holderName: json['paymentMethod']['holderName'],
          isDefault: json['paymentMethod']['isDefault'],
        ),
        deliveryMethod: DeliveryMethodEntity(
          id: json['deliveryMethod']['id'],
          name: json['deliveryMethod']['name'],
          duration: json['deliveryMethod']['duration'],
          cost: (json['deliveryMethod']['cost'] as num).toDouble(),
          discount:
              (json['deliveryMethod']['discount'] as num?)?.toDouble() ?? 0.0,
          imageUrl: json['deliveryMethod']['imageUrl'] ?? '',
        ),
        status: OrderStatus.values.byName(json['status']),
        payment: PaymentEntity(
          id: json['payment']['id'],
          currency: json['payment']['currency'],
          amount: (json['payment']['amount'] as num).toDouble(),
          paymentMethodId: json['payment']['paymentMethodId'],
          status: PaymentStatus.values.firstWhere(
            (e) => e.name == json['payment']['status'],
            orElse: () => PaymentStatus.failed,
          ),
          timestamp: DateTime.parse(json['payment']['timestamp']),
        ),
        userId: json['userId'],
        idempotencyKey: json['idempotencyKey'] ?? '',
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt:
            json['updatedAt'] != null
                ? DateTime.parse(json['updatedAt'])
                : DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'code': code,
    'date': date.toIso8601String(),
    'trackingNumber': trackingNumber,
    'totalAmount': totalAmount,
    'quantity': quantity,
    'cartItems':
        cartItems
            .map(
              (cartItem) => {
                'id': cartItem.id,
                'productId': cartItem.productId,
                'quantity': cartItem.quantity,
                'selectedSize': cartItem.selectedSize,
                'selectedColor': cartItem.selectedColor,
                'imageUrl': cartItem.imageUrl,
                'name': cartItem.name,
                'price': cartItem.price,
                'brand': cartItem.brand,
              },
            )
            .toList(),
    'shippingAddress': {
      'id': shippingAddress.id,
      'name': shippingAddress.name,
      'street': shippingAddress.street,
      'city': shippingAddress.city,
      'state': shippingAddress.state,
      'zipCode': shippingAddress.zipCode,
      'country': shippingAddress.country,
      'isDefault': shippingAddress.isDefault,
    },
    'paymentMethod': {
      'id': paymentMethod.id,
      'last4': paymentMethod.last4,
      'expMonth': paymentMethod.expMonth,
      'expYear': paymentMethod.expYear,
      'holderName': paymentMethod.holderName,
      'isDefault': paymentMethod.isDefault,
    },
    'deliveryMethod': {
      'id': deliveryMethod.id,
      'name': deliveryMethod.name,
      'duration': deliveryMethod.duration,
      'cost': deliveryMethod.cost,
      'discount': deliveryMethod.discount,
      'imageUrl': deliveryMethod.imageUrl,
    },
    'status': status.name,
    'payment': {
      'id': payment.id,
      'currency': payment.currency,
      'amount': payment.amount,
      'paymentMethodId': payment.paymentMethodId,
      'status': payment.status.name,
      'timestamp': payment.timestamp.toIso8601String(),
    },
    'idempotencyKey': idempotencyKey,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt':
        DateTime.now().toIso8601String(), // Real timestamp for new orders
  };

  OrderEntity toEntity() => OrderEntity(
    id: id,
    code: code,
    date: date,
    trackingNumber: trackingNumber,
    totalAmount: totalAmount,
    quantity: quantity,
    cartItems: cartItems, // Changed from products to cartItems
    shippingAddress: shippingAddress,
    paymentMethod: paymentMethod,
    deliveryMethod: deliveryMethod,
    status: status,
    payment: payment,
    userId: userId,
    idempotencyKey: idempotencyKey,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static OrderModel fromEntity(OrderEntity entity, String userId) => OrderModel(
    id: entity.id,
    code: entity.code,
    date: entity.date,
    trackingNumber: entity.trackingNumber,
    totalAmount: entity.totalAmount,
    quantity: entity.quantity,
    cartItems: entity.cartItems, // Changed from products to cartItems
    shippingAddress: entity.shippingAddress,
    paymentMethod: entity.paymentMethod,
    deliveryMethod: entity.deliveryMethod,
    status: entity.status,
    payment: entity.payment,
    userId: userId,
    idempotencyKey: entity.idempotencyKey,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt ?? DateTime.now(),
  );

  OrderModel copyWith({
    String? id,
    String? code,
    String? trackingNumber,
    DateTime? date,
    double? totalAmount,
    int? quantity,
    List<CartItemEntity>? cartItems, // Changed from products to cartItems
    ShippingAddressEntity? shippingAddress,
    VisaCardEntity? paymentMethod,
    DeliveryMethodEntity? deliveryMethod,
    OrderStatus? status,
    PaymentEntity? payment,
    String? userId,
  }) => OrderModel(
    id: id ?? this.id,
    code: code ?? this.code,
    trackingNumber: trackingNumber ?? this.trackingNumber,
    date: date ?? this.date,
    totalAmount: totalAmount ?? this.totalAmount,
    quantity: quantity ?? this.quantity,
    cartItems:
        cartItems ?? this.cartItems, // Changed from products to cartItems
    shippingAddress: shippingAddress ?? this.shippingAddress,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    deliveryMethod: deliveryMethod ?? this.deliveryMethod,
    status: status ?? this.status,
    payment: payment ?? this.payment,
    userId: userId ?? this.userId,
    idempotencyKey: idempotencyKey,
    createdAt: createdAt,
    updatedAt: updatedAt ?? DateTime.now(),
  );
}
