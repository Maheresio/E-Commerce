import 'package:equatable/equatable.dart';

import 'review_entity.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final List<String> tags;
  final double price;
  final double? discountedPrice;
  final int discountValue;
  final List<String> sizes;
  final List<String> colors;
  final String brand;
  final String description;
  final int reviewCount;
  final double rating;
  final List<ReviewEntity>? reviews;
  final Map<String, List<String>> imageUrls;
  final bool isFavorite;
  final bool isInStock;
  final Map<int, int> ratingsBreakdown;
  final String gender;
  final DateTime createdAt;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.tags,
    required this.price,
    this.discountedPrice,
    required this.discountValue,
    required this.sizes,
    required this.colors,
    required this.brand,
    required this.description,
    required this.reviewCount,
    required this.rating,
    this.reviews,
    required this.imageUrls,
    required this.isFavorite,
    required this.isInStock,
    required this.ratingsBreakdown,
    required this.gender,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    tags,
    price,
    discountedPrice,
    discountValue,
    sizes,
    colors,
    brand,
    description,
    reviewCount,
    rating,
    reviews,
    imageUrls,
    isFavorite,
    isInStock,
    ratingsBreakdown,
    gender,
    createdAt,
  ];
}
