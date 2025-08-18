import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/presentation/controller/product_provider.dart';
import '../../data/datasources/home_data_source.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_new_usecase.dart';
import '../../domain/usecases/get_sale_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';

final Provider<HomeDataSource> homeDataSourceProvider =
    Provider<HomeDataSource>(
      (ref) => HomeDataSourceImpl(ref.read(firestoreServicesProvider)),
    );
final Provider<HomeRepository> homeRepositoryProvider =
    Provider<HomeRepository>(
      (ref) => HomeRepositoryImpl(ref.read(homeDataSourceProvider)),
    );

final Provider<GetSaleUsecase> getSaleUsecaseProvider =
    Provider<GetSaleUsecase>((ref) {
      final HomeRepository homeRepository = ref.read(homeRepositoryProvider);
      return GetSaleUsecase(homeRepository);
    });

final Provider<GetNewUsecase> getNewUsecaseProvider = Provider<GetNewUsecase>((
  ref,
) {
  final HomeRepository homeRepository = ref.read(homeRepositoryProvider);
  return GetNewUsecase(homeRepository);
});

final StreamProvider<List<ProductEntity>> saleProductsProvider =
    StreamProvider<List<ProductEntity>>((ref) {
      final GetSaleUsecase getSaleUsecase = ref.read(getSaleUsecaseProvider);
      return getSaleUsecase.execute();
    });

final StreamProvider<List<ProductEntity>> newProductsProvider =
    StreamProvider<List<ProductEntity>>((ref) {
      final GetNewUsecase getNewUsecase = ref.read(getNewUsecaseProvider);
      return getNewUsecase.execute();
    });

final Provider<UpdateProductUsecase> updateProductUseCaseProvider =
    Provider<UpdateProductUsecase>((ref) {
      final HomeRepository homeRepository = ref.read(homeRepositoryProvider);
      return UpdateProductUsecase(homeRepository);
    });

final FutureProviderFamily<void, UpdateParams> updateProductProvider =
    FutureProvider.family<void, UpdateParams>((ref, UpdateParams params) async {
      final UpdateProductUsecase updateProductUseCase = ref.read(
        updateProductUseCaseProvider,
      );

      return updateProductUseCase.execute(id: params.id, data: params.data);
    });

class UpdateParams {
  UpdateParams({required this.id, required this.data});
  final String id;
  final Map<String, dynamic> data;
}
