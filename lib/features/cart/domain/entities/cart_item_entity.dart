import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.selectedSize,
    required this.selectedColor,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.brand,
  });
  final String id; // Firestore doc ID
  final String productId;
  final int quantity;
  final String selectedSize;
  final String selectedColor;
  final String imageUrl;
  final String name;
  final String brand;
  final double price;

  CartItemEntity copyWith({
    String? id,
    String? productId,
    int? quantity,
    String? selectedSize,
    String? selectedColor,
    String? imageUrl,
    String? name,
    double? price,
    String? brand,
  }) => CartItemEntity(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
    selectedSize: selectedSize ?? this.selectedSize,
    selectedColor: selectedColor ?? this.selectedColor,
    imageUrl: imageUrl ?? this.imageUrl,
    name: name ?? this.name,
    price: price ?? this.price,
    brand: brand ?? this.brand,
  );

  @override
  List<Object?> get props => <Object?>[
    id,
    productId,
    quantity,
    selectedSize,
    selectedColor,
    imageUrl,
    name,
    price,
    brand,
  ];
}
