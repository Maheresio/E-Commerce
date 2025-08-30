import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/review_entity.dart';
import '../repositories/review_repository.dart';

class UpdateReviewUseCase {
  UpdateReviewUseCase(this.repository);
  final ReviewRepository repository;

  Future<Either<Failure, String>> execute(ReviewEntity review) =>
      repository.updateReview(review);
}
