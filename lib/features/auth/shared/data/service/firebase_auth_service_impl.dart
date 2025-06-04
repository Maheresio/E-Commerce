import '../../../../../core/constants/firestore_constants.dart';
import '../../../../../core/services/firestore_sevice.dart';
import '../model/user_model.dart';
import '../../domain/entity/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/services/firebase_auth_service.dart';

class FirebaseAuthServiceImpl implements FirebaseAuthService {
  final FirebaseAuth firebaseAuth;
  final FirestoreServices firestoreServices;
  const FirebaseAuthServiceImpl({
    required this.firebaseAuth,
    required this.firestoreServices,
  });

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

  @override
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String name,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userCredential.user?.updateDisplayName(name);

    final uid = userCredential.user!.uid;

    final user = UserModel(
      uid: uid,
      email: email,
      name: name,
      createdAt: DateTime.now(),
    );

    await firestoreServices.setData(
      path: FirestoreConstants.user(uid),
      data: user.toMap(),
    );
  }

  @override
  Stream<User?> authStateChanges() => firebaseAuth.authStateChanges();

  @override
  Future<UserEntity?> currentUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;

    final docStream = firestoreServices.documentsStream(
      path: FirestoreConstants.user(user.uid),
      builder: (data, documentId) {
        if (data == null) return null;
        return UserModel.fromMap(data, documentId);
      },
    );

    final doc = await docStream.first;

    return doc;
  }

  @override
  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }
}
