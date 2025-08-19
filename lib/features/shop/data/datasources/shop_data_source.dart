import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/services/firestore_sevice.dart';
import '../../../home/data/models/product_model.dart';

import '../../presentation/controller/filter_models.dart';

abstract class ShopDataSource {
  Future<List<ProductModel>> getAllProducts({
    DocumentSnapshot? lastDocument,
    int pageSize,
  });

  Future<List<ProductModel>> getSaleProducts({
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  });
  Future<List<ProductModel>> getNewestProducts({
    DocumentSnapshot? lastDocument,
    int pageSize,
  });

  Future<List<ProductModel>> getNewestProductsByGender(
    String gender, {
    DocumentSnapshot? lastDocument,
    int pageSize,
  });

  Future<List<ProductModel>> getProductsByGender(
    String gender, {
    DocumentSnapshot? lastDocument,
    int pageSize,
  });

  Future<List<ProductModel>> getProductsByGenderAndSubCategory(
    String gender,
    String subCategory, {
    DocumentSnapshot? lastDocument,
    int pageSize,
  });

  Future<List<ProductModel>> getFilteredProducts(
    FilterParams params, {
    DocumentSnapshot? lastDocument,
    int pageSize,
  });
}

class ShopDataSourceImpl implements ShopDataSource {
  ShopDataSourceImpl(this.firestore);
  final FirestoreServices firestore;

  @override
  Future<List<ProductModel>> getAllProducts({
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) => firestore.getCollection(
    path: FirestoreConstants.products,
    builder: (data, id, doc) => ProductModel.fromMap(data!, id, doc),
    lastDocument: lastDocument,
    pageSize: pageSize,
  );

  @override
  Future<List<ProductModel>> getSaleProducts({
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) => firestore.getCollection(
    path: FirestoreConstants.products,
    queryBuilder:
        (query) => query
            .where('discountValue', isGreaterThan: 0)
            .orderBy('discountValue', descending: true),
    builder: (data, id, doc) => ProductModel.fromMap(data!, id, doc),
    lastDocument: lastDocument,
    pageSize: pageSize,
  );

  @override
  Future<List<ProductModel>> getNewestProducts({
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) => firestore.getCollection(
    path: FirestoreConstants.products,
    builder: (data, id, doc) => ProductModel.fromMap(data!, id, doc),
    queryBuilder: (query) => query.orderBy('createdAt', descending: true),
    lastDocument: lastDocument,
    pageSize: pageSize,
  );

  @override
  Future<List<ProductModel>> getNewestProductsByGender(
    String gender, {
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) => firestore.getCollection(
    path: FirestoreConstants.products,
    builder: (data, id, doc) => ProductModel.fromMap(data!, id, doc),
    queryBuilder:
        (query) => query
            .where('gender', isEqualTo: gender)
            .orderBy('createdAt', descending: true),
    lastDocument: lastDocument,
    pageSize: pageSize,
  );

  @override
  Future<List<ProductModel>> getProductsByGender(
    String gender, {
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) => firestore.getCollection(
    path: FirestoreConstants.products,
    builder: (data, id, doc) => ProductModel.fromMap(data!, id, doc),
    queryBuilder: (query) => query.where('gender', isEqualTo: gender),
    lastDocument: lastDocument,
    pageSize: pageSize,
  );

  @override
  Future<List<ProductModel>> getProductsByGenderAndSubCategory(
    String gender,
    String subCategory, {
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) => firestore.getCollection(
    path: FirestoreConstants.products,
    builder: (data, id, doc) => ProductModel.fromMap(data!, id, doc),
    queryBuilder:
        (query) => query
            .where('gender', isEqualTo: gender)
            .where('subCategory', isEqualTo: subCategory),
    lastDocument: lastDocument,
    pageSize: pageSize,
  );

  @override
  Future<List<ProductModel>> getFilteredProducts(
    FilterParams params, {
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) async {
    // Basic query with at most 1 simple equality filter
    final Future<List<ProductModel>> baseQuery = firestore.getCollection(
      path: FirestoreConstants.products,
      builder:
          (
            Map<String, dynamic>? data,
            String id,
            DocumentSnapshot<Object?> doc,
          ) => ProductModel.fromMap(data!, id, doc),
      queryBuilder: (Query<Object?> query) {
        // Only apply ONE equality where clause to avoid composite index
        if (params.gender != 'All') {
          query = query.where('gender', isEqualTo: params.gender);
        }
        return query;
      },
      lastDocument: lastDocument,
      pageSize: pageSize,
    );

    final List<ProductModel> fetched = await baseQuery;

    // Client-side filtering logic
    return fetched.where((ProductModel product) {
        final bool matchesSubCategory =
            params.subCategory.isEmpty ||
            product.subCategory == params.subCategory;

        final bool matchesColors =
            params.colors == null ||
            params.colors!.isEmpty ||
            hasIntersection(params.colors, product.colors);

        final bool matchesSizes =
            params.sizes == null ||
            params.sizes!.isEmpty ||
            hasIntersection(params.sizes, product.sizes);

        final bool matchesBrands =
            params.brands == null ||
            params.brands!.isEmpty ||
            params.brands!.contains(product.brand);
        final bool matchesPrice =
            (params.priceMin == null || product.price >= params.priceMin!) &&
            (params.priceMax == null || product.price <= params.priceMax!);

        final bool matchesTags =
            params.tags == null ||
            params.tags!.isEmpty ||
            hasIntersection(params.tags, product.tags);

        return matchesSubCategory &&
            matchesColors &&
            matchesSizes &&
            matchesBrands &&
            matchesPrice &&
            matchesTags;
      }).toList()
      ..sort((ProductModel a, ProductModel b) {
        switch (params.sortBy) {
          case SortOption.newest:
            return b.createdAt.compareTo(a.createdAt);
          case SortOption.priceLowToHigh:
            return a.price.compareTo(b.price);
          case SortOption.priceHighToLow:
            return b.price.compareTo(a.price);
          case SortOption.customerReview:
            return b.rating.compareTo(a.rating);
          case SortOption.popularity:
            return b.reviewCount.compareTo(a.reviewCount);
          default:
            return 0;
        }
      });
  }

  bool hasIntersection(List<String>? a, List<String>? b) {
    if (a == null || a.isEmpty || b == null || b.isEmpty) return false;
    return a.any(b.contains);
  }
}
