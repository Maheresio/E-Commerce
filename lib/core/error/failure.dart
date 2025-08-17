import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  String toString() => message;

  @override
  List<Object?> get props => <Object?>[message];
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
  
  factory ValidationFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const ValidationFailure('Please enter a valid email address.');
      case 'invalid-password':
        return const ValidationFailure('Password must be at least 8 characters long.');
      case 'invalid-phone':
        return const ValidationFailure('Please enter a valid phone number.');
      case 'required-field':
        return const ValidationFailure('This field is required.');
      case 'invalid-credit-card':
        return const ValidationFailure('Please enter a valid credit card number.');
      case 'invalid-expiry-date':
        return const ValidationFailure('Please enter a valid expiry date.');
      case 'invalid-cvv':
        return const ValidationFailure('Please enter a valid CVV.');
      case 'invalid-postal-code':
        return const ValidationFailure('Please enter a valid postal code.');
      case 'password-mismatch':
        return const ValidationFailure('Passwords do not match.');
      case 'weak-password':
        return const ValidationFailure('Password is too weak. Please use a stronger password.');
      default:
        return const ValidationFailure('Please check your input and try again.');
    }
  }
}