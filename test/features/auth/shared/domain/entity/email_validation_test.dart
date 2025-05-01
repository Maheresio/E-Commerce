import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/auth/shared/domain/entity/email_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Email Validation', () {
    // Valid Email Cases
    test(
      'should return right with trimmed and lowercased email when valid',
      () {
        const email = 'Test@Example.com';
        final result = EmailValidation.validateEmail(email);
        expect(result, right('test@example.com'));
      },
    );

    test('should return right when email has valid subdomain', () {
      const email = 'test@sub.example.com';
      final result = EmailValidation.validateEmail(email);
      expect(result, right('test@sub.example.com'));
    });

    test(
      'should return right when email contains valid symbols and numbers',
      () {
        const email = 'user.name123+test@domain.co.uk';
        final result = EmailValidation.validateEmail(email);
        expect(result, right('user.name123+test@domain.co.uk'));
      },
    );

    test('should return right when email has leading/trailing spaces', () {
      const email = '  test@example.com  ';
      final result = EmailValidation.validateEmail(email);
      expect(result, right('test@example.com'));
    });

    test('should return right and lowercase a valid uppercase email', () {
      const email = 'USER@DOMAIN.COM';
      final result = EmailValidation.validateEmail(email);
      expect(result, right('user@domain.com'));
    });

    test('should return right for email with numbers only in local part', () {
      const email = '12345@domain.com';
      final result = EmailValidation.validateEmail(email);
      expect(result, right('12345@domain.com'));
    });

    test('should return right for email with hyphen in domain', () {
      const email = 'test@my-domain.com';
      final result = EmailValidation.validateEmail(email);
      expect(result, right('test@my-domain.com'));
    });

    test('should return right for email with underscore in local part', () {
      const email = 'user_name@domain.com';
      final result = EmailValidation.validateEmail(email);
      expect(result, right('user_name@domain.com'));
    });

    test('should return right for email with percent sign in local part', () {
      const email = 'user%name@domain.com';
      final result = EmailValidation.validateEmail(email);
      expect(result, right('user%name@domain.com'));
    });

    test('should return right for email with country-code TLD', () {
      const email = 'test@domain.co.jp';
      final result = EmailValidation.validateEmail(email);
      expect(result, right('test@domain.co.jp'));
    });

    test('should return right for email with 64-character local part', () {
      final email = '${'a' * 64}@domain.com';
      final result = EmailValidation.validateEmail(email);
      expect(result, right('${'a' * 64}@domain.com'));
    });

    test('should return right for email with 63-character domain part', () {
      final email = 'test@${'a' * 63}.com';
      final result = EmailValidation.validateEmail(email);
      expect(result, right('test@${'a' * 63}.com'));
    });

    test('should return right for maximum length email (254 chars)', () {
      final email =
          '${'a' * 64}@${'b' * 184}.com'; // 64 + 1 + 184 + 4 + 1 = 254
      final result = EmailValidation.validateEmail(email);
      expect(result, right('${'a' * 64}@${'b' * 184}.com'));
    });

    // Invalid Email Cases
    test('should return left with failure when email is empty', () {
      const email = '';
      final result = EmailValidation.validateEmail(email);
      result.fold(
        (failure) => expect(failure.message, 'Please enter your email address'),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when email is null', () {
      final result = EmailValidation(null).value;
      result.fold(
        (failure) => expect(failure.message, 'Please enter your email address'),
        (r) => fail('Expected failure but got success'),
      );
    });

  test('should return left with failure when email is too long', () {
  final email = '${'a' * 64}@${'b' * 186}.com'; // 64 + 1 + 186 + 4 + 1 = 256
  final result = EmailValidation.validateEmail(email);
  result.fold(
    (failure) => expect(
      failure.message,
      'Email address is too long (max 254 characters). '
      'Please shorten it and try again',
    ),
    (r) => fail('Expected failure but got success'),
  );
});

    test(
      'should return left with failure when local part exceeds 64 chars',
      () {
        final email = '${'a' * 65}@domain.com';
        final result = EmailValidation.validateEmail(email);
        result.fold(
          (failure) => expect(
            failure.message,
            'The local part of the email (before @) is too long '
            '(maximum 64 characters). Please shorten it.',
          ),
          (r) => fail('Expected failure but got success'),
        );
      },
    );

    test('should return left with failure when email has invalid format', () {
      const email = 'invalid';
      final result = EmailValidation.validateEmail(email);
      result.fold(
        (failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when email has consecutive dots', () {
      const email = 'test..email@example.com';
      final result = EmailValidation.validateEmail(email);
      result.fold(
        (failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when email starts with a dot', () {
      const email = '.test@example.com';
      final result = EmailValidation.validateEmail(email);
      result.fold(
        (failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when email ends with a dot', () {
      const email = 'test.@example.com';
      final result = EmailValidation.validateEmail(email);
      result.fold(
        (failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when email has spaces', () {
      const email = 'test @example.com';
      final result = EmailValidation.validateEmail(email);
      result.fold(
        (failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test(
      'should return left with failure when email has invalid special characters',
      () {
        const email = 'us*er@domain.com';
        final result = EmailValidation.validateEmail(email);
        result.fold(
          (failure) => expect(
            failure.message,
            'Invalid email format. Please make sure:\n'
            '• It follows example@domain.com format\n'
            '• No spaces are present\n'
            '• Special characters (.+_%-) are used correctly',
          ),
          (r) => fail('Expected failure but got success'),
        );
      },
    );

    test('should return left with failure when domain is missing', () {
      const email = 'test@';
      final result = EmailValidation.validateEmail(email);
      result.fold(
        (failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when local part is missing', () {
      const email = '@example.com';
      final result = EmailValidation.validateEmail(email);
      result.fold(
        (failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test(
      'should return left with failure when email has multiple @ symbols',
      () {
        const email = 'user@@example.com';
        final result = EmailValidation.validateEmail(email);
        result.fold(
          (failure) => expect(
            failure.message,
            'Invalid email format. Please make sure:\n'
            '• It follows example@domain.com format\n'
            '• No spaces are present\n'
            '• Special characters (.+_%-) are used correctly',
          ),
          (r) => fail('Expected failure but got success'),
        );
      },
    );

    test('should return left with failure when TLD is missing', () {
      const email = 'test@example';
      final result = EmailValidation.validateEmail(email);
      result.fold(
        (failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test(
      'should return left with failure when email contains control characters',
      () {
        const email = 'test\u0000@example.com';
        final result = EmailValidation.validateEmail(email);
        result.fold(
          (failure) => expect(
            failure.message,
            'Invalid email format. Please make sure:\n'
            '• It follows example@domain.com format\n'
            '• No spaces are present\n'
            '• Special characters (.+_%-) are used correctly',
          ),
          (r) => fail('Expected failure but got success'),
        );
      },
    );

    test('should return left with failure when email contains emoji', () {
      const email = 'test😊@example.com';
      final result = EmailValidation.validateEmail(email);
      result.fold(
        (failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when email contains only domain', () {
      const email = 'example.com';
      final result = EmailValidation.validateEmail(email);
      result.fold(
        (failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (r) => fail('Expected failure but got success'),
      );
    });
  });
}
