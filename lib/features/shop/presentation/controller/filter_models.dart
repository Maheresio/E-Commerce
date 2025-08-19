import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SortOption {
  newest,
  popularity,
  priceLowToHigh,
  priceHighToLow,
  customerReview,
}

extension SortOptionExtension on SortOption {
  String get displayName {
    switch (this) {
      case SortOption.newest:
        return 'Newest';
      case SortOption.popularity:
        return 'Popularity';
      case SortOption.priceLowToHigh:
        return 'Price: Low to High';
      case SortOption.priceHighToLow:
        return 'Price: High to Low';
      case SortOption.customerReview:
        return 'Customer Review';
    }
  }
}

class FilterParams extends Equatable {
  const FilterParams({
    required this.subCategory,
    required this.gender,
    this.priceMin,
    this.priceMax,
    this.colors,
    this.sizes,
    this.brands,
    this.tags,
    this.sortBy,
  });
  final String subCategory;
  final String gender;
  final double? priceMin;
  final double? priceMax;
  final List<String>? colors;
  final List<String>? sizes;
  final List<String>? brands;
  final List<String>? tags;
  final SortOption? sortBy;

  @override
  List<Object?> get props => <Object?>[
    subCategory,
    gender,
    priceMin,
    priceMax,
    colors,
    sizes,
    brands,
    tags,
    sortBy,
  ];

  FilterParams copyWith({
    String? subCategory,
    String? gender,
    double? priceMin,
    double? priceMax,
    List<String>? colors,
    List<String>? sizes,
    List<String>? brands,
    List<String>? tags,
    SortOption? sortBy,
  }) => FilterParams(
    subCategory: subCategory ?? this.subCategory,
    gender: gender ?? this.gender,
    priceMin: priceMin ?? this.priceMin,
    priceMax: priceMax ?? this.priceMax,
    colors: colors ?? this.colors,
    sizes: sizes ?? this.sizes,
    brands: brands ?? this.brands,
    tags: tags ?? this.tags,
    sortBy: sortBy ?? this.sortBy,
  );
}

class ProductsByGenderAndSubParams extends Equatable {
  const ProductsByGenderAndSubParams({
    required this.gender,
    required this.subCategory,
  });
  final String gender;
  final String subCategory;

  @override
  List<Object> get props => <Object>[gender, subCategory];
}

final StateProvider<FilterParams> filterParamsProvider =
    StateProvider<FilterParams>(
      (ref) => const FilterParams(
        subCategory: '',
        gender: 'women',
        priceMin: 0,
        priceMax: 10000,
        colors: [],
        sizes: [],
        brands: [],
        tags: [],
        sortBy: SortOption.popularity,
      ),
    );

final StateProvider<FilterParams> tempFilterParamsProvider =
    StateProvider<FilterParams>(( ref) {
      // Start with a clone of the actual filter
      return ref.read(filterParamsProvider);
    });
