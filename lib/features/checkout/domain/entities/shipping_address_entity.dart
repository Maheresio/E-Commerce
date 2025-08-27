import 'package:equatable/equatable.dart';

class ShippingAddressEntity extends Equatable {
  const ShippingAddressEntity({
    required this.id,
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
  });
  final String id;
  final String name;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    street,
    city,
    state,
    zipCode,
    country,
    isDefault,
  ];

  ShippingAddressEntity copyWith({
    String? id,
    String? name,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    bool? isDefault,
  }) => ShippingAddressEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    street: street ?? this.street,
    city: city ?? this.city,
    state: state ?? this.state,
    zipCode: zipCode ?? this.zipCode,
    country: country ?? this.country,
    isDefault: isDefault ?? this.isDefault,
  );
}
