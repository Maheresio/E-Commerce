import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/value_objects/validation_value_object.dart';

class EmailValidation extends ValidationValueObject<String?> {
  factory EmailValidation(String? input) {
    return EmailValidation._(validateEmail(input ?? ''));
  }

  const EmailValidation._(super.value);

  static Either<Failure, String> validateEmail(String input) {
    input = input.trim();

    // Step 1: Validate email is not empty
    if (input.isEmpty) {
      return left(Failure('Please enter your email address'));
    }

    // Step 2: Split email into local part and domain
    final parts = input.split('@');
    if (parts.length != 2) {
      return left(
        Failure(
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
      );
    }

    final localPart = parts[0];

    // Step 3: Validate local part length (max 64 characters)
    if (localPart.length > 64) {
      return left(
        Failure(
          'The local part of the email (before @) is too long '
          '(maximum 64 characters). Please shorten it.',
        ),
      );
    }

    // Step 4: Validate total email length (max 254 characters)
    if (input.length > 254) {
      return left(
        Failure(
          'Email address is too long (max 254 characters). '
          'Please shorten it and try again',
        ),
      );
    }

    // Step 5: Validate email format using regex
    if (!_isValidFormat(input)) {
      return left(
        Failure(
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
      );
    }

    // Step 6: Return validated email in lowercase
    return right(input.toLowerCase());
  }

  // Helper method to validate email format
  static bool _isValidFormat(String input) {
    const emailRegex =
        r'^[a-zA-Z0-9]+([._%+-][a-zA-Z0-9]+)*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    return RegExp(emailRegex).hasMatch(input);
  }
}
