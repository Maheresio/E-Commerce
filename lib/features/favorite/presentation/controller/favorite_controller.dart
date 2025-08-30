import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../domain/usecases/add_to_favorites_usecase.dart';
import '../../domain/usecases/get_user_favorites_usecase.dart';
import '../../domain/usecases/is_favorite_usecase.dart';
import '../../domain/usecases/remove_from_favorites_usecase.dart';
import 'favorite_usecase_providers.dart';

final AsyncNotifierProviderFamily<
  FavoritesController,
  List<ProductEntity>,
  String
>
favoritesControllerProvider = AsyncNotifierProvider.family<
  FavoritesController,
  List<ProductEntity>,
  String
>(FavoritesController.new);

class FavoritesController
    extends FamilyAsyncNotifier<List<ProductEntity>, String> {
  late String userId;

  @override
  Future<List<ProductEntity>> build(String userIdArg) async {
    userId = userIdArg;
    final GetUserFavoritesUseCase useCase = ref.read(
      getUserFavoritesUseCaseProvider,
    );
    final Either<Failure, List<ProductEntity>> result = await useCase.execute(
      userId,
    );
    return result.fold((Failure l) => throw l, (List<ProductEntity> r) => r);
  }

  Future<void> addFavorite(ProductEntity product) async {
    final AddToFavoritesUseCase useCase = ref.read(
      addToFavoritesUseCaseProvider,
    );
    final Either<Failure, void> result = await useCase.execute(userId, product);
    if (result.isRight()) {
      state = AsyncData(<ProductEntity>[...?state.value, product]);
    }
  }

  Future<void> removeFavorite(String productId) async {
    final RemoveFromFavoritesUseCase useCase = ref.read(
      removeFromFavoritesUseCaseProvider,
    );
    final Either<Failure, void> result = await useCase.execute(
      userId,
      productId,
    );
    if (result.isRight()) {
      state = AsyncData(<ProductEntity>[
        ...?state.value?.where((ProductEntity e) => e.id != productId),
      ]);
    }
  }

  Future<bool> isFavorite(String productId) async {
    final IsFavoriteUseCase useCase = ref.read(isFavoriteUseCaseProvider);
    final Either<Failure, bool> result = await useCase.execute(
      userId,
      productId,
    );
    return result.getOrElse(() => false);
  }
}
