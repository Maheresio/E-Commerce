import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../domain/entities/review_entity.dart';
import 'rating_overview_widget.dart';
import 'review_list_widget.dart';
import 'review_view_header.dart';

class ReviewViewBody extends StatelessWidget {
  const ReviewViewBody({
    super.key,
    required this.product,
    this.onHelpfulPressed,
    this.onEditReview,
    this.onDeleteReview,
    this.isUserLoggedIn = false,
    this.currentUserId,
  });

  final ProductEntity product;
  final Function(String reviewId)? onHelpfulPressed;
  final Function(ReviewEntity review)? onEditReview;
  final Function(String reviewId)? onDeleteReview;
  final bool isUserLoggedIn;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReviewViewHeader(),

        // Rating overview section
        RatingOverviewWidget(product: product),
        const SizedBox(height: 16),

        // Reviews list or empty state
        Expanded(
          child: ReviewListWidget(
            reviews: (product.reviews ?? []).cast<ReviewEntity>(),
            productRating: product.rating,
            onHelpfulPressed: onHelpfulPressed,
            onEditReview: onEditReview,
            onDeleteReview: onDeleteReview,
            isUserLoggedIn: isUserLoggedIn,
            currentUserId: currentUserId,
          ),
        ),

        const SizedBox(height: 20),
      ],
    ),
  );
}
