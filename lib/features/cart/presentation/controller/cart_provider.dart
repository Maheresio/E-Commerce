import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failure.dart';
import '../../../favorite/presentation/controller/favorite_controller.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecases/add_or_update_cart_item_usecase.dart';
import '../../domain/usecases/add_to_favorites_usecase.dart';
import '../../domain/usecases/calculate_cart_total_use_case.dart';
import '../../domain/usecases/check_cart_item_exists_use_case.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/decrement_cart_item_quantity_use_case.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/increment_cart_item_quantity_use_case.dart';
import '../../domain/usecases/remove_cart_item_usecase.dart';
import 'cart_use_cases_providers.dart';

final AsyncNotifierProviderFamily<CartController, List<CartItemEntity>, String>
cartControllerProvider =
    AsyncNotifierProvider.family<CartController, List<CartItemEntity>, String>(
      CartController.new,
    );

// Add cart total provider
final AsyncNotifierProviderFamily<CartTotalController, double, String>
cartTotalProvider =
    AsyncNotifierProvider.family<CartTotalController, double, String>(
      CartTotalController.new,
    );

class CartTotalController extends FamilyAsyncNotifier<double, String> {
  @override
  Future<double> build(String userId) async {
    final CalculateCartTotalUseCase useCase = ref.read(
      calculateCartTotalUseCaseProvider,
    );
    final Either<Failure, double> result = await useCase.execute(userId);
    return result.fold((Failure l) => throw l, (double r) => r);
  }

  void refreshTotal() {
    ref.invalidateSelf();
  }

  double getCurrentTotal() => state.valueOrNull ?? 0.0;
}

class CartController extends FamilyAsyncNotifier<List<CartItemEntity>, String> {
  late final String userId;

  @override
  Future<List<CartItemEntity>> build(String id) async {
    userId = id;
    final GetCartUseCase useCase = ref.read(getCartUseCaseProvider);
    final Either<Failure, List<CartItemEntity>> result = await useCase.execute(
      userId,
    );
    return result.fold((Failure l) => throw l, (List<CartItemEntity> r) => r);
  }

  Future<void> remove(String itemId) async {
    final RemoveCartItemUseCase useCase = ref.read(
      removeCartItemUseCaseProvider,
    );
    final Either<Failure, void> result = await useCase.execute(userId, itemId);
    if (result.isRight()) {
      state = AsyncData(
        (state.valueOrNull ?? <CartItemEntity>[])
          ..removeWhere((CartItemEntity e) => e.id == itemId),
      );
      // Refresh cart total when items change
      ref.invalidate(cartTotalProvider(userId));
    }
  }

  Future<void> clear() async {
    final ClearCartUseCase useCase = ref.read(clearCartUseCaseProvider);
    final Either<Failure, void> result = await useCase.execute(userId);
    if (result.isRight()) {
      state = const AsyncData(<CartItemEntity>[]);
      // Refresh cart total when items change
      ref.invalidate(cartTotalProvider(userId));
    }
  }

  Future<Either<Failure, void>> addToFavorite(String productId) async {
    final AddToFavoritesUseCase useCase = ref.read(
      addToFavoritesUseCaseProvider,
    );
    final Either<Failure, void> result = await useCase.execute(
      userId,
      productId,
    );
    return result.fold(Left.new, (_) {
      ref.invalidate(favoritesControllerProvider(userId));
      return const Right(null);
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final GetCartUseCase useCase = ref.read(getCartUseCaseProvider);
    final Either<Failure, List<CartItemEntity>> result = await useCase.execute(
      userId,
    );
    state = result.fold(
      (Failure l) => AsyncError(l, StackTrace.current),
      AsyncData.new,
    );
  }

  Future<void> addOrUpdate(CartItemEntity item) async {
    final CheckCartItemExistsUseCase checkUseCase = ref.read(
      checkCartItemExistsUseCaseProvider,
    );
    final AddOrUpdateCartItemUseCase addOrUpdateUseCase = ref.read(
      addOrUpdateCartItemUseCaseProvider,
    );

    // Check if item exists
    final Either<Failure, CartItemEntity?> existingItemResult =
        await checkUseCase.execute(
          userId,
          item.productId,
          item.selectedSize,
          item.selectedColor,
        );

    await existingItemResult.fold(
      (Failure failure) async {
        // If check fails, just add with quantity 1
        final CartItemEntity newItem = item.copyWith(quantity: 1);
        await addOrUpdateUseCase.execute(userId, newItem);
        await refresh();
        // Refresh cart total when items change
        ref.invalidate(cartTotalProvider(userId));
      },
      (CartItemEntity? existingItem) async {
        final int newQuantity =
            existingItem != null ? existingItem.quantity + 1 : 1;
        final CartItemEntity updatedItem = item.copyWith(
          id:
              existingItem?.id ??
              const Uuid().v4(), // Generate a new ID if it doesn't exist
          quantity: newQuantity,
        );
        await addOrUpdateUseCase.execute(userId, updatedItem);
        await refresh();
        // Refresh cart total when items change
        ref.invalidate(cartTotalProvider(userId));
      },
    );
  }

  void setQuantityLoading(bool loading) {
    ref.read(quantityLoadingProvider.notifier).state = loading;
  }

  Future<void> incrementQuantity(CartItemEntity item) async {
    if (_loadingItemIds.contains(item.id)) return;
    _loadingItemIds.add(item.id);
    setQuantityLoading(true);
    final IncrementCartItemQuantityUseCase useCase = ref.read(
      incrementCartItemQuantityUseCaseProvider,
    );
    final Either<Failure, CartItemEntity> result = await useCase.execute(
      userId,
      item,
    );

    await result.fold(
      (Failure failure) async {
        await refresh();
        ref.invalidate(cartTotalProvider(userId));
      },
      (CartItemEntity updatedItem) {
        // Update UI with the returned updated item
        final List<CartItemEntity> updatedItems =
            (state.valueOrNull ?? <CartItemEntity>[]).map((
              CartItemEntity cartItem,
            ) {
              if (cartItem.id == item.id) {
                return updatedItem;
              }
              return cartItem;
            }).toList();

        state = AsyncData(updatedItems);
        ref.invalidate(cartTotalProvider(userId));
      },
    );

    _loadingItemIds.remove(item.id);
    setQuantityLoading(false);
  }

  final Set<String> _loadingItemIds = <String>{};
  bool isLoading(String itemId) => _loadingItemIds.contains(itemId);

  Future<void> decrementQuantity(CartItemEntity item) async {
    if (_loadingItemIds.contains(item.id)) return;
    if (item.quantity <= 1) return;

    _loadingItemIds.add(item.id);
    setQuantityLoading(true);
    final DecrementCartItemQuantityUseCase useCase = ref.read(
      decrementCartItemQuantityUseCaseProvider,
    );
    final Either<Failure, CartItemEntity> result = await useCase.execute(
      userId,
      item,
    );

    await result.fold(
      (Failure failure) async {
        await refresh();
        ref.invalidate(cartTotalProvider(userId));
      },
      (CartItemEntity updatedItem) {
        // Update UI with the returned updated item
        final List<CartItemEntity> updatedItems =
            (state.valueOrNull ?? <CartItemEntity>[]).map((
              CartItemEntity cartItem,
            ) {
              if (cartItem.id == item.id) {
                return updatedItem;
              }
              return cartItem;
            }).toList();

        state = AsyncData(updatedItems);
        ref.invalidate(cartTotalProvider(userId));
      },
    );

    _loadingItemIds.remove(item.id);
    setQuantityLoading(false);
  }
}

final StateProvider<bool> quantityLoadingProvider = StateProvider<bool>(
  (ref) => false,
);
