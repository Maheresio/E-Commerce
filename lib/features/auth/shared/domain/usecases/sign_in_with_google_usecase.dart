import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../entity/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase implements UseCase<UserEntity?, NoParams> {
  const SignInWithGoogleUseCase(this.authRepository);

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, UserEntity?>> execute(NoParams params) async {
    return await authRepository.signInWithGoogle();
  }
}
