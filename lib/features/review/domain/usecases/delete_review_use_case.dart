import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/review_repository.dart';

class DeleteReviewUseCase {
  DeleteReviewUseCase(this.repository);
  final ReviewRepository repository;

  Future<Either<Failure, String>> execute(String productId, String reviewId) =>
      repository.deleteReview(productId, reviewId);
}
