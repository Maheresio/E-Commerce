import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/review_entity.dart';

class ReviewFloatingActionButton extends StatelessWidget {
  const ReviewFloatingActionButton({
    super.key,
    required this.reviewsAsync,
    required this.currentUser,
    required this.onPressed,
    required this.findCurrentUserReview,
  });

  final AsyncValue<List<ReviewEntity>> reviewsAsync;
  final User? currentUser;
  final Function(ReviewEntity?) onPressed;
  final ReviewEntity? Function(List<ReviewEntity>, User?) findCurrentUserReview;

  @override
  Widget build(BuildContext context) => reviewsAsync.maybeWhen(
    data: (reviews) {
      final currentUserReview = findCurrentUserReview(reviews, currentUser);
      return FloatingActionButton.extended(
        onPressed: () => onPressed(currentUserReview),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icon(currentUserReview != null ? Icons.edit : Icons.add),
        label: Text(currentUserReview != null ? 'Edit Review' : 'Add Review'),
      );
    },
    orElse:
        () => FloatingActionButton.extended(
          onPressed: () => onPressed(null),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('Add Review'),
        ),
  );
}
