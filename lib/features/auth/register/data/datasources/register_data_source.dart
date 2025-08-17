import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/constants/firestore_constants.dart';
import '../../../../../core/services/firestore_sevice.dart';
import '../../../shared/data/model/user_model.dart';

abstract class RegisterDataSource {
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String name,
    required String password,
  });
}

class RegisterDataSourceImpl implements RegisterDataSource {
  const RegisterDataSourceImpl({
    required this.firebaseAuth,
    required this.firestoreServices,
  });

  final FirebaseAuth firebaseAuth;
  final FirestoreServices firestoreServices;

  @override
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String name,
    required String password,
  }) async {
    final UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    await userCredential.user?.updateDisplayName(name);

    final String uid = userCredential.user!.uid;

    final UserModel user = UserModel(
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
}
