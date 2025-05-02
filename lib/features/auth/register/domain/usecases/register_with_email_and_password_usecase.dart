import '../../../../../core/helpers/type_defs.dart/type_defs.dart';
import '../repositories/register_repository.dart';

class RegisterWithEmailAndPasswordUsecase {
  final RegisterRepository registerRepository;

  RegisterWithEmailAndPasswordUsecase(this.registerRepository);

  AuthType execute({
    required String email,
    required String name,
    required String password,
  }) async {
    return await registerRepository.registerWithEmailAndPassword(
      email: email,
      name: name,
      password: password,
    );
  }
}
