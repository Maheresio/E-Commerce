import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/auth/shared/domain/entity/name_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Name Validation', () {
    // Valid Name Cases
    test('should return right with trimmed name when valid', () {
      const name = '  John Doe  ';
      final result = NameValidation.validateName(name);
      expect(result, right('John Doe'));
    });

    test('should return right for name with apostrophe', () {
      const name = "O'Connor";
      final result = NameValidation.validateName(name);
      expect(result, right("O'Connor"));
    });

    test('should return right for name with hyphen', () {
      const name = "Jean-Luc";
      final result = NameValidation.validateName(name);
      expect(result, right("Jean-Luc"));
    });

    test('should return right for name with comma', () {
      const name = "Doe, John";
      final result = NameValidation.validateName(name);
      expect(result, right("Doe, John"));
    });

    test('should return right for name with period', () {
      const name = "John P. Doe";
      final result = NameValidation.validateName(name);
      expect(result, right("John P. Doe"));
    });

    test('should return right for name with accented characters', () {
      const name = "José María García";
      final result = NameValidation.validateName(name);
      expect(result, right("José María García"));
    });

    test('should return right for maximum length name (50 chars)', () {
      final name = 'A' * 50;
      final result = NameValidation.validateName(name);
      expect(result, right('A' * 50));
    });

    // Invalid Name Cases
    test('should return left with failure when name is empty', () {
      const name = '';
      final result = NameValidation.validateName(name);
      result.fold(
        (failure) => expect(failure.message, 'Please enter your name. It cannot be empty.'),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name is null', () {
      final result = NameValidation(null).value;
      result.fold(
        (failure) => expect(failure.message, 'Please enter your name. It cannot be empty.'),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name exceeds 50 characters', () {
      final name = 'A' * 51;
      final result = NameValidation.validateName(name);
      result.fold(
        (failure) => expect(
          failure.message,
          'Your name is too long. Please keep it under 50 characters.',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains numbers', () {
      const name = "John Doe 123";
      final result = NameValidation.validateName(name);
      result.fold(
        (failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains special characters', () {
      const name = "John@Doe";
      final result = NameValidation.validateName(name);
      result.fold(
        (failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains emoji', () {
      const name = "John 😊 Doe";
      final result = NameValidation.validateName(name);
      result.fold(
        (failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains underscores', () {
      const name = "John_Doe";
      final result = NameValidation.validateName(name);
      result.fold(
        (failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains asterisk', () {
      const name = "John*Doe";
      final result = NameValidation.validateName(name);
      result.fold(
        (failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains slashes', () {
      const name = "John/Doe";
      final result = NameValidation.validateName(name);
      result.fold(
        (failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains backslash', () {
      const name = r"John\Doe";
      final result = NameValidation.validateName(name);
      result.fold(
        (failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains quotes', () {
      const name = '"John Doe"';
      final result = NameValidation.validateName(name);
      result.fold(
        (failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains parentheses', () {
      const name = "John (Doe)";
      final result = NameValidation.validateName(name);
      result.fold(
        (failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains brackets', () {
      const name = "John [Doe]";
      final result = NameValidation.validateName(name);
      result.fold(
        (failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains equals sign', () {
      const name = "John=Doe";
      final result = NameValidation.validateName(name);
      result.fold(
        (failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains plus sign', () {
      const name = "John+Doe";
      final result = NameValidation.validateName(name);
      result.fold(
        (failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when name contains percent sign', () {
      const name = "John%Doe";
      final result = NameValidation.validateName(name);
      result.fold(
        (failure) => expect(
          failure.message,
          'Names can only contain letters, spaces, commas, periods, apostrophes, and hyphens. '
          'Special characters or numbers are not allowed.',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });
  });
}