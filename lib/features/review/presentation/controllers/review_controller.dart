import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/usecases/add_review_use_case.dart';
import '../../domain/usecases/delete_review_use_case.dart';
import '../../domain/usecases/get_product_reviews_use_case.dart';
import '../../domain/usecases/get_user_review_for_product_use_case.dart';
import '../../domain/usecases/mark_review_helpful_use_case.dart';
import '../../domain/usecases/update_review_use_case.dart';
import '../providers/review_providers.dart';
import '../../../home/presentation/controller/home_provider.dart';

// State for reviews list
class ProductReviewsNotifier
    extends FamilyAsyncNotifier<List<ReviewEntity>, String> {
  @override
  Future<List<ReviewEntity>> build(String productId) async {
    final GetProductReviewsUseCase useCase = ref.read(
      getProductReviewsUseCaseProvider,
    );
    final Either<Failure, List<ReviewEntity>> result = await useCase.execute(
      productId,
    );

    return result.fold(
      (Failure failure) => throw Exception(failure.message),
      (List<ReviewEntity> reviews) => reviews,
    );
  }
}

final AsyncNotifierProviderFamily<
  ProductReviewsNotifier,
  List<ReviewEntity>,
  String
>
productReviewsProvider = AsyncNotifierProvider.family<
  ProductReviewsNotifier,
  List<ReviewEntity>,
  String
>(ProductReviewsNotifier.new);

// State for user's review for a specific product
class UserReviewForProductNotifier
    extends
        FamilyAsyncNotifier<
          ReviewEntity?,
          ({String productId, String userId})
        > {
  @override
  Future<ReviewEntity?> build(
    ({String productId, String userId}) params,
  ) async {
    final GetUserReviewForProductUseCase useCase = ref.read(
      getUserReviewForProductUseCaseProvider,
    );
    final Either<Failure, ReviewEntity?> result = await useCase.execute(
      params.productId,
      params.userId,
    );

    return result.fold(
      (Failure failure) => throw Exception(failure.message),
      (ReviewEntity? review) => review,
    );
  }
}

final AsyncNotifierProviderFamily<
  UserReviewForProductNotifier,
  ReviewEntity?,
  ({String productId, String userId})
>
userReviewForProductProvider = AsyncNotifierProvider.family<
  UserReviewForProductNotifier,
  ReviewEntity?,
  ({String productId, String userId})
>(UserReviewForProductNotifier.new);

// Notifier for review actions
class ReviewActionsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Initialize with empty state
    return;
  }

  Future<void> addReview(ReviewEntity review) async {
    state = const AsyncValue.loading();

    final AddReviewUseCase useCase = ref.read(addReviewUseCaseProvider);
    final Either<Failure, String> result = await useCase.execute(review);

    result.fold(
      (Failure failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (String reviewId) {
        state = const AsyncValue.data(null);
        // Invalidate related providers to refresh data
        ref.invalidate(productReviewsProvider);
        ref.invalidate(userReviewForProductProvider);
        // Invalidate product providers to refresh embedded reviews
        ref.invalidate(saleProductsProvider);
        ref.invalidate(newProductsProvider);
      },
    );
  }

  Future<void> updateReview(ReviewEntity review) async {
    state = const AsyncValue.loading();

    final UpdateReviewUseCase useCase = ref.read(updateReviewUseCaseProvider);
    final Either<Failure, String> result = await useCase.execute(review);

    result.fold(
      (Failure failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (String reviewId) {
        state = const AsyncValue.data(null);
        // Invalidate related providers to refresh data
        ref.invalidate(productReviewsProvider);
        ref.invalidate(userReviewForProductProvider);
        // Invalidate product providers to refresh embedded reviews
        ref.invalidate(saleProductsProvider);
        ref.invalidate(newProductsProvider);
      },
    );
  }

  Future<void> deleteReview(String productId, String reviewId) async {
    state = const AsyncValue.loading();

    final DeleteReviewUseCase useCase = ref.read(deleteReviewUseCaseProvider);
    final Either<Failure, String> result = await useCase.execute(
      productId,
      reviewId,
    );

    result.fold(
      (Failure failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (String deletedReviewId) {
        state = const AsyncValue.data(null);
        // Invalidate related providers to refresh data
        ref.invalidate(productReviewsProvider);
        ref.invalidate(userReviewForProductProvider);
        // Invalidate product providers to refresh embedded reviews
        ref.invalidate(saleProductsProvider);
        ref.invalidate(newProductsProvider);
      },
    );
  }

  Future<void> markReviewHelpful(
    String productId,
    String reviewId,
    String userId,
  ) async {
    state = const AsyncValue.loading();

    final MarkReviewHelpfulUseCase useCase = ref.read(
      markReviewHelpfulUseCaseProvider,
    );
    final Either<Failure, String> result = await useCase((
      productId: productId,
      reviewId: reviewId,
      userId: userId,
    ));

    result.fold(
      (Failure failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (String reviewId) {
        state = const AsyncValue.data(null);
        // Invalidate related providers to refresh data
        ref.invalidate(productReviewsProvider);
        ref.invalidate(userReviewForProductProvider);
        // Invalidate product providers to refresh embedded reviews
        ref.invalidate(saleProductsProvider);
        ref.invalidate(newProductsProvider);
      },
    );
  }
}

// Provider for review actions
final reviewActionsProvider =
    AsyncNotifierProvider<ReviewActionsNotifier, void>(
      () => ReviewActionsNotifier(),
    );
