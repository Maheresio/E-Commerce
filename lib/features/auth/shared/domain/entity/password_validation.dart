import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/value_objects/validation_value_object.dart';

class PasswordValidation extends ValidationValueObject<String?> {
  factory PasswordValidation(String? input) =>
      PasswordValidation._(validatePassword(input ?? ''));

  const PasswordValidation._(super.value);

  static Either<Failure, String> validatePassword(String input) {
    // Helper function to validate regex patterns
    Either<Failure, void> validatePattern(RegExp pattern, String errorMessage) {
      if (!pattern.hasMatch(input)) {
        return left(Failure(errorMessage));
      }
      return right(null);
    }

    // 1. Check if password is empty
    if (input.isEmpty) {
      return left(Failure('Please enter a password. It cannot be empty.'));
    }

    // 2. Check for whitespace
    if (RegExp(r'\s').hasMatch(input)) {
      return left(
        Failure(
          'Your password cannot contain spaces. Please remove any spaces.',
        ),
      );
    }

    // 3. Check minimum length (8 characters)
    if (input.length < 8) {
      return left(
        Failure(
          'Your password is too short. Please use at least 8 characters.',
        ),
      );
    }

    // 4. Check maximum length (128 characters)
    if (input.length > 128) {
      return left(
        Failure(
          'Your password is too long. Please use no more than 128 characters.',
        ),
      );
    }

    // 5. Validate character requirements using helper function
    final validations = [
      validatePattern(
        RegExp(r'[A-Z]'),
        'Your password must include at least one uppercase letter (e.g., A-Z).',
      ),
      validatePattern(
        RegExp(r'[a-z]'),
        'Your password must include at least one lowercase letter (e.g., a-z).',
      ),
      validatePattern(
        RegExp(r'\d'),
        'Your password must include at least one number (e.g., 0-9).',
      ),
      validatePattern(
        RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
        'Your password must include at least one special character (e.g., ! @ # \$ % ^ & *).',
      ),
    ];

    // Return the first failure encountered
    for (final validation in validations) {
      if (validation.isLeft()) {
        return validation.fold((failure) => left(failure), (_) => right(''));
      }
    }

    // If all checks pass, return success
    return right(input);
  }
}
