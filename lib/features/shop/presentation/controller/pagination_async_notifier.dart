import 'filter_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../home/data/models/product_model.dart';
import '../../../home/domain/entities/product_entity.dart';

typedef FetchFunction =
    Future<Either<Failure, List<ProductEntity>>> Function({
      DocumentSnapshot? lastDocument,
      int pageSize,
    });

List<ProductEntity> _applySorting(
  List<ProductEntity> list,
  FilterParams params,
) {
  final List<ProductEntity> sorted = <ProductEntity>[...list];

  sorted.sort((ProductEntity a, ProductEntity b) {
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

  return sorted;
}

class PaginationAsyncNotifier
    extends FamilyAsyncNotifier<List<ProductEntity>, FetchFunction> {
  late final FetchFunction _fetcher;

  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isLoading = false;
  String? _loadMoreError;

  bool get isLoading => _isLoading;
  String? get loadMoreError => _loadMoreError;

  @override
  Future<List<ProductEntity>> build(FetchFunction fetcher) async {
    _fetcher = fetcher;

    final Either<Failure, List<ProductEntity>> result = await _fetcher(
      lastDocument: null,
      pageSize: 10,
    );
    return result.fold((Failure failure) => throw failure, (
      List<ProductEntity> products,
    ) {
      _lastDocument = (products.lastOrNull as ProductModel?)?.firestoreDoc;
      _hasMore = products.length == 10;
      return _applySorting(products, ref.read(filterParamsProvider));
    });
  }

  void reSort() {
    final List<ProductEntity>? current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(_applySorting(current, ref.read(filterParamsProvider)));
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoading || state.isLoading || state.hasError) return;

    _isLoading = true;
    _loadMoreError = null;

    state = AsyncData(<ProductEntity>[...?state.value]);
    final Either<Failure, List<ProductEntity>> result = await _fetcher(
      lastDocument: _lastDocument,
      pageSize: 10,
    );

    result.fold(
      (Failure failure) {
        _loadMoreError = failure.message;
        state = AsyncData(<ProductEntity>[
          ...?state.value,
        ]); // keep current data
      },
      (List<ProductEntity> products) {
        final List<ProductEntity> updated = <ProductEntity>[
          ...?state.value,
          ...products,
        ];
        state = AsyncData(
          _applySorting(updated, ref.read(filterParamsProvider)),
        );
        _lastDocument = (products.lastOrNull as ProductModel?)?.firestoreDoc;

        _hasMore = products.length == 10;
      },
    );

    _isLoading = false;
  }

  void reset() {
    _lastDocument = null;
    _hasMore = true;
    state = const AsyncLoading();
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    if (_isLoading) return;

    _isLoading = true;
    _lastDocument = null;
    _hasMore = true;
    _loadMoreError = null;

    state = const AsyncLoading();

    final Either<Failure, List<ProductEntity>> result = await _fetcher(
      lastDocument: null,
      pageSize: 10,
    );

    result.fold(
      (Failure failure) => state = AsyncError(failure, StackTrace.current),
      (List<ProductEntity> products) {
        state = AsyncData(
          _applySorting(products, ref.read(filterParamsProvider)),
        );
        _lastDocument = (products.lastOrNull as ProductModel?)?.firestoreDoc;
        _hasMore = products.length == 10;
      },
    );

    _isLoading = false;
  }
}
