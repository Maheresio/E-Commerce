import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/services/firestore_sevice.dart';
import '../../../../core/utils/app_strings.dart';
import '../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<List<ReviewModel>> getProductReviews(String productId);
  Future<ReviewModel?> getUserReviewForProduct(String productId, String userId);
  Future<String> addReviewToProduct(String productId, ReviewModel review);
  Future<String> updateReviewInProduct(String productId, ReviewModel review);
  Future<String> deleteReviewFromProduct(String productId, String reviewId);
  Future<String> markReviewHelpful({
    required String productId,
    required String reviewId,
    required String userId,
  });
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  ReviewRemoteDataSourceImpl({required this.firestoreServices});
  final FirestoreServices firestoreServices;

  @override
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    // Get product document and extract embedded reviews
    final DocumentSnapshot<Map<String, dynamic>> productDoc =
        await firestoreServices.getDocument(
          path: '${FirestoreConstants.products}$productId',
        );

    if (!productDoc.exists || productDoc.data() == null) {
      return <ReviewModel>[];
    }

    final Map<String, dynamic> productData = productDoc.data()!;
    final List reviewsData =
        productData['reviews'] as List<dynamic>? ?? <dynamic>[];

    return reviewsData
        .map(
          (reviewData) => ReviewModel.fromMap(
            reviewData['id'] ?? '',
            Map<String, dynamic>.from(reviewData),
          ),
        )
        .toList();
  }

  @override
  Future<ReviewModel?> getUserReviewForProduct(
    String productId,
    String userId,
  ) async {
    final List<ReviewModel> reviews = await getProductReviews(productId);

    try {
      return reviews.firstWhere(
        (ReviewModel review) => review.userId == userId,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> addReviewToProduct(
    String productId,
    ReviewModel review,
  ) async {
    final String productPath = '${FirestoreConstants.products}$productId';

    // Get current product data
    final DocumentSnapshot<Map<String, dynamic>> productDoc =
        await firestoreServices.getDocument(path: productPath);

    if (!productDoc.exists || productDoc.data() == null) {
      throw Exception(AppStrings.kProductNotFound);
    }

    final Map<String, dynamic> productData = productDoc.data()!;
    final List<Map<String, dynamic>> currentReviews =
        List<Map<String, dynamic>>.from(
          productData['reviews'] as List<dynamic>? ?? <dynamic>[],
        );

    // Check if user already has a review for this product
    final bool hasExistingReview = currentReviews.any(
      (Map<String, dynamic> r) => r['userId'] == review.userId,
    );
    if (hasExistingReview) {
      throw Exception(AppStrings.kUserAlreadyHasReview);
    }

    // Generate unique ID for the review
    final String reviewId = await firestoreServices.getPath();

    final ReviewModel reviewModel = ReviewModel.fromEntity(
      review.copyWith(id: reviewId),
    );

    // Add new review to the list
    currentReviews.add(reviewModel.toMap());

    // Update product with new reviews array
    await firestoreServices.updateData(
      path: productPath,
      data: <String, dynamic>{'reviews': currentReviews},
    );

    return reviewId;
  }

  @override
  Future<String> updateReviewInProduct(
    String productId,
    ReviewModel review,
  ) async {
    final String productPath = '${FirestoreConstants.products}$productId';

    // Get current product data
    final DocumentSnapshot<Map<String, dynamic>> productDoc =
        await firestoreServices.getDocument(path: productPath);

    if (!productDoc.exists || productDoc.data() == null) {
      throw Exception(AppStrings.kProductNotFound);
    }

    final Map<String, dynamic> productData = productDoc.data()!;
    final List<Map<String, dynamic>> currentReviews =
        List<Map<String, dynamic>>.from(
          productData['reviews'] as List<dynamic>? ?? <dynamic>[],
        );

    // Find and update the existing review
    final int reviewIndex = currentReviews.indexWhere(
      (Map<String, dynamic> r) => r['id'] == review.id,
    );

    if (reviewIndex == -1) {
      throw Exception(AppStrings.kReviewNotFound);
    }

    // Update the review with new data and set updatedAt timestamp
    final Map<String, dynamic> updatedReview =
        review.toMap()..['updatedAt'] = DateTime.now().toIso8601String();

    currentReviews[reviewIndex] = updatedReview;

    // Update product with updated reviews array
    await firestoreServices.updateData(
      path: productPath,
      data: <String, dynamic>{'reviews': currentReviews},
    );

    return review.id;
  }

  @override
  Future<String> deleteReviewFromProduct(
    String productId,
    String reviewId,
  ) async {
    final String productPath = '${FirestoreConstants.products}$productId';

    // Get current product data
    final DocumentSnapshot<Map<String, dynamic>> productDoc =
        await firestoreServices.getDocument(path: productPath);

    if (!productDoc.exists || productDoc.data() == null) {
      throw Exception(AppStrings.kProductNotFound);
    }

    final Map<String, dynamic> productData = productDoc.data()!;
    final List<Map<String, dynamic>> currentReviews =
        List<Map<String, dynamic>>.from(
          productData['reviews'] as List<dynamic>? ?? <dynamic>[],
        );

    // Remove the review with the specified ID
    currentReviews.removeWhere((Map<String, dynamic> r) => r['id'] == reviewId);

    // Update product with updated reviews array
    await firestoreServices.updateData(
      path: productPath,
      data: <String, dynamic>{'reviews': currentReviews},
    );

    return reviewId;
  }

  @override
  Future<String> markReviewHelpful({
    required String productId,
    required String reviewId,
    required String userId,
  }) async {
    final String productPath = '${FirestoreConstants.products}$productId';

    // Get current product data
    final DocumentSnapshot<Map<String, dynamic>> productDoc =
        await firestoreServices.getDocument(path: productPath);

    if (!productDoc.exists || productDoc.data() == null) {
      throw Exception(AppStrings.kProductNotFound);
    }

    final Map<String, dynamic> productData = productDoc.data()!;
    final List<Map<String, dynamic>> currentReviews =
        List<Map<String, dynamic>>.from(
          productData['reviews'] as List<dynamic>? ?? <dynamic>[],
        );

    // Find the review to mark as helpful
    final int reviewIndex = currentReviews.indexWhere(
      (Map<String, dynamic> r) => r['id'] == reviewId,
    );

    if (reviewIndex == -1) {
      throw Exception(AppStrings.kReviewNotFound);
    }

    final Map<String, dynamic> review = currentReviews[reviewIndex];
    final List<String> helpfulUserIds = List<String>.from(
      review['helpfulUserIds'] as List<dynamic>? ?? <dynamic>[],
    );

    // Check if user already marked this review as helpful
    if (helpfulUserIds.contains(userId)) {
      throw Exception(AppStrings.kUserAlreadyMarkedHelpful);
    }

    // Add user to helpful list and increment count
    helpfulUserIds.add(userId);
    final int currentHelpfulCount = review['helpfulCount'] as int? ?? 0;
    final int newHelpfulCount = currentHelpfulCount + 1;

    // Update the review with new helpful data
    currentReviews[reviewIndex] = {
      ...review,
      'helpfulUserIds': helpfulUserIds,
      'helpfulCount': newHelpfulCount,
    };

    // Update product with updated reviews array
    await firestoreServices.updateData(
      path: productPath,
      data: <String, dynamic>{'reviews': currentReviews},
    );

    return reviewId;
  }
}
