import '../../../../../core/helpers/type_defs.dart/type_defs.dart';

abstract class RegisterRepository {
  AuthType registerWithEmailAndPassword({
    required String email,
    required String name,
    required String password,
  });
}
