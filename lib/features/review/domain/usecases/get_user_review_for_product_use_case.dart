import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/review_entity.dart';
import '../repositories/review_repository.dart';

class GetUserReviewForProductUseCase {
  GetUserReviewForProductUseCase(this.repository);
  final ReviewRepository repository;

  Future<Either<Failure, ReviewEntity?>> execute(
    String productId,
    String userId,
  ) => repository.getUserReviewForProduct(productId, userId);
}
