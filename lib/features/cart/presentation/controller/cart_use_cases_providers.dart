import '../../../../core/services/firestore_sevice.dart';
import '../../domain/usecases/add_or_update_cart_item_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../favorite/data/repositories/favorite_repository_impl.dart';
import '../../../favorite/presentation/controller/favorite_usecase_providers.dart';
import '../../../home/domain/repositories/home_repository.dart';
import '../../../home/presentation/controller/home_provider.dart';
import '../../data/datasources/cart_data_source.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/calculate_cart_total_use_case.dart';
import '../../domain/usecases/check_cart_item_exists_use_case.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/remove_cart_item_usecase.dart';
import '../../domain/usecases/increment_cart_item_quantity_use_case.dart';
import '../../domain/usecases/decrement_cart_item_quantity_use_case.dart';
import '../../domain/usecases/add_to_favorites_usecase.dart';

final Provider<FirestoreServices> firestoreServicesProvider =
    Provider<FirestoreServices>((ref) => FirestoreServices.instance);

// Data Source Provider
final Provider<CartDataSource> cartDataSourceProvider =
    Provider<CartDataSource>(
      (ref) => CartDataSourceImpl(ref.read(firestoreServicesProvider)),
    );
//
// Repository Provider
final Provider<CartRepository> cartRepositoryProvider =
    Provider<CartRepository>((ref) {
      final CartDataSource dataSource = ref.read(cartDataSourceProvider);
      return CartRepositoryImpl(dataSource);
    });

// Use Case Providers
final Provider<GetCartUseCase> getCartUseCaseProvider =
    Provider<GetCartUseCase>((ref) {
      final CartRepository repository = ref.read(cartRepositoryProvider);
      return GetCartUseCase(repository);
    });

final Provider<AddOrUpdateCartItemUseCase> addOrUpdateCartItemUseCaseProvider =
    Provider<AddOrUpdateCartItemUseCase>((ref) {
      final CartRepository repository = ref.read(cartRepositoryProvider);
      return AddOrUpdateCartItemUseCase(repository);
    });

final Provider<RemoveCartItemUseCase> removeCartItemUseCaseProvider =
    Provider<RemoveCartItemUseCase>((ref) {
      final CartRepository repository = ref.read(cartRepositoryProvider);
      return RemoveCartItemUseCase(repository);
    });

final Provider<ClearCartUseCase> clearCartUseCaseProvider =
    Provider<ClearCartUseCase>((ref) {
      final CartRepository repository = ref.read(cartRepositoryProvider);
      return ClearCartUseCase(repository);
    });

final Provider<CheckCartItemExistsUseCase> checkCartItemExistsUseCaseProvider =
    Provider<CheckCartItemExistsUseCase>((ref) {
      final CartRepository repository = ref.read(cartRepositoryProvider);
      return CheckCartItemExistsUseCase(repository);
    });

final Provider<CalculateCartTotalUseCase> calculateCartTotalUseCaseProvider =
    Provider<CalculateCartTotalUseCase>((ref) {
      final CartRepository repository = ref.read(cartRepositoryProvider);
      return CalculateCartTotalUseCase(repository);
    });

final Provider<IncrementCartItemQuantityUseCase>
incrementCartItemQuantityUseCaseProvider =
    Provider<IncrementCartItemQuantityUseCase>((ref) {
      final CartRepository repository = ref.read(cartRepositoryProvider);
      return IncrementCartItemQuantityUseCase(repository);
    });

final Provider<DecrementCartItemQuantityUseCase>
decrementCartItemQuantityUseCaseProvider =
    Provider<DecrementCartItemQuantityUseCase>((ref) {
      final CartRepository repository = ref.read(cartRepositoryProvider);
      return DecrementCartItemQuantityUseCase(repository);
    });

final Provider<AddToFavoritesUseCase> addToFavoritesUseCaseProvider =
    Provider<AddToFavoritesUseCase>((ref) {
      final HomeRepository homeRepository = ref.read(homeRepositoryProvider);
      final FavoriteRepositoryImpl favoriteRepository = ref.read(
        favoriteRepositoryProvider,
      );
      return AddToFavoritesUseCase(
        homeRepository: homeRepository,
        favoriteRepository: favoriteRepository,
      );
    });
