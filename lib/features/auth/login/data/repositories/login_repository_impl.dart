import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/error/firebase_failure.dart';
import '../../../../../core/error/socket_failure.dart';
import '../datasources/login_data_source.dart';
import '../../domain/repositories/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl(this.loginDataSource);
  LoginDataSource loginDataSource;

  @override
  Future<Either<Failure, void>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await loginDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(FirebaseFailure.fromCode(e.code));
    } on SocketException catch (e) {
      return left(SocketFailure.fromCode(e.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
