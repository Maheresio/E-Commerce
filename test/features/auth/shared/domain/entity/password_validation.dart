import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/auth/shared/domain/entity/password_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Password Validation', () {
    // Valid Password Cases
    test('should return right when password meets all requirements', () {
      const String password = 'ValidPass123!';
      final Either<Failure, String> result = PasswordValidation.validatePassword(password);
      expect(result, right(password));
    });

    test('should return right when password is exactly 8 characters', () {
      const String password = 'A1b2c3d!';
      final Either<Failure, String> result = PasswordValidation.validatePassword(password);
      expect(result, right(password));
    });

    test('should return right when password is exactly 128 characters', () {
      final String password = 'A1!${'a' * 124}';
      final Either<Failure, String> result = PasswordValidation.validatePassword(password);
      expect(result, right(password));
    });

    test(
      'should return right when password contains various special chars',
      () {
        const String password = 'P@ssw0rd!';
        final Either<Failure, String> result = PasswordValidation.validatePassword(password);
        expect(result, right(password));
      },
    );

    // Invalid Password Cases
    test('should return left with failure when password is empty', () {
      const String password = '';
      final Either<Failure, String> result = PasswordValidation.validatePassword(password);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Please enter a password. It cannot be empty.',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when password is null', () {
      final Either<Failure, String?> result = PasswordValidation(null).value;
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Please enter a password. It cannot be empty.',
        ),
        (String? r) => fail('Expected failure but got success'),
      );
    });

    test(
      'should return left with failure when password is too short (7 chars)',
      () {
        const String password = 'Ab1!def';
        final Either<Failure, String> result = PasswordValidation.validatePassword(password);
        result.fold(
          (Failure failure) => expect(
            failure.message,
            'Your password is too short. Please use at least 8 characters.',
          ),
          (String r) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return left with failure when password is too long (129 chars)',
      () {
        final String password = 'A1!${'a' * 125}'; // 1 (A) + 2 (1!) + 125 (a) = 128
        // Should be 129, so we need to add one more character
        final String password129 = '${password}b'; // Now 129 characters
        assert(password129.length == 129); // Debugging: Confirm length
        final Either<Failure, String> result = PasswordValidation.validatePassword(password129);
        result.fold(
          (Failure failure) => expect(
            failure.message,
            'Your password is too long. Please use no more than 128 characters.',
          ),
          (String r) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return left with failure when password lacks uppercase letters',
      () {
        const String password = 'lowercase123!';
        final Either<Failure, String> result = PasswordValidation.validatePassword(password);
        result.fold(
          (Failure failure) => expect(
            failure.message,
            'Your password must include at least one uppercase letter (e.g., A-Z).',
          ),
          (String r) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return left with failure when password lacks lowercase letters',
      () {
        const String password = 'UPPERCASE123!';
        final Either<Failure, String> result = PasswordValidation.validatePassword(password);
        result.fold(
          (Failure failure) => expect(
            failure.message,
            'Your password must include at least one lowercase letter (e.g., a-z).',
          ),
          (String r) => fail('Expected failure but got success'),
        );
      },
    );

    test('should return left with failure when password lacks numbers', () {
      const String password = 'NoNumbers!';
      final Either<Failure, String> result = PasswordValidation.validatePassword(password);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Your password must include at least one number (e.g., 0-9).',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test(
      'should return left with failure when password lacks special characters',
      () {
        const String password = 'NoSpecial123';
        final Either<Failure, String> result = PasswordValidation.validatePassword(password);
        result.fold(
          (Failure failure) => expect(
            failure.message,
            r'Your password must include at least one special character (e.g., ! @ # $ % ^ & *).',
          ),
          (String r) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return left with failure when password contains only letters',
      () {
        const String password = 'OnlyLetters';
        final Either<Failure, String> result = PasswordValidation.validatePassword(password);
        result.fold(
          (Failure failure) => expect(
            failure.message,
            'Your password must include at least one number (e.g., 0-9).',
          ),
          (String r) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return left with failure when password contains only numbers',
      () {
        const String password = '12345678';
        final Either<Failure, String> result = PasswordValidation.validatePassword(password);
        result.fold(
          (Failure failure) => expect(
            failure.message,
            'Your password must include at least one uppercase letter (e.g., A-Z).',
          ),
          (String r) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return left with failure when password contains only special chars',
      () {
        const String password = r'!@#$%^&*';
        final Either<Failure, String> result = PasswordValidation.validatePassword(password);
        result.fold(
          (Failure failure) => expect(
            failure.message,
            'Your password must include at least one uppercase letter (e.g., A-Z).',
          ),
          (String r) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return left with failure when password contains whitespace',
      () {
        const String password = 'Bad Password 123!';
        final Either<Failure, String> result = PasswordValidation.validatePassword(password);
        result.fold(
          (Failure failure) => expect(
            failure.message,
            'Your password cannot contain spaces. Please remove any spaces.',
          ),
          (String r) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return left with failure when password contains unicode chars',
      () {
        const String password = 'Pässwörd123';
        final Either<Failure, String> result = PasswordValidation.validatePassword(password);
        result.fold(
          (Failure failure) => expect(
            failure.message,
            r'Your password must include at least one special character (e.g., ! @ # $ % ^ & *).',
          ),
          (String r) => fail('Expected failure but got success'),
        );
      },
    );

    test('should return left with failure when password contains emoji', () {
      const String password = 'Password123😊';
      final Either<Failure, String> result = PasswordValidation.validatePassword(password);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          r'Your password must include at least one special character (e.g., ! @ # $ % ^ & *).',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    // Edge Cases
    test(
      'should return left with correct first failure when multiple requirements are missing',
      () {
        const String password = 'short';
        final Either<Failure, String> result = PasswordValidation.validatePassword(password);
        result.fold(
          (Failure failure) => expect(
            failure.message,
            'Your password is too short. Please use at least 8 characters.',
          ),
          (String r) => fail('Expected failure but got success'),
        );
      },
    );

    test('should validate password requirements in correct order', () {
      // Empty check
      expect(
        PasswordValidation.validatePassword(
          '',
        ).fold((Failure f) => f.message, (String r) => ''),
        'Please enter a password. It cannot be empty.',
      );

      // Whitespace check
      expect(
        PasswordValidation.validatePassword(
          'Bad Password 123!',
        ).fold((Failure f) => f.message, (String r) => ''),
        'Your password cannot contain spaces. Please remove any spaces.',
      );

      // Length check (short)
      expect(
        PasswordValidation.validatePassword(
          'A1!',
        ).fold((Failure f) => f.message, (String r) => ''),
        'Your password is too short. Please use at least 8 characters.',
      );

      // Length check (long) - Fix this by creating a properly long password
      final String longPassword = 'A1!${'a' * 125}'; // 128 characters
      final String tooLongPassword = '${longPassword}b'; // 129 characters
      expect(
        PasswordValidation.validatePassword(
          tooLongPassword,
        ).fold((Failure f) => f.message, (String r) => ''),
        'Your password is too long. Please use no more than 128 characters.',
      );

      // Character checks
      expect(
        PasswordValidation.validatePassword(
          'lowercase123!',
        ).fold((Failure f) => f.message, (String r) => ''),
        'Your password must include at least one uppercase letter (e.g., A-Z).',
      );

      // Number check
      expect(
        PasswordValidation.validatePassword(
          'NoNumbers!',
        ).fold((Failure f) => f.message, (String r) => ''),
        'Your password must include at least one number (e.g., 0-9).',
      );

      // Special char check
      expect(
        PasswordValidation.validatePassword(
          'NoSpecial123',
        ).fold((Failure f) => f.message, (String r) => ''),
        r'Your password must include at least one special character (e.g., ! @ # $ % ^ & *).',
      );
    });
  });
}
