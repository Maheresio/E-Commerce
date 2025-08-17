

import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../shared/data/auth_handle_repository_exceptions.dart';
import '../datasources/login_data_source.dart';
import '../../domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl(this.loginDataSource);
  LoginDataSource loginDataSource;

  @override
  Future<Either<Failure, void>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return handleAuthRepositoryExceptions(() async {
      await loginDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      return;
    });
  }
}
