import 'package:dartz/dartz.dart';

import '../../../home/data/models/product_model.dart';
import '../../../home/domain/entities/product_entity.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/handle_repository_exceptions.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_data_source.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  FavoriteRepositoryImpl(this.dataSource);
  final FavoriteDataSource dataSource;

  @override
  Future<Either<Failure, void>> addToFavorites(
    String userId,
    ProductEntity product,
  ) async => handleRepositoryExceptions<void>(() async {
    await dataSource.addFavorite(userId, product as ProductModel);
  });

  @override
  Future<Either<Failure, void>> removeFromFavorites(
    String userId,
    String productId,
  ) async => handleRepositoryExceptions<void>(() async {
    await dataSource.removeFavorite(userId, productId);
  });

  @override
  Future<Either<Failure, bool>> isFavorite(
    String userId,
    String productId,
  ) async => handleRepositoryExceptions<bool>(() async {
    return await dataSource.isFavorite(userId, productId);
  });

  @override
  Future<Either<Failure, List<ProductEntity>>> getUserFavorites(
    String userId,
  ) async => handleRepositoryExceptions<List<ProductEntity>>(() async {
    return await dataSource.getFavorites(userId);
  });
}
