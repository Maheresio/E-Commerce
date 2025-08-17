import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../auth_handle_repository_exceptions.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_source/auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this.authDataSource);

  final AuthDataSource authDataSource;

  @override
  Future<Either<Failure, UserEntity?>> signInWithGoogle() async {
    return handleAuthRepositoryExceptions(
      () async => authDataSource.signInWithGoogle(),
    );
  }

  @override
  Future<Either<Failure, UserEntity?>> signInWithFacebook() async {
    return handleAuthRepositoryExceptions(
      () => authDataSource.signInWithFacebook(),
    );
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    return handleAuthRepositoryExceptions(() async {
      await authDataSource.logOut();
      return;
    });
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return authDataSource.authStateChanges().map(
      (user) =>
          user != null
              ? UserEntity(
                uid: user.uid,
                email: user.email ?? '',
                name: user.displayName ?? '',
                photoUrl: user.photoURL,
                createdAt: DateTime.now(),
              )
              : null,
    );
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUserData() async {
    return handleAuthRepositoryExceptions(
      () => authDataSource.getCurrentUserData(),
    );
  }
}
