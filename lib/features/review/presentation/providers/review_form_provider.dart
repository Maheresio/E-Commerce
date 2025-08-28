import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/review_entity.dart';

class ReviewFormState {
  const ReviewFormState({
    this.rating = 0.0,
    this.selectedImages = const <String>[],
    this.currentUserReview,
  });

  final double rating;
  final List<String> selectedImages;
  final ReviewEntity? currentUserReview;

  ReviewFormState copyWith({
    double? rating,
    List<String>? selectedImages,
    ReviewEntity? currentUserReview,
    bool clearCurrentUserReview = false,
  }) => ReviewFormState(
    rating: rating ?? this.rating,
    selectedImages: selectedImages ?? this.selectedImages,
    currentUserReview:
        clearCurrentUserReview
            ? null
            : (currentUserReview ?? this.currentUserReview),
  );
}

class ReviewFormNotifier extends StateNotifier<ReviewFormState> {
  ReviewFormNotifier() : super(const ReviewFormState());

  void updateRating(double rating) {
    state = state.copyWith(rating: rating);
  }

  void updateSelectedImages(List<String> images) {
    state = state.copyWith(selectedImages: images);
  }

  void removeImage(String imageUrl) {
    final List<String> updatedImages = List<String>.from(state.selectedImages)
      ..remove(imageUrl);
    state = state.copyWith(selectedImages: updatedImages);
  }

  void setCurrentUserReview(ReviewEntity? review) {
    state = state.copyWith(currentUserReview: review);
  }

  void initializeFormData(ReviewEntity? currentUserReview) {
    if (currentUserReview != null) {
      state = ReviewFormState(
        rating: currentUserReview.rating,
        selectedImages: currentUserReview.reviewImagesUrls ?? <String>[],
        currentUserReview: currentUserReview,
      );
    } else {
      state = const ReviewFormState();
    }
  }

  void clearForm() {
    state = const ReviewFormState();
  }
}

final StateNotifierProvider<ReviewFormNotifier, ReviewFormState>
reviewFormProvider = StateNotifierProvider<ReviewFormNotifier, ReviewFormState>(
  (ref) => ReviewFormNotifier(),
);
