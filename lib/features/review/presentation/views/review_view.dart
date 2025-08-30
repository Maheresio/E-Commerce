import 'package:go_router/go_router.dart';

import '../../../../core/helpers/methods/styled_snack_bar.dart';
import '../../../../core/widgets/styled_modal_barrier.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../checkout/presentation/controller/visa_card/visa_card_providers.dart';
import '../../../home/domain/entities/product_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/review_entity.dart';
import '../../domain/services/review_service.dart';
import '../controllers/review_controller.dart';
import '../providers/review_form_provider.dart';
import '../widgets/review_modal_content.dart';
import '../widgets/review_main_content.dart';
import '../widgets/review_floating_action_button.dart';

class ReviewView extends ConsumerWidget {
  const ReviewView(this.product, {super.key});

  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser =
        ref.read(currentUserServiceProvider).currentFirebaseUser;
    final AsyncValue<List<ReviewEntity>> reviewsAsync = ref.watch(
      productReviewsProvider(product.id),
    );
    final AsyncValue<void> reviewActionsAsync = ref.watch(
      reviewActionsProvider,
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ReviewMainContent(
              reviewsAsync: reviewsAsync,
              currentUser: currentUser,
              product: product,
              onEditReview:
                  (ReviewEntity review) =>
                      _handleEditReview(context, ref, review),
              onDeleteReview:
                  (String reviewId) =>
                      _handleDeleteReview(context, ref, reviewId),
            ),
            if (reviewActionsAsync.isLoading) const StyledModalBarrier(),
          ],
        ),
      ),
      floatingActionButton: ReviewFloatingActionButton(
        reviewsAsync: reviewsAsync,
        currentUser: currentUser,
        onPressed:
            (ReviewEntity? currentUserReview) =>
                _handleFloatingActionButtonPressed(
                  context,
                  ref,
                  currentUserReview,
                ),
        findCurrentUserReview:
            (List<ReviewEntity> reviews, User? currentUser) =>
                ref.read(reviewServiceProvider).findCurrentUserReview(reviews),
      ),
    );
  }

  void _handleFloatingActionButtonPressed(
    BuildContext context,
    WidgetRef ref,
    ReviewEntity? currentUserReview,
  ) {
    if (currentUserReview != null) {
      // User has an existing review, show edit modal
      _editReviewModalSheet(context, ref, currentUserReview);
    } else {
      // User doesn't have a review, show add modal
      _addReviewModalSheet(context, ref);
    }
  }

  void _handleEditReview(
    BuildContext context,
    WidgetRef ref,
    ReviewEntity review,
  ) {
    _editReviewModalSheet(context, ref, review);
  }

  void _handleDeleteReview(
    BuildContext context,
    WidgetRef ref,
    String reviewId,
  ) {
    _deleteReview(context, ref, reviewId);
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: const Text(AppStrings.kLoginRequired),
            content: const Text(AppStrings.kLoginToWriteReview),
            actions: <Widget>[
              TextButton(
                onPressed: () => context.pop(),
                child: const Text(AppStrings.kCancel),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text(AppStrings.kLoginButton),
              ),
            ],
          ),
    );
  }

  Future<dynamic> _addReviewModalSheet(BuildContext context, WidgetRef ref) {
    // Initialize form for new review
    ref.read(reviewFormProvider.notifier).initializeFormData(null);

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder:
          (BuildContext context) => Consumer(
            builder:
                (BuildContext context, WidgetRef ref, Widget? child) =>
                    ReviewModalContent(
                      currentUserReview: null,
                      onSubmit:
                          (content) => _submitReview(context, ref, content),
                      onDelete: () {}, // Empty function for new reviews
                    ),
          ),
    );
  }

  Future<dynamic> _editReviewModalSheet(
    BuildContext context,
    WidgetRef ref,
    ReviewEntity currentUserReview,
  ) {
    // Initialize form with existing review data
    ref.read(reviewFormProvider.notifier).initializeFormData(currentUserReview);

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder:
          (BuildContext context) => Consumer(
            builder:
                (
                  BuildContext context,
                  WidgetRef ref,
                  Widget? child,
                ) => ReviewModalContent(
                  currentUserReview: currentUserReview,
                  onSubmit: (content) => _updateReview(context, ref, content),
                  onDelete:
                      () => _deleteReview(context, ref, currentUserReview.id),
                ),
          ),
    );
  }

  void _submitReview(BuildContext context, WidgetRef ref, String content) {
    final ReviewService reviewService = ref.read(reviewServiceProvider);
    final ReviewFormState formState = ref.read(reviewFormProvider);

    if (!reviewService.validateForm(formState.rating, content)) {
      if (formState.rating == 0) {
        _showSnackBar(
          context,
          AppStrings.kPleaseProvideRating,
          SnackBarType.error,
        );
      } else if (content.trim().isEmpty) {
        _showSnackBar(
          context,
          AppStrings.kPleaseWriteReview,
          SnackBarType.error,
        );
      }
      return;
    }

    if (!reviewService.isUserLoggedIn) {
      _showLoginPrompt(context);
      return;
    }

    // Only add new reviews
    reviewService.addReview(product.id, content);
    _showSnackBar(
      context,
      AppStrings.kReviewAddedSuccessfully,
      SnackBarType.success,
    );

    context.pop();
  }

  void _updateReview(BuildContext context, WidgetRef ref, String content) {
    final ReviewService reviewService = ref.read(reviewServiceProvider);
    final ReviewFormState formState = ref.read(reviewFormProvider);

    if (!reviewService.validateForm(formState.rating, content)) {
      if (formState.rating == 0) {
        _showSnackBar(
          context,
          AppStrings.kPleaseProvideRating,
          SnackBarType.error,
        );
      } else if (content.trim().isEmpty) {
        _showSnackBar(
          context,
          AppStrings.kPleaseWriteReview,
          SnackBarType.error,
        );
      }
      return;
    }

    if (!reviewService.isUserLoggedIn) {
      _showLoginPrompt(context);
      return;
    }

    // Update existing review
    reviewService.updateReview(product.id, content);
    _showSnackBar(context, AppStrings.kReviewUpdated, SnackBarType.success);

    context.pop();
  }

  void _deleteReview(BuildContext context, WidgetRef ref, String reviewId) {
    final ReviewService reviewService = ref.read(reviewServiceProvider);

    if (!reviewService.isUserLoggedIn) {
      _showLoginPrompt(context);
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: const Text(AppStrings.kDeleteReview),
            content: const Text(AppStrings.kDeleteReviewConfirmation),
            actions: <Widget>[
              TextButton(
                onPressed: () => context.pop(),
                child: const Text(AppStrings.kCancel),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pop();
                  // Delete the review
                  reviewService.deleteReview(product.id, reviewId);
                  _showSnackBar(
                    context,
                    AppStrings.kReviewDeleted,
                    SnackBarType.success,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text(AppStrings.kDelete),
              ),
            ],
          ),
    );
  }

  void _showSnackBar(BuildContext context, String message, SnackBarType type) {
    openStyledSnackBar(context, text: message, type: type);
  }
}
