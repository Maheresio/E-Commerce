import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/review_entity.dart';
import '../repositories/review_repository.dart';

class GetProductReviewsUseCase {
  GetProductReviewsUseCase(this.repository);
  final ReviewRepository repository;

  Future<Either<Failure, List<ReviewEntity>>> execute(String productId) =>
      repository.getProductReviews(productId);
}
