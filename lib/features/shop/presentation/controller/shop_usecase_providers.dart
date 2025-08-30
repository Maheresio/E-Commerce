import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_all_products_usecase.dart';
import '../../domain/usecases/get_filtered_products_usecase.dart';
import '../../domain/usecases/get_new_products_usecase.dart';
import '../../domain/usecases/get_newest_products_by_gender_usecase.dart';
import '../../domain/usecases/get_products_by_gender_and_subcategory_usecase.dart';
import '../../domain/usecases/get_products_by_gender_usecase.dart';
import '../../domain/usecases/get_sale_products_usecase.dart';
import 'shop_providers.dart';

// -------------------- Use Case Providers --------------------

final Provider<GetAllProductsUseCase> getAllProductsUseCaseProvider =
    Provider<GetAllProductsUseCase>(
      (ref) => GetAllProductsUseCase(ref.read(shopRepositoryProvider)),
    );

final Provider<GetSaleProductsUsecase> getSaleProductsUseCaseProvider =
    Provider<GetSaleProductsUsecase>(
      (ref) => GetSaleProductsUsecase(ref.read(shopRepositoryProvider)),
    );

final Provider<GetNewestProductsUseCase> getNewestProductsUseCaseProvider =
    Provider<GetNewestProductsUseCase>(
      (ref) => GetNewestProductsUseCase(ref.read(shopRepositoryProvider)),
    );

final Provider<GetNewestProductsByGenderUseCase>
getNewestProductsByGenderUseCaseProvider = Provider<
  GetNewestProductsByGenderUseCase
>((ref) => GetNewestProductsByGenderUseCase(ref.read(shopRepositoryProvider)));

final Provider<GetProductsByGenderUseCase> getProductsByGenderUseCaseProvider =
    Provider<GetProductsByGenderUseCase>(
      (ref) => GetProductsByGenderUseCase(ref.read(shopRepositoryProvider)),
    );

final Provider<GetProductsByGenderAndSubCategoryUseCase>
getProductsByGenderAndSubCategoryUseCaseProvider =
    Provider<GetProductsByGenderAndSubCategoryUseCase>(
      (ref) => GetProductsByGenderAndSubCategoryUseCase(
        ref.read(shopRepositoryProvider),
      ),
    );

final Provider<GetFilteredProductsUseCase> getFilteredProductsUseCaseProvider =
    Provider<GetFilteredProductsUseCase>(
      (ref) => GetFilteredProductsUseCase(ref.read(shopRepositoryProvider)),
    );
