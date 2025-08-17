import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginDataSource {
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
}

class LoginDataSourceImpl implements LoginDataSource {
  const LoginDataSourceImpl({required this.firebaseAuth});

  final FirebaseAuth firebaseAuth;

  @override
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
