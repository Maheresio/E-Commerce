import 'failure.dart';

class FirestoreFailure extends Failure {
  const FirestoreFailure(super.message);

  factory FirestoreFailure.fromCode(String code) {
    switch (code) {
      case 'permission-denied':
        return const FirestoreFailure(
          'You do not have permission to access this resource. Please check your access rights or contact support.',
        );
      case 'not-found':
        return const FirestoreFailure(
          'The requested document does not exist. It may have been deleted or you may have entered an incorrect ID.',
        );
      case 'unavailable':
        return const FirestoreFailure(
          'The service is temporarily unavailable. Please try again later.',
        );
      case 'deadline-exceeded':
        return const FirestoreFailure(
          'The operation timed out. Please check your internet connection and try again.',
        );
      case 'aborted':
        return const FirestoreFailure(
          'The operation was aborted. This might be due to a conflict with another operation. Please try again.',
        );
      case 'already-exists':
        return const FirestoreFailure(
          'The document already exists. Please choose a different ID or update the existing document.',
        );
      case 'invalid-argument':
        return const FirestoreFailure(
          'Invalid input provided. Please check the data and try again.',
        );
      case 'failed-precondition':
        return const FirestoreFailure(
          'The operation cannot be performed in the current state. Please check the prerequisites and try again.',
        );
      case 'resource-exhausted':
        return const FirestoreFailure(
          'Resource limit exceeded. Please try again later or contact support to increase your limits.',
        );
      case 'unauthenticated':
        return const FirestoreFailure(
          'Authentication required. Please log in to perform this operation.',
        );
      case 'internal':
        return const FirestoreFailure(
          'An internal error occurred. Please try again or contact support if the issue persists.',
        );
      case 'data-loss':
        return const FirestoreFailure(
          'Data loss occurred. Please contact support immediately.',
        );
      case 'unknown':
        return const FirestoreFailure(
          'An unknown error occurred. Please try again or contact support.',
        );
      default:
        return const FirestoreFailure(
          'An unexpected Firestore error occurred. Please try again or contact support.',
        );
    }
  }
}