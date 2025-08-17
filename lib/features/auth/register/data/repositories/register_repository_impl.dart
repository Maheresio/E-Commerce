import '../../../shared/data/auth_handle_repository_exceptions.dart';
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
    return handleAuthRepositoryExceptions(() async {
      await registerDataSource.registerWithEmailAndPassword(
        email: email,
        name: name,
        password: password,
      );
      return;
    });
  }
}
