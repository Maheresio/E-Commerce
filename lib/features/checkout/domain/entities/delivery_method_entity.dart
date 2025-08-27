import 'package:equatable/equatable.dart';

class DeliveryMethodEntity extends Equatable {
  const DeliveryMethodEntity({
    required this.id,
    required this.name,
    required this.duration,
    required this.cost,
    this.discount = 0.0,
    required this.imageUrl,
  });
  final String id;
  final String name;
  final String duration;
  final double cost;
  final double discount;
  final String imageUrl;

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    duration,
    cost,
    discount,
    imageUrl,
  ];

  bool get isDefault => id == 'default';
}
