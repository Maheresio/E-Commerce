import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String userId;
  final String userName;
  final String userImageUrl;
  final String content;
  final double rating;
  final List<String>? reviewImagesUrls;
  final int helpfulCount;
  final DateTime createdAt;

  const ReviewEntity({
    required this.userId,
    required this.userImageUrl,
    required this.content,
    required this.rating,
    required this.createdAt,
    this.reviewImagesUrls,
    required this.userName,
    this.helpfulCount = 0,
  });

  @override
  List<Object?> get props => [
    userId,
    userImageUrl,
    content,
    rating,
    createdAt,
    reviewImagesUrls,
    userName,
  ];
}
