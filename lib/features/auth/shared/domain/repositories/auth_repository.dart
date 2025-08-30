import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity?>> signInWithGoogle();
  Future<Either<Failure, UserEntity?>> signInWithFacebook();
  Future<Either<Failure, void>> logOut();
  Stream<UserEntity?> get authStateChanges;
  Future<Either<Failure, UserEntity?>> getCurrentUserData();
}
