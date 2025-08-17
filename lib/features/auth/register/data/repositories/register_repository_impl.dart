import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/firebase_failure.dart';
import '../../../../../core/error/socket_failure.dart';
import '../../../../../core/helpers/type_defs.dart/type_defs.dart';
import '../../domain/repositories/register_repository.dart';
import '../datasources/register_data_source.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  RegisterRepositoryImpl(this.registerDataSource);
  final RegisterDataSource registerDataSource;

  @override
  AuthType registerWithEmailAndPassword({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      await registerDataSource.registerWithEmailAndPassword(
        email: email,
        name: name,
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
