import '../../../../../core/helpers/type_defs.dart/type_defs.dart';
import '../repositories/register_repository.dart';

class RegisterWithEmailAndPasswordUsecase {
  RegisterWithEmailAndPasswordUsecase(this.registerRepository);
  final RegisterRepository registerRepository;

  AuthType execute({
    required String email,
    required String name,
    required String password,
  }) async => await registerRepository.registerWithEmailAndPassword(
    email: email,
    name: name,
    password: password,
  );
}
