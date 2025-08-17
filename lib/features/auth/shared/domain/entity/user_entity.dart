import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.createdAt,
  });
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
  final DateTime createdAt;

  @override
  List<Object?> get props => [uid, email, name, photoUrl, createdAt];
}
