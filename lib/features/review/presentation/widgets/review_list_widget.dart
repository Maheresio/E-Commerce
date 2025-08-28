import 'package:flutter/material.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';

import '../../domain/entities/review_entity.dart';
import 'review_item_widget.dart';

/// Widget to display the list of reviews
class ReviewListWidget extends StatelessWidget {
  const ReviewListWidget({
    super.key,
    required this.reviews,
    required this.productRating,
    this.onHelpfulPressed,
    this.onEditReview,
    this.onDeleteReview,
    this.isUserLoggedIn = false,
    this.currentUserId,
  });

  final List<ReviewEntity> reviews;
  final double productRating;
  final Function(String reviewId)? onHelpfulPressed;
  final Function(ReviewEntity review)? onEditReview;
  final Function(String reviewId)? onDeleteReview;
  final bool isUserLoggedIn;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.rate_review_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.kNoReviewsYet,
              style: AppStyles.font24BlackSemiBold(context),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.kWriteAReview,
              style: AppStyles.font14GreyMedium(context),
            ),
          ],
        ),
      );
    }

    // Sort reviews: user's review first, then others by date (newest first)
    final List<ReviewEntity> sortedReviews = List<ReviewEntity>.from(reviews);
    sortedReviews.sort((ReviewEntity a, ReviewEntity b) {
      // If current user ID is available, prioritize user's review
      if (currentUserId != null) {
        if (a.userId == currentUserId && b.userId != currentUserId) {
          return -1; // User's review comes first
        }
        if (b.userId == currentUserId && a.userId != currentUserId) {
          return 1; // User's review comes first
        }
      }
      // If both are user's reviews or both are not, sort by date (newest first)
      return b.createdAt.compareTo(a.createdAt);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Header with reviews count
        Text(
          '${reviews.length} ${AppStrings.kReviews}',
          style: AppStyles.font24BlackSemiBold(context),
        ),
        const SizedBox(height: 8),

        // Reviews list
        Expanded(
          child: ListView.separated(
            itemCount: sortedReviews.length,
            itemBuilder: (BuildContext context, int index) {
              final ReviewEntity review = sortedReviews[index];
              final bool isUserReview =
                  currentUserId != null && review.userId == currentUserId;

              return ReviewItemWidget(
                review: review,
                productRating: productRating,
                onHelpfulPressed:
                    onHelpfulPressed != null
                        ? () => onHelpfulPressed!(review.id)
                        : null,
                onEditPressed:
                    isUserReview && onEditReview != null
                        ? () => onEditReview!(review)
                        : null,
                onDeletePressed:
                    isUserReview && onDeleteReview != null
                        ? () => onDeleteReview!(review.id)
                        : null,
                isUserLoggedIn: isUserLoggedIn,
                isUserReview: isUserReview,
              );
            },
            separatorBuilder:
                (BuildContext context, int index) => const SizedBox(height: 12),
          ),
        ),
      ],
    );
  }
}
