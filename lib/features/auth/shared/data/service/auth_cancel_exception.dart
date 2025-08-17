
class AuthCanceledException implements Exception {
  final String provider; // e.g. 'google' or 'facebook'
  const AuthCanceledException(this.provider);

  @override
  String toString() => 'AuthCanceledException(provider: $provider)';
}