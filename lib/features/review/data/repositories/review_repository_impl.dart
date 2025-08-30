import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/handle_repository_exceptions.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_data_source.dart';
import '../models/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl({required this.remoteDataSource});
  final ReviewRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<ReviewEntity>>> getProductReviews(
    String productId,
  ) async => handleRepositoryExceptions(() async {
    final reviews = await remoteDataSource.getProductReviews(productId);
    return reviews.map((review) => review.toEntity()).toList();
  });

  @override
  Future<Either<Failure, ReviewEntity?>> getUserReviewForProduct(
    String productId,
    String userId,
  ) async => handleRepositoryExceptions(() async {
    final review = await remoteDataSource.getUserReviewForProduct(
      productId,
      userId,
    );
    return review?.toEntity();
  });

  @override
  Future<Either<Failure, String>> addReview(ReviewEntity review) async =>
      handleRepositoryExceptions(() async {
        final reviewModel = ReviewModel.fromEntity(review);
        return await remoteDataSource.addReviewToProduct(
          review.productId,
          reviewModel,
        );
      });

  @override
  Future<Either<Failure, String>> updateReview(ReviewEntity review) async =>
      handleRepositoryExceptions(() async {
        final reviewModel = ReviewModel.fromEntity(review);
        return await remoteDataSource.updateReviewInProduct(
          review.productId,
          reviewModel,
        );
      });

  @override
  Future<Either<Failure, String>> deleteReview(
    String productId,
    String reviewId,
  ) async => handleRepositoryExceptions(() async {
    return await remoteDataSource.deleteReviewFromProduct(productId, reviewId);
  });

  @override
  Future<Either<Failure, String>> markReviewHelpful({
    required String productId,
    required String reviewId,
    required String userId,
  }) async => handleRepositoryExceptions(() async {
    return await remoteDataSource.markReviewHelpful(
      productId: productId,
      reviewId: reviewId,
      userId: userId,
    );
  });
}
