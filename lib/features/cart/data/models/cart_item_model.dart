import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.productId,
    required super.quantity,
    required super.selectedSize,
    required super.selectedColor,
    required super.imageUrl,
    required super.name,
    required super.price,
    required super.brand,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map, String id) =>
      CartItemModel(
        id: id,
        productId: map['productId'],
        quantity: map['quantity'],
        selectedSize: map['selectedSize'],
        selectedColor: map['selectedColor'],
        imageUrl: map['imageUrl'],
        name: map['name'],
        price: (map['price'] as num).toDouble(),
        brand: map['brand'], // Default to empty string if not provided
      );

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'quantity': quantity,
    'selectedSize': selectedSize,
    'selectedColor': selectedColor,
    'imageUrl': imageUrl,
    'name': name,
    'price': price,
    'brand': brand,
  };
}
