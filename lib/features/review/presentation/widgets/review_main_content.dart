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
      return _ReviewViewBodyWrapper(
        product: updatedProduct,
        currentUser: currentUser,
        onHelpfulPressed: onHelpfulPressed,
        onEditReview: onEditReview,
        onDeleteReview: onDeleteReview,
      );
    },
    loading:
        () => _ReviewViewBodyWrapper(
          product: product,
          currentUser: currentUser,
          onHelpfulPressed: onHelpfulPressed,
          onEditReview: onEditReview,
          onDeleteReview: onDeleteReview,
        ),
    error:
        (error, stack) => _ReviewViewBodyWrapper(
          product: product,
          currentUser: currentUser,
          onHelpfulPressed: onHelpfulPressed,
          onEditReview: onEditReview,
          onDeleteReview: onDeleteReview,
        ),
  );
}

class _ReviewViewBodyWrapper extends StatelessWidget {
  const _ReviewViewBodyWrapper({
    required this.product,
    required this.currentUser,
    required this.onHelpfulPressed,
    required this.onEditReview,
    required this.onDeleteReview,
  });

  final ProductEntity product;
  final User? currentUser;
  final Function(String)? onHelpfulPressed;
  final Function(ReviewEntity)? onEditReview;
  final Function(String)? onDeleteReview;

  @override
  Widget build(BuildContext context) => ReviewViewBody(
    product: product,
    onHelpfulPressed: onHelpfulPressed,
    onEditReview: onEditReview,
    onDeleteReview: onDeleteReview,
    isUserLoggedIn: currentUser != null,
    currentUserId: currentUser?.uid,
  );
}
