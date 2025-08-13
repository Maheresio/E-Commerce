import 'failure.dart';

class FirebaseFailure extends Failure {
  const FirebaseFailure(super.message);

  factory FirebaseFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const FirebaseFailure(
          "Oops! The email address you entered doesn't seem to be valid. Please double-check and try again.",
        );
      case 'user-disabled':
        return const FirebaseFailure(
          'It looks like this account has been disabled. If you believe this is a mistake, please contact support for assistance.',
        );
      case 'user-not-found':
        return const FirebaseFailure(
          "We couldn't find an account with that email address. Please check the email or sign up for a new account.",
        );
      case 'wrong-password':
        return const FirebaseFailure(
          "The password you entered doesn't match our records. Please try again or reset your password if you've forgotten it.",
        );
      case 'too-many-requests':
        return const FirebaseFailure(
          "We've noticed too many login attempts. Please wait a moment and try again later.",
        );
      case 'user-token-expired':
        return const FirebaseFailure(
          'Your session has expired. Please log in again to continue.',
        );
      case 'network-request-failed':
        return const FirebaseFailure(
          "It seems there's an issue with your network connection. Please check your internet and try again.",
        );
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS': 
        return const FirebaseFailure(
          'The login credentials you provided are not valid. Please check and try again.',
        );
      case 'operation-not-allowed':
        return const FirebaseFailure(
          'This type of account is not enabled. Please contact support for further assistance.',
        );
      case 'weak-password':
        return const FirebaseFailure(
          'The password is too weak. Please choose a stronger password with at least 6 characters.',
        );
      case 'email-already-in-use':
        return const FirebaseFailure(
          'An account with this email already exists. Please log in or use a different email.',
        );
      case 'account-exists-with-different-credential':
        return const FirebaseFailure(
          'An account with this email already exists but is linked to a different sign-in method. Please sign in using that method.',
        );
      case 'requires-recent-login':
        return const FirebaseFailure(
          'This operation is sensitive and requires recent authentication. Please log in again to proceed.',
        );
      case 'invalid-action-code':
        return const FirebaseFailure(
          'The action code is invalid. This could be because it has expired or has already been used.',
        );
      case 'expired-action-code':
        return const FirebaseFailure(
          'The action code has expired. Please request a new one.',
        );
      default:
        return const FirebaseFailure(
          'Something went wrong. Please try again or contact support if the issue persists.',
        );
    }
  }
}