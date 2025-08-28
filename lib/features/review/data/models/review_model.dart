import '../../domain/entities/review_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.productId,
    required super.userId,
    required super.userName,
    super.userImageUrl,
    required super.content,
    required super.rating,
    required super.createdAt,
    super.reviewImagesUrls,
    required super.helpfulUserIds,
    super.helpfulCount = 0,
    super.updatedAt,
  });

  factory ReviewModel.fromMap(String id, Map<String, dynamic> json) {
    return ReviewModel(
      id: id,
      productId: json['productId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userImageUrl: json['userImageUrl'],
      content: json['content'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,

      // Handling Timestamp to DateTime conversion for createdAt
      createdAt:
          json['createdAt'] is Timestamp
              ? (json['createdAt'] as Timestamp).toDate()
              : DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),

      reviewImagesUrls:
          json['reviewImagesUrls'] != null
              ? List<String>.from(json['reviewImagesUrls'])
              : null,
      helpfulUserIds:
          json['helpfulUserIds'] != null
              ? List<String>.from(json['helpfulUserIds'])
              : [],
      helpfulCount: json['helpfulCount'] ?? 0,

      // Handling Timestamp to DateTime conversion for updatedAt
      updatedAt:
          json['updatedAt'] is Timestamp
              ? (json['updatedAt'] as Timestamp).toDate()
              : (json['updatedAt'] != null
                  ? DateTime.tryParse(json['updatedAt'] ?? '')
                  : null),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'productId': productId,
    'userId': userId,
    'userName': userName,
    'userImageUrl': userImageUrl,
    'content': content,
    'rating': rating,
    'createdAt': createdAt.toIso8601String(),
    'reviewImagesUrls': reviewImagesUrls,
    'helpfulUserIds': helpfulUserIds,
    'helpfulCount': helpfulCount,
    'updatedAt': updatedAt?.toIso8601String(),
  };

  ReviewEntity toEntity() => ReviewEntity(
    id: id,
    productId: productId,
    userId: userId,
    userName: userName,
    userImageUrl: userImageUrl,
    content: content,
    rating: rating,
    createdAt: createdAt,
    reviewImagesUrls: reviewImagesUrls,
    helpfulUserIds: helpfulUserIds,
    helpfulCount: helpfulCount,
    updatedAt: updatedAt,
  );

  static ReviewModel fromEntity(ReviewEntity entity) => ReviewModel(
    id: entity.id,
    productId: entity.productId,
    userId: entity.userId,
    userName: entity.userName,
    userImageUrl: entity.userImageUrl,
    content: entity.content,
    rating: entity.rating,
    createdAt: entity.createdAt,
    reviewImagesUrls: entity.reviewImagesUrls,
    helpfulUserIds: entity.helpfulUserIds,
    helpfulCount: entity.helpfulCount,
    updatedAt: entity.updatedAt,
  );
}
