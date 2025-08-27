import '../../domain/entities/shipping_address_entity.dart';

class ShippingAddressModel extends ShippingAddressEntity {
  factory ShippingAddressModel.fromEntity(ShippingAddressEntity entity) {
    return ShippingAddressModel(
      id: entity.id,
      name: entity.name,
      street: entity.street,
      city: entity.city,
      state: entity.state,
      zipCode: entity.zipCode,
      country: entity.country,
      isDefault: entity.isDefault,
    );
  }
  const ShippingAddressModel({
    required super.id,
    required super.name,
    required super.street,
    required super.city,
    required super.state,
    required super.zipCode,
    required super.country,
    required super.isDefault,
  });

  factory ShippingAddressModel.fromMap(Map<String, dynamic> json, String id) =>
      ShippingAddressModel(
        id: id,
        name: json['name'] ?? '',
        street: json['street'] ?? '',
        city: json['city'] ?? '',
        state: json['state'] ?? '',
        zipCode: json['zipCode'] ?? '',
        country: json['country'] ?? '',
        isDefault: json['isDefault'] ?? false,
      );

  Map<String, dynamic> toMap() => {
    'name': name,
    'street': street,
    'city': city,
    'state': state,
    'zipCode': zipCode,
    'country': country,
    'isDefault': isDefault,
  };

  ShippingAddressEntity toEntity() => ShippingAddressEntity(
    id: id,
    name: name,
    street: street,
    city: city,
    state: state,
    zipCode: zipCode,
    country: country,
    isDefault: isDefault,
  );
}
