import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  const ReviewEntity({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userImageUrl,
    required this.content,
    required this.rating,
    this.reviewImagesUrls,
    required this.helpfulUserIds,
    this.helpfulCount = 0,
    required this.createdAt,
    this.updatedAt,
  });
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String? userImageUrl;
  final String content;
  final double rating;
  final List<String>? reviewImagesUrls;
  final List<String> helpfulUserIds; // Users who marked this as helpful
  final int helpfulCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ReviewEntity copyWith({
    String? id,
    String? productId,
    String? userId,
    String? userName,
    String? userImageUrl,
    String? content,
    double? rating,
    List<String>? reviewImagesUrls,
    List<String>? helpfulUserIds,
    int? helpfulCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ReviewEntity(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    userImageUrl: userImageUrl ?? this.userImageUrl,
    content: content ?? this.content,
    rating: rating ?? this.rating,
    reviewImagesUrls: reviewImagesUrls ?? this.reviewImagesUrls,
    helpfulUserIds: helpfulUserIds ?? this.helpfulUserIds,
    helpfulCount: helpfulCount ?? this.helpfulCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'productId': productId,
    'userId': userId,
    'userName': userName,
    'userImageUrl': userImageUrl,
    'content': content,
    'rating': rating,
    'reviewImagesUrls': reviewImagesUrls,
    'helpfulUserIds': helpfulUserIds,
    'helpfulCount': helpfulCount,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  @override
  List<Object?> get props => <Object?>[
    id,
    productId,
    userId,
    userName,
    userImageUrl,
    content,
    rating,
    reviewImagesUrls,
    helpfulUserIds,
    helpfulCount,
    createdAt,
    updatedAt,
  ];
}
