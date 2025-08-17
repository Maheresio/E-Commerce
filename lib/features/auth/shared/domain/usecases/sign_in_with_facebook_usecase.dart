import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../entity/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithFacebookUseCase implements UseCase<UserEntity?, NoParams> {
  const SignInWithFacebookUseCase(this.authRepository);

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) async {
    return await authRepository.signInWithFacebook();
  }
}
