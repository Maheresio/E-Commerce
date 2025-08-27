import '../../domain/entities/delivery_method_entity.dart';

class DeliveryMethodModel extends DeliveryMethodEntity {
  const DeliveryMethodModel({
    required super.id,
    required super.name,
    required super.duration,
    required super.cost,
    required super.imageUrl,
    super.discount = 0.0,
  });

  factory DeliveryMethodModel.fromMap(Map<String, dynamic> json, String id) =>
      DeliveryMethodModel(
        id: id,
        name: json['name'],
        duration: json['duration'],
        cost: (json['cost'] as num).toDouble(),
        discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
        imageUrl: json['imageUrl'] ?? '',
      );

  Map<String, dynamic> toMap() => {
    'name': name,
    'duration': duration,
    'cost': cost,
    'discount': discount,
    'imageUrl': imageUrl,
  };

  DeliveryMethodEntity toEntity() => DeliveryMethodEntity(
    id: id,
    name: name,
    duration: duration,
    cost: cost,
    discount: discount,
    imageUrl: imageUrl,
  );
}
