abstract class FirebaseAuthService {
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String name,
    required String password,
  });
}
