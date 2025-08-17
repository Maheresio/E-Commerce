import 'package:firebase_auth/firebase_auth.dart';

import '../constants/firestore_constants.dart';
import 'firestore_sevice.dart';

class CurrentUserService {
  const CurrentUserService({
    required this.firebaseAuth,
    required this.firestoreServices,
  });

  final FirebaseAuth firebaseAuth;
  final FirestoreServices firestoreServices;

  /// Get the current Firebase user
  User? get currentFirebaseUser => firebaseAuth.currentUser;

  /// Get current user ID
  String? get currentUserId => firebaseAuth.currentUser?.uid;

  /// Get current user data from Firestore
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final User? user = firebaseAuth.currentUser;
    if (user == null) return null;

    try {
      final doc = await firestoreServices.getDocument(
        path: FirestoreConstants.user(user.uid),
      );
      return doc.data();
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => firebaseAuth.currentUser != null;

  /// Get current user email
  String? get currentUserEmail => firebaseAuth.currentUser?.email;

  /// Get current user display name
  String? get currentUserDisplayName => firebaseAuth.currentUser?.displayName;
}
