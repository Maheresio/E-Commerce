import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../domain/entities/review_entity.dart';
import 'review_view_body.dart';

class ReviewMainContent extends StatelessWidget {
  const ReviewMainContent({
    super.key,
    required this.reviewsAsync,
    required this.currentUser,
    required this.product,
    this.onHelpfulPressed,
    this.onEditReview,
    this.onDeleteReview,
  });

  final AsyncValue<List<ReviewEntity>> reviewsAsync;
  final User? currentUser;
  final ProductEntity product;
  final Function(String)? onHelpfulPressed;
  final Function(ReviewEntity)? onEditReview;
  final Function(String)? onDeleteReview;

  @override
  Widget build(BuildContext context) => reviewsAsync.when(
    data: (reviews) {
      final updatedProduct = product.copyWith(reviews: reviews);
      return _buildReviewViewBody(updatedProduct, currentUser);
    },
    loading: () => _buildReviewViewBody(product, currentUser),
    error: (error, stack) => _buildReviewViewBody(product, currentUser),
  );

  Widget _buildReviewViewBody(ProductEntity product, User? currentUser) =>
      ReviewViewBody(
        product: product,
        onHelpfulPressed: onHelpfulPressed,
        onEditReview: onEditReview,
        onDeleteReview: onDeleteReview,
        isUserLoggedIn: currentUser != null,
        currentUserId: currentUser?.uid,
      );
}
