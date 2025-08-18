import 'package:equatable/equatable.dart';

import '../../../review/domain/entities/review_entity.dart';

class ProductEntity extends Equatable {
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
    required this.subCategory,
  });
  final String id;
  final String name;
  final String category;
  final String subCategory;
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

  ProductEntity copyWith({
    String? id,
    String? name,
    String? category,
    String? subCategory,
    List<String>? tags,
    double? price,
    double? discountedPrice,
    int? discountValue,
    List<String>? sizes,
    List<String>? colors,
    String? brand,
    String? description,
    int? reviewCount,
    double? rating,
    List<ReviewEntity>? reviews,
    Map<String, List<String>>? imageUrls,
    bool? isFavorite,
    bool? isInStock,
    Map<int, int>? ratingsBreakdown,
    String? gender,
    DateTime? createdAt,
  }) => ProductEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    subCategory: subCategory ?? this.subCategory,
    tags: tags ?? this.tags,
    price: price ?? this.price,
    discountedPrice: discountedPrice ?? this.discountedPrice,
    discountValue: discountValue ?? this.discountValue,
    sizes: sizes ?? this.sizes,
    colors: colors ?? this.colors,
    brand: brand ?? this.brand,
    description: description ?? this.description,
    reviewCount: reviewCount ?? this.reviewCount,
    rating: rating ?? this.rating,
    reviews: reviews ?? this.reviews,
    imageUrls: imageUrls ?? this.imageUrls,
    isFavorite: isFavorite ?? this.isFavorite,
    isInStock: isInStock ?? this.isInStock,
    ratingsBreakdown: ratingsBreakdown ?? this.ratingsBreakdown,
    gender: gender ?? this.gender,
    createdAt: createdAt ?? this.createdAt,
  );

  @override
  List<Object?> get props => <Object?>[
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
