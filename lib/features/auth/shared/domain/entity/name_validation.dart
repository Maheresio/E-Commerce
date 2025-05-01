import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/value_objects/validation_value_object.dart';

class NameValidation extends ValidationValueObject<String?> {
  factory NameValidation(String? input) {
    return NameValidation._(validateName(input ?? ''));
  }

  const NameValidation._(super.value);

  static Either<Failure, String> validateName(String input) {
    // Support Latin letters, accented characters, spaces, and specific punctuation
    const nameRegex = r"^[a-zA-ZÀ-ÿ ,.'-]+$";

    if (input.isEmpty) {
      return left(Failure('Please enter your name. It cannot be empty.'));
    }

    if (input.length > 50) {
      return left(Failure(
        'Your name is too long. Please keep it under 50 characters.',
      ));
    }

    if (!RegExp(nameRegex).hasMatch(input)) {
      return left(Failure(
        'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
        'Special characters or numbers are not allowed.',
      ));
    }

    return right(input.trim());
  }
}