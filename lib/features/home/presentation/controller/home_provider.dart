import 'package:e_commerce/features/home/data/repositories/home_repository_impl.dart';
import 'package:e_commerce/features/home/domain/entities/product_entity.dart';
import 'package:e_commerce/features/home/domain/repositories/home_repository.dart';
import 'package:e_commerce/features/home/domain/usecases/get_new_usecase.dart';
import 'package:e_commerce/features/home/domain/usecases/get_sale_usecase.dart';
import 'package:e_commerce/features/home/domain/usecases/update_product_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/home_data_source.dart';

final homeDataSourceProvider = Provider<HomeDataSource>(
  (ref) => HomeDataSourceImpl(),
);
final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepositoryImpl(ref.read(homeDataSourceProvider)),
);

final getSaleUsecaseProvider = Provider<GetSaleUsecase>((ref) {
  final homeRepository = ref.read(homeRepositoryProvider);
  return GetSaleUsecase(homeRepository);
});

final getNewUsecaseProvider = Provider<GetNewUsecase>((ref) {
  final homeRepository = ref.read(homeRepositoryProvider);
  return GetNewUsecase(homeRepository);
});

final saleProductsProvider = StreamProvider<List<ProductEntity>>((ref) {
  final getSaleUsecase = ref.read(getSaleUsecaseProvider);
  return getSaleUsecase.execute();
});

final newProductsProvider = StreamProvider<List<ProductEntity>>((ref) {
  final getNewUsecase = ref.read(getNewUsecaseProvider);
  return getNewUsecase.execute();
});

final updateProductUseCaseProvider = Provider<UpdateProductUsecase>((ref) {
  final homeRepository = ref.read(homeRepositoryProvider);
  return UpdateProductUsecase(homeRepository);
});

final updateProductProvider = FutureProvider.family<void, UpdateParams>((
  ref,
  params,
) async {
  final updateProductUseCase = ref.read(updateProductUseCaseProvider);

  return await updateProductUseCase.execute(id: params.id, data: params.data);
});

class UpdateParams {
  final String id;
  final Map<String, dynamic> data;

  UpdateParams({required this.id, required this.data});
}
