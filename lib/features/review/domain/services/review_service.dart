import 'package:e_commerce/features/checkout/presentation/controller/visa_card/visa_card_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_strings.dart';
import '../../domain/entities/review_entity.dart';
import '../../presentation/controllers/review_controller.dart';
import '../../presentation/providers/review_form_provider.dart';

class ReviewService {
  const ReviewService(this.ref);

  final Ref ref;

  Future<void> addReview(String productId, String content) async {
    final currentUser =
        ref.read(currentUserServiceProvider).currentFirebaseUser;
    if (currentUser == null) {
      return;
    }
    final ReviewFormState formState = ref.read(reviewFormProvider);

    final ReviewEntity reviewEntity = ReviewEntity(
      id: '',
      productId: productId,
      userId: currentUser.uid,
      userName: currentUser.displayName ?? AppStrings.kDefaultUserName,
      userImageUrl: currentUser.photoURL,
      content: content.trim(),
      rating: formState.rating,
      reviewImagesUrls:
          formState.selectedImages.isNotEmpty ? formState.selectedImages : null,
      helpfulUserIds: const [],
      createdAt: DateTime.now(),
    );

    await ref.read(reviewActionsProvider.notifier).addReview(reviewEntity);
    ref.read(reviewFormProvider.notifier).clearForm();
  }

  Future<void> updateReview(String productId, String content) async {
    final currentUser =
        ref.read(currentUserServiceProvider).currentFirebaseUser;
    if (currentUser == null) {
      return;
    }

    final ReviewFormState formState = ref.read(reviewFormProvider);

    final ReviewEntity? currentReview = formState.currentUserReview;
    if (currentReview == null) {
      return;
    }

    final ReviewEntity updatedReviewEntity = currentReview.copyWith(
      content: content.trim(),
      rating: formState.rating,
      reviewImagesUrls:
          formState.selectedImages.isNotEmpty ? formState.selectedImages : null,
      updatedAt: DateTime.now(),
    );

    await ref
        .read(reviewActionsProvider.notifier)
        .updateReview(updatedReviewEntity);

    ref.read(reviewFormProvider.notifier).clearForm();
  }

  Future<void> deleteReview(String productId, String reviewId) async {
    final currentUser =
        ref.read(currentUserServiceProvider).currentFirebaseUser;
    if (currentUser == null) {
      return;
    }

    await ref
        .read(reviewActionsProvider.notifier)
        .deleteReview(productId, reviewId);

    ref.read(reviewFormProvider.notifier).clearForm();
  }

  bool validateForm(double rating, String content) {
    if (rating == 0) return false;
    if (content.trim().isEmpty) return false;
    return true;
  }

  ReviewEntity? findCurrentUserReview(List<ReviewEntity> reviews) {
    final currentUser =
        ref.read(currentUserServiceProvider).currentFirebaseUser;
    if (currentUser == null) return null;

    for (final ReviewEntity review in reviews) {
      if (review.userId == currentUser.uid) {
        return review;
      }
    }
    return null;
  }

  bool get isUserLoggedIn => FirebaseAuth.instance.currentUser != null;
}

final Provider<ReviewService> reviewServiceProvider = Provider<ReviewService>(
  ReviewService.new,
);
