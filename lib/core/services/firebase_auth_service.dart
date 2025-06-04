import 'package:firebase_auth/firebase_auth.dart';

import '../../features/auth/shared/domain/entity/user_entity.dart';

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
  Stream<User?> authStateChanges();

  Future<UserEntity?>  currentUser();

  Future<void> logOut();
}
