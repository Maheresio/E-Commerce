import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../../core/services/firestore_sevice.dart';
import '../../../../../core/constants/firestore_constants.dart';
import '../model/user_model.dart';
import '../../domain/entity/user_entity.dart';
import '../service/auth_cancel_exception.dart';

abstract class AuthDataSource {
  Future<void> logOut();
  Stream<User?> authStateChanges();
  User? get currentUser;
  Future<UserEntity?> signInWithGoogle();
  Future<UserEntity?> signInWithFacebook();
  Future<UserEntity?> getCurrentUserData();
}

class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl({
    required this.firebaseAuth,
    required this.firestoreServices,
  }) {
    _initializeGoogleSignIn();
  }

  final FirebaseAuth firebaseAuth;
  final FirestoreServices firestoreServices;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  Future<void> _initializeGoogleSignIn() async {
    await _googleSignIn.initialize(
      serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
    );
    _isGoogleSignInInitialized = true;
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn();
    }
  }

  @override
  Future<void> logOut() async {
    await Future.wait([
      firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      FacebookAuth.instance.logOut(),
    ]);
  }

  @override
  Stream<User?> authStateChanges() => firebaseAuth.authStateChanges();

  @override
  User? get currentUser => firebaseAuth.currentUser;

  @override
  Future<UserEntity?> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();

    // Use the new authenticate() method with scopeHint
    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
      scopeHint: ['email', 'profile'],
    );

    // Authentication is now synchronous in v7
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final String? idToken = googleAuth.idToken;

    if (idToken == null) throw Exception('Google ID token was null.');

    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: idToken,
    );
    return await _signInWithCredential(credential);
  }

  @override
  Future<UserEntity?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: const ['email', 'public_profile'],
    );

    switch (result.status) {
      case LoginStatus.success:
        final accessToken = result.accessToken;
        final token = accessToken?.tokenString;
        if (token == null || token.isEmpty) {
          throw Exception('Missing Facebook access token.');
        }
        final credential = FacebookAuthProvider.credential(token);
        return await _signInWithCredential(credential);

      case LoginStatus.cancelled:
        throw const AuthCanceledException('facebook');

      case LoginStatus.failed:
      default:
        final msg =
            result.message?.isNotEmpty == true
                ? result.message
                : 'Facebook login failed';
        throw Exception(msg);
    }
  }

  @override
  Future<UserEntity?> getCurrentUserData() async {
    final User? user = firebaseAuth.currentUser;
    if (user == null) return null;
    return await _getUserFromFirestore(user.uid);
  }

  /// Helper method to sign in with any credential (Google, Facebook, etc.)
  Future<UserEntity?> _signInWithCredential(OAuthCredential credential) async {
    final UserCredential userCredential = await firebaseAuth
        .signInWithCredential(credential);
    final User? firebaseUser = userCredential.user;
    if (firebaseUser == null) return null;

    await _waitUntilAuthVisibleToFirestore(firebaseUser);

    final newUser = UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? 'User',
      photoUrl: firebaseUser.photoURL,
      createdAt: DateTime.now(),
    );

    await firestoreServices.setData(
      path: FirestoreConstants.user(firebaseUser.uid),
      merge: true,
      data: newUser.toMap(),
    );

    await firebaseAuth.currentUser?.reload();
    final UserEntity? ensured = await _getUserFromFirestore(firebaseUser.uid);
    return ensured ?? newUser;
  }

  /// Helper method to get user data from Firestore
  Future<UserEntity?> _getUserFromFirestore(String uid) async {
    final doc = await FirebaseFirestore.instance
        .doc(FirestoreConstants.user(uid))
        .get(const GetOptions(source: Source.server)); // force server read
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data, doc.id);
  }

  Future<void> _waitUntilAuthVisibleToFirestore(User user) async {
    // Ensure token is minted & broadcast to Firestore
    await user.getIdToken(true);
    await firebaseAuth.idTokenChanges().firstWhere((u) => u?.uid == user.uid);
  }
}
