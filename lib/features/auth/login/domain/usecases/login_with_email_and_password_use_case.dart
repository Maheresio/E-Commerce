import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../shared/domain/entity/email_validation.dart';
import '../../../shared/domain/entity/password_validation.dart';
import '../repositories/login_repository.dart';

class LoginWithEmailAndPasswordUseCase {
  LoginWithEmailAndPasswordUseCase(this.loginRepository);
  LoginRepository loginRepository;
  Future<Either<Failure, void>> execute({
    required String email,
    required String password,
  }) async {
    final EmailValidation emailOrFailure = EmailValidation(email);
    final PasswordValidation passwordOrFailure = PasswordValidation(password);

    return emailOrFailure.value.fold(
      left,
      (_) => passwordOrFailure.value.fold(
        left,
        (_) async => loginRepository.loginWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ),
    );
  }
}
