import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/auth/shared/domain/entity/password_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Password Validation', () {
    // Valid Password Cases
    test('should return right when password meets all requirements', () {
      const password = 'ValidPass123!';
      final result = PasswordValidation.validatePassword(password);
      expect(result, right(password));
    });

    test('should return right when password is exactly 8 characters', () {
      const password = 'A1b2c3d!';
      final result = PasswordValidation.validatePassword(password);
      expect(result, right(password));
    });

    test('should return right when password is exactly 128 characters', () {
      final password = 'A1!${'a' * 124}';
      final result = PasswordValidation.validatePassword(password);
      expect(result, right(password));
    });

    test(
      'should return right when password contains various special chars',
      () {
        const password = 'P@ssw0rd!';
        final result = PasswordValidation.validatePassword(password);
        expect(result, right(password));
      },
    );

    // Invalid Password Cases
    test('should return left with failure when password is empty', () {
      const password = '';
      final result = PasswordValidation.validatePassword(password);
      result.fold(
        (failure) => expect(
          failure.message,
          'Please enter a password. It cannot be empty.',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when password is null', () {
      final result = PasswordValidation(null).value;
      result.fold(
        (failure) => expect(
          failure.message,
          'Please enter a password. It cannot be empty.',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test(
      'should return left with failure when password is too short (7 chars)',
      () {
        const password = 'Ab1!def';
        final result = PasswordValidation.validatePassword(password);
        result.fold(
          (failure) => expect(
            failure.message,
            'Your password is too short. Please use at least 8 characters.',
          ),
          (r) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return left with failure when password is too long (129 chars)',
      () {
        final password = 'A1!${'a' * 125}'; // 1 (A) + 2 (1!) + 125 (a) = 128
        // Should be 129, so we need to add one more character
        final password129 = '${password}b'; // Now 129 characters
        assert(password129.length == 129); // Debugging: Confirm length
        final result = PasswordValidation.validatePassword(password129);
        result.fold(
          (failure) => expect(
            failure.message,
            'Your password is too long. Please use no more than 128 characters.',
          ),
          (r) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return left with failure when password lacks uppercase letters',
      () {
        const password = 'lowercase123!';
        final result = PasswordValidation.validatePassword(password);
        result.fold(
          (failure) => expect(
            failure.message,
            'Your password must include at least one uppercase letter (e.g., A-Z).',
          ),
          (r) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return left with failure when password lacks lowercase letters',
      () {
        const password = 'UPPERCASE123!';
        final result = PasswordValidation.validatePassword(password);
        result.fold(
          (failure) => expect(
            failure.message,
            'Your password must include at least one lowercase letter (e.g., a-z).',
          ),
          (r) => fail('Expected failure but got success'),
        );
      },
    );

    test('should return left with failure when password lacks numbers', () {
      const password = 'NoNumbers!';
      final result = PasswordValidation.validatePassword(password);
      result.fold(
        (failure) => expect(
          failure.message,
          'Your password must include at least one number (e.g., 0-9).',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test(
      'should return left with failure when password lacks special characters',
      () {
        const password = 'NoSpecial123';
        final result = PasswordValidation.validatePassword(password);
        result.fold(
          (failure) => expect(
            failure.message,
            'Your password must include at least one special character (e.g., ! @ # \$ % ^ & *).',
          ),
          (r) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return left with failure when password contains only letters',
      () {
        const password = 'OnlyLetters';
        final result = PasswordValidation.validatePassword(password);
        result.fold(
          (failure) => expect(
            failure.message,
            'Your password must include at least one number (e.g., 0-9).',
          ),
          (r) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return left with failure when password contains only numbers',
      () {
        const password = '12345678';
        final result = PasswordValidation.validatePassword(password);
        result.fold(
          (failure) => expect(
            failure.message,
            'Your password must include at least one uppercase letter (e.g., A-Z).',
          ),
          (r) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return left with failure when password contains only special chars',
      () {
        const password = '!@#\$%^&*';
        final result = PasswordValidation.validatePassword(password);
        result.fold(
          (failure) => expect(
            failure.message,
            'Your password must include at least one uppercase letter (e.g., A-Z).',
          ),
          (r) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return left with failure when password contains whitespace',
      () {
        const password = 'Bad Password 123!';
        final result = PasswordValidation.validatePassword(password);
        result.fold(
          (failure) => expect(
            failure.message,
            'Your password cannot contain spaces. Please remove any spaces.',
          ),
          (r) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return left with failure when password contains unicode chars',
      () {
        const password = 'Pässwörd123';
        final result = PasswordValidation.validatePassword(password);
        result.fold(
          (failure) => expect(
            failure.message,
            'Your password must include at least one special character (e.g., ! @ # \$ % ^ & *).',
          ),
          (r) => fail('Expected failure but got success'),
        );
      },
    );

    test('should return left with failure when password contains emoji', () {
      const password = 'Password123😊';
      final result = PasswordValidation.validatePassword(password);
      result.fold(
        (failure) => expect(
          failure.message,
          'Your password must include at least one special character (e.g., ! @ # \$ % ^ & *).',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    // Edge Cases
    test(
      'should return left with correct first failure when multiple requirements are missing',
      () {
        const password = 'short';
        final result = PasswordValidation.validatePassword(password);
        result.fold(
          (failure) => expect(
            failure.message,
            'Your password is too short. Please use at least 8 characters.',
          ),
          (r) => fail('Expected failure but got success'),
        );
      },
    );

    test('should validate password requirements in correct order', () {
      // Empty check
      expect(
        PasswordValidation.validatePassword(
          '',
        ).fold((f) => f.message, (r) => ''),
        'Please enter a password. It cannot be empty.',
      );

      // Whitespace check
      expect(
        PasswordValidation.validatePassword(
          'Bad Password 123!',
        ).fold((f) => f.message, (r) => ''),
        'Your password cannot contain spaces. Please remove any spaces.',
      );

      // Length check (short)
      expect(
        PasswordValidation.validatePassword(
          'A1!',
        ).fold((f) => f.message, (r) => ''),
        'Your password is too short. Please use at least 8 characters.',
      );

      // Length check (long) - Fix this by creating a properly long password
      final longPassword = 'A1!${'a' * 125}'; // 128 characters
      final tooLongPassword = '${longPassword}b'; // 129 characters
      expect(
        PasswordValidation.validatePassword(
          tooLongPassword,
        ).fold((f) => f.message, (r) => ''),
        'Your password is too long. Please use no more than 128 characters.',
      );

      // Character checks
      expect(
        PasswordValidation.validatePassword(
          'lowercase123!',
        ).fold((f) => f.message, (r) => ''),
        'Your password must include at least one uppercase letter (e.g., A-Z).',
      );

      // Number check
      expect(
        PasswordValidation.validatePassword(
          'NoNumbers!',
        ).fold((f) => f.message, (r) => ''),
        'Your password must include at least one number (e.g., 0-9).',
      );

      // Special char check
      expect(
        PasswordValidation.validatePassword(
          'NoSpecial123',
        ).fold((f) => f.message, (r) => ''),
        'Your password must include at least one special character (e.g., ! @ # \$ % ^ & *).',
      );
    });
  });
}
