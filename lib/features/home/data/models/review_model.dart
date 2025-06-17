import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.userId,
    required super.userName,
    required super.userImageUrl,
    required super.content,
    required super.rating,
    required super.createdAt,
    super.reviewImagesUrls,
    super.helpfulCount = 0,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userImageUrl: json['userImageUrl'] as String,
      content: json['content'] as String,
      rating: (json['rating'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      reviewImagesUrls:
          (json['reviewImagesUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      helpfulCount: json['helpfulCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userImageUrl': userImageUrl,
      'content': content,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'reviewImagesUrls': reviewImagesUrls,
      'helpfulCount': helpfulCount,
    };
  }
}
