import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/review_repository.dart';

class MarkReviewHelpfulUseCase
    implements
        UseCase<String, ({String productId, String reviewId, String userId})> {
  const MarkReviewHelpfulUseCase(this.repository);

  final ReviewRepository repository;

  @override
  Future<Either<Failure, String>> call(
    ({String productId, String reviewId, String userId}) params,
  ) async {
    return await repository.markReviewHelpful(
      productId: params.productId,
      reviewId: params.reviewId,
      userId: params.userId,
    );
  }
}
