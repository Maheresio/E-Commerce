import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/domain/entities/product_entity.dart';
import 'pagination_async_notifier.dart';

// -------------------- Pagination Providers --------------------

final AsyncNotifierProviderFamily<
  PaginationAsyncNotifier,
  List<ProductEntity>,
  FetchFunction
>
allProductsProvider = AsyncNotifierProvider.family<
  PaginationAsyncNotifier,
  List<ProductEntity>,
  FetchFunction
>(PaginationAsyncNotifier.new);

final AsyncNotifierProviderFamily<
  PaginationAsyncNotifier,
  List<ProductEntity>,
  FetchFunction
>
saleProductsProvider = AsyncNotifierProvider.family<
  PaginationAsyncNotifier,
  List<ProductEntity>,
  FetchFunction
>(PaginationAsyncNotifier.new);

final AsyncNotifierProviderFamily<
  PaginationAsyncNotifier,
  List<ProductEntity>,
  FetchFunction
>
newestProductsProvider = AsyncNotifierProvider.family<
  PaginationAsyncNotifier,
  List<ProductEntity>,
  FetchFunction
>(PaginationAsyncNotifier.new);

final AsyncNotifierProviderFamily<
  PaginationAsyncNotifier,
  List<ProductEntity>,
  FetchFunction
>
newestByGenderProvider = AsyncNotifierProvider.family<
  PaginationAsyncNotifier,
  List<ProductEntity>,
  FetchFunction
>(PaginationAsyncNotifier.new);

final AsyncNotifierProviderFamily<
  PaginationAsyncNotifier,
  List<ProductEntity>,
  FetchFunction
>
productsByGenderProvider = AsyncNotifierProvider.family<
  PaginationAsyncNotifier,
  List<ProductEntity>,
  FetchFunction
>(PaginationAsyncNotifier.new);

final AsyncNotifierProviderFamily<
  PaginationAsyncNotifier,
  List<ProductEntity>,
  FetchFunction
>
productsByGenderAndSubProvider = AsyncNotifierProvider.family<
  PaginationAsyncNotifier,
  List<ProductEntity>,
  FetchFunction
>(PaginationAsyncNotifier.new);

final AsyncNotifierProviderFamily<
  PaginationAsyncNotifier,
  List<ProductEntity>,
  FetchFunction
>
filteredProductsProvider = AsyncNotifierProvider.family<
  PaginationAsyncNotifier,
  List<ProductEntity>,
  FetchFunction
>(PaginationAsyncNotifier.new);
