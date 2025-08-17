import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/auth/shared/domain/entity/name_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Name Validation', () {
    // Valid Name Cases
    test('should return right with trimmed name when valid', () {
      const String name = '  John Doe  ';
      final Either<Failure, String> result = NameValidation.validateName(name);
      expect(result, right('John Doe'));
    });

    test('should return right for name with apostrophe', () {
      const String name = "O'Connor";
      final Either<Failure, String> result = NameValidation.validateName(name);
      expect(result, right("O'Connor"));
    });

    test('should return right for name with hyphen', () {
      const String name = 'Jean-Luc';
      final Either<Failure, String> result = NameValidation.validateName(name);
      expect(result, right('Jean-Luc'));
    });

    test('should return right for name with comma', () {
      const String name = 'Doe, John';
      final Either<Failure, String> result = NameValidation.validateName(name);
      expect(result, right('Doe, John'));
    });

    test('should return right for name with period', () {
      const String name = 'John P. Doe';
      final Either<Failure, String> result = NameValidation.validateName(name);
      expect(result, right('John P. Doe'));
    });

    test('should return right for name with accented characters', () {
      const String name = 'José María García';
      final Either<Failure, String> result = NameValidation.validateName(name);
      expect(result, right('José María García'));
    });

    test('should return right for maximum length name (50 chars)', () {
      final String name = 'A' * 50;
      final Either<Failure, String> result = NameValidation.validateName(name);
      expect(result, right('A' * 50));
    });

    // Invalid Name Cases
    test('should return left with failure when name is empty', () {
      const String name = '';
      final Either<Failure, String> result = NameValidation.validateName(name);
      result.fold(
        (Failure failure) => expect(failure.message, 'Please enter your name. It cannot be empty.'),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name is null', () {
      final Either<Failure, String?> result = NameValidation(null).value;
      result.fold(
        (Failure failure) => expect(failure.message, 'Please enter your name. It cannot be empty.'),
        (String? r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name exceeds 50 characters', () {
      final String name = 'A' * 51;
      final Either<Failure, String> result = NameValidation.validateName(name);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Your name is too long. Please keep it under 50 characters.',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains numbers', () {
      const String name = 'John Doe 123';
      final Either<Failure, String> result = NameValidation.validateName(name);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains special characters', () {
      const String name = 'John@Doe';
      final Either<Failure, String> result = NameValidation.validateName(name);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains emoji', () {
      const String name = 'John 😊 Doe';
      final Either<Failure, String> result = NameValidation.validateName(name);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains underscores', () {
      const String name = 'John_Doe';
      final Either<Failure, String> result = NameValidation.validateName(name);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains asterisk', () {
      const String name = 'John*Doe';
      final Either<Failure, String> result = NameValidation.validateName(name);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains slashes', () {
      const String name = 'John/Doe';
      final Either<Failure, String> result = NameValidation.validateName(name);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains backslash', () {
      const String name = r'John\Doe';
      final Either<Failure, String> result = NameValidation.validateName(name);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains quotes', () {
      const String name = '"John Doe"';
      final Either<Failure, String> result = NameValidation.validateName(name);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains parentheses', () {
      const String name = 'John (Doe)';
      final Either<Failure, String> result = NameValidation.validateName(name);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains brackets', () {
      const String name = 'John [Doe]';
      final Either<Failure, String> result = NameValidation.validateName(name);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains equals sign', () {
      const String name = 'John=Doe';
      final Either<Failure, String> result = NameValidation.validateName(name);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains plus sign', () {
      const String name = 'John+Doe';
      final Either<Failure, String> result = NameValidation.validateName(name);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains percent sign', () {
      const String name = 'John%Doe';
      final Either<Failure, String> result = NameValidation.validateName(name);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });
  });
}