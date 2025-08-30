import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/review_entity.dart';

abstract class ReviewRepository {
  Future<Either<Failure, List<ReviewEntity>>> getProductReviews(
    String productId,
  );
  Future<Either<Failure, ReviewEntity?>> getUserReviewForProduct(
    String productId,
    String userId,
  );
  Future<Either<Failure, String>> addReview(ReviewEntity review);
  Future<Either<Failure, String>> updateReview(ReviewEntity review);
  Future<Either<Failure, String>> deleteReview(
    String productId,
    String reviewId,
  );
  Future<Either<Failure, String>> markReviewHelpful({
    required String productId,
    required String reviewId,
    required String userId,
  });
}
