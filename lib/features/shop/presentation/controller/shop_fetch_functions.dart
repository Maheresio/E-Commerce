import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pagination_async_notifier.dart';
import '../../domain/usecases/get_all_products_usecase.dart';
import '../../domain/usecases/get_filtered_products_usecase.dart';
import '../../domain/usecases/get_new_products_usecase.dart';
import '../../domain/usecases/get_newest_products_by_gender_usecase.dart';
import '../../domain/usecases/get_products_by_gender_and_subcategory_usecase.dart';
import '../../domain/usecases/get_products_by_gender_usecase.dart';
import '../../domain/usecases/get_sale_products_usecase.dart';
import 'filter_models.dart';
import 'shop_usecase_providers.dart';

// -------------------- Fetch Functions --------------------

// Fetch function for all products
FetchFunction getAllProductsFetch(WidgetRef ref) => ({
  lastDocument,
  pageSize = 20, // Updated default
}) async {
  final GetAllProductsUseCase useCase = ref.read(getAllProductsUseCaseProvider);
  return useCase.execute(lastDocument: lastDocument, pageSize: pageSize);
};

// Fetch function for sale products
FetchFunction getSaleProductsFetch(WidgetRef ref) => ({
  lastDocument,
  pageSize = 20, // Updated default
}) async {
  final GetSaleProductsUsecase useCase = ref.read(
    getSaleProductsUseCaseProvider,
  );
  return useCase.execute(lastDocument: lastDocument, pageSize: pageSize);
};

// Fetch function for newest products
FetchFunction getNewestProductsFetch(WidgetRef ref) => ({
  lastDocument,
  pageSize = 20, // Updated default
}) async {
  final GetNewestProductsUseCase useCase = ref.read(
    getNewestProductsUseCaseProvider,
  );
  return useCase.execute(lastDocument: lastDocument, pageSize: pageSize);
};

// Fetch function for newest products by gender
FetchFunction getNewestByGenderFetch(WidgetRef ref, String gender) => ({
  lastDocument,
  pageSize = 20, // Updated default
}) async {
  final GetNewestProductsByGenderUseCase useCase = ref.read(
    getNewestProductsByGenderUseCaseProvider,
  );
  return useCase.execute(
    gender,
    lastDocument: lastDocument,
    pageSize: pageSize,
  );
};

// Fetch function for products by gender
FetchFunction getProductsByGenderFetch(WidgetRef ref, String gender) => ({
  lastDocument,
  pageSize = 20, // Updated default
}) async {
  final GetProductsByGenderUseCase useCase = ref.read(
    getProductsByGenderUseCaseProvider,
  );
  return useCase.execute(
    gender,
    lastDocument: lastDocument,
    pageSize: pageSize,
  );
};

// Fetch function for products by gender and subcategory
FetchFunction getProductsByGenderAndSubFetch(
  WidgetRef ref,
  ProductsByGenderAndSubParams params,
) => ({lastDocument, pageSize = 20}) async {
  // Updated default
  final GetProductsByGenderAndSubCategoryUseCase useCase = ref.read(
    getProductsByGenderAndSubCategoryUseCaseProvider,
  );
  return useCase.execute(
    params.gender,
    params.subCategory,
    lastDocument: lastDocument,
    pageSize: pageSize,
  );
};

// Fetch function for filtered products
FetchFunction getFilteredProductsFetch(WidgetRef ref) => ({
  lastDocument,
  pageSize = 20, // Updated default
}) async {
  final FilterParams filterParams = ref.read(filterParamsProvider);
  final GetFilteredProductsUseCase useCase = ref.read(
    getFilteredProductsUseCaseProvider,
  );
  return useCase.execute(
    filterParams,
    lastDocument: lastDocument,
    pageSize: pageSize,
  );
};
