import 'failure.dart';

class CacheFailure extends Failure {
  const CacheFailure(super.message);

  factory CacheFailure.fromCode(String code) {
    switch (code) {
      case 'cache-write-failed':
        return const CacheFailure(
          'Failed to save data locally. Please try again.',
        );
      case 'cache-read-failed':
        return const CacheFailure(
          'Failed to retrieve cached data. Please refresh and try again.',
        );
      case 'cache-corrupted':
        return const CacheFailure(
          'Local data is corrupted. The app will refresh automatically.',
        );
      case 'cache-full':
        return const CacheFailure(
          'Local storage is full. Please clear some space and try again.',
        );
      case 'cache-expired':
        return const CacheFailure(
          'Cached data has expired. Refreshing automatically.',
        );
      case 'cache-permission-denied':
        return const CacheFailure('Permission denied to access local storage.');
      case 'cache-not-available':
        return const CacheFailure(
          'Local caching is not available on this device.',
        );
      default:
        return const CacheFailure('An error occurred with local data storage.');
    }
  }
}
