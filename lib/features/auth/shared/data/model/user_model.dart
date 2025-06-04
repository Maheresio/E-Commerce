import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/features/auth/shared/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.email,
    required super.name,
    required super.createdAt,
    super.photoUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] as String,
      name: map['name'] as String,
      photoUrl: map['photoUrl'] as String?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
