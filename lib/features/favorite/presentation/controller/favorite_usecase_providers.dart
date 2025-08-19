import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/firestore_sevice.dart';

import '../../data/datasources/favorite_data_source.dart';
import '../../data/repositories/favorite_repository_impl.dart';
import '../../domain/usecases/add_to_favorites_usecase.dart';
import '../../domain/usecases/get_user_favorites_usecase.dart';
import '../../domain/usecases/is_favorite_usecase.dart';
import '../../domain/usecases/remove_from_favorites_usecase.dart';

final Provider<FavoriteRepositoryImpl> favoriteRepositoryProvider = Provider(
  (ref) => FavoriteRepositoryImpl(
    FavoriteDataSourceImpl(FirestoreServices.instance),
  ),
);

final Provider<AddToFavoritesUseCase> addToFavoritesUseCaseProvider = Provider(
  (ref) => AddToFavoritesUseCase(ref.watch(favoriteRepositoryProvider)),
);

final Provider<RemoveFromFavoritesUseCase> removeFromFavoritesUseCaseProvider =
    Provider(
      (ref) =>
          RemoveFromFavoritesUseCase(ref.watch(favoriteRepositoryProvider)),
    );

final Provider<IsFavoriteUseCase> isFavoriteUseCaseProvider = Provider(
  (ref) => IsFavoriteUseCase(ref.watch(favoriteRepositoryProvider)),
);

final Provider<GetUserFavoritesUseCase> getUserFavoritesUseCaseProvider =
    Provider(
      (ref) => GetUserFavoritesUseCase(ref.watch(favoriteRepositoryProvider)),
    );
