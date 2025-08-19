import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/favorite_repository.dart';

class IsFavoriteUseCase {
  IsFavoriteUseCase(this.repository);
  final FavoriteRepository repository;

  Future<Either<Failure, bool>> execute(String userId, String productId) =>
      repository.isFavorite(userId, productId);
}
