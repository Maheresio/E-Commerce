import 'package:equatable/equatable.dart';

enum PaymentStatus { succeeded, processing, failed }

class PaymentEntity extends Equatable {
  const PaymentEntity({
    required this.id,
    required this.currency,
    required this.amount,
    required this.paymentMethodId,
    required this.status,
    required this.timestamp,
  });

  factory PaymentEntity.fromMap(Map<String, dynamic> map) {
    return PaymentEntity(
      id: map['id'],
      currency: map['currency'],
      amount: (map['amount'] as num).toDouble(),
      paymentMethodId: map['paymentMethodId'],
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => PaymentStatus.failed,
      ),
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
  final String id;
  final String currency;
  final double amount;
  final String paymentMethodId;
  final PaymentStatus status;
  final DateTime timestamp;

  @override
  List<Object?> get props => <Object?>[
    id,
    currency,
    amount,
    paymentMethodId,
    status,
    timestamp,
  ];

  PaymentEntity copyWith({
    String? id,
    String? currency,
    double? amount,
    String? paymentMethodId,
    PaymentStatus? status,
    DateTime? timestamp,
  }) => PaymentEntity(
    id: id ?? this.id,
    currency: currency ?? this.currency,
    amount: amount ?? this.amount,
    paymentMethodId: paymentMethodId ?? this.paymentMethodId,
    status: status ?? this.status,
    timestamp: timestamp ?? this.timestamp,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'currency': currency,
    'amount': amount,
    'paymentMethodId': paymentMethodId,
    'status': status.name,
    'timestamp': timestamp.toIso8601String(),
  };
}
