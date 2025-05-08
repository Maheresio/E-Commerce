import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final double price;
  final String imgUrl;
  final int discountValue;
  final String category;
  final int rate;
  final int reviewCount;
  final bool isFavorite;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.imgUrl,
    required this.discountValue,
    required this.category,
    required this.rate,
    required this.reviewCount,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    imgUrl,
    discountValue,
    category,
    rate,
    reviewCount,
    isFavorite,
  ];
}
