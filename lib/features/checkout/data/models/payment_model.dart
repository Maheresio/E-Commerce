import '../../domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.currency,
    required super.amount,
    required super.paymentMethodId,
    required super.status,
    required super.timestamp,
  });

  factory PaymentModel.fromEntity(PaymentEntity entity) => PaymentModel(
    id: entity.id,
    currency: entity.currency,
    amount: entity.amount,
    paymentMethodId: entity.paymentMethodId,
    status: entity.status,
    timestamp: entity.timestamp,
  );

  factory PaymentModel.fromMap(Map<String, dynamic> json, String id) =>
      PaymentModel(
        id: id,
        currency: json['currency'] as String,
        amount: (json['amount'] as num).toDouble(),
        paymentMethodId: json['paymentMethodId'],
        status: json['status'],
        timestamp: DateTime.parse(json['timestamp']),
      );

  @override
  Map<String, dynamic> toMap() => {
    'currency': currency,
    'amount': amount,
    'paymentMethodId': paymentMethodId,
    'status': status,
    'timestamp': timestamp.toIso8601String(),
  };
}
