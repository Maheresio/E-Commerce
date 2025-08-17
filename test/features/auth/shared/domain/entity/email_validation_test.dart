import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/auth/shared/domain/entity/email_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Email Validation', () {
    // Valid Email Cases
    test(
      'should return right with trimmed and lowercased email when valid',
      () {
        const String email = 'Test@Example.com';
        final Either<Failure, String> result = EmailValidation.validateEmail(email);
        expect(result, right('test@example.com'));
      },
    );

    test('should return right when email has valid subdomain', () {
      const String email = 'test@sub.example.com';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      expect(result, right('test@sub.example.com'));
    });

    test(
      'should return right when email contains valid symbols and numbers',
      () {
        const String email = 'user.name123+test@domain.co.uk';
        final Either<Failure, String> result = EmailValidation.validateEmail(email);
        expect(result, right('user.name123+test@domain.co.uk'));
      },
    );

    test('should return right when email has leading/trailing spaces', () {
      const String email = '  test@example.com  ';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      expect(result, right('test@example.com'));
    });

    test('should return right and lowercase a valid uppercase email', () {
      const String email = 'USER@DOMAIN.COM';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      expect(result, right('user@domain.com'));
    });

    test('should return right for email with numbers only in local part', () {
      const String email = '12345@domain.com';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      expect(result, right('12345@domain.com'));
    });

    test('should return right for email with hyphen in domain', () {
      const String email = 'test@my-domain.com';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      expect(result, right('test@my-domain.com'));
    });

    test('should return right for email with underscore in local part', () {
      const String email = 'user_name@domain.com';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      expect(result, right('user_name@domain.com'));
    });

    test('should return right for email with percent sign in local part', () {
      const String email = 'user%name@domain.com';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      expect(result, right('user%name@domain.com'));
    });

    test('should return right for email with country-code TLD', () {
      const String email = 'test@domain.co.jp';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      expect(result, right('test@domain.co.jp'));
    });

    test('should return right for email with 64-character local part', () {
      final String email = '${'a' * 64}@domain.com';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      expect(result, right('${'a' * 64}@domain.com'));
    });

    test('should return right for email with 63-character domain part', () {
      final String email = 'test@${'a' * 63}.com';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      expect(result, right('test@${'a' * 63}.com'));
    });

    test('should return right for maximum length email (254 chars)', () {
      final String email =
          '${'a' * 64}@${'b' * 184}.com'; // 64 + 1 + 184 + 4 + 1 = 254
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      expect(result, right('${'a' * 64}@${'b' * 184}.com'));
    });

    // Invalid Email Cases
    test('should return left with failure when email is empty', () {
      const String email = '';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      result.fold(
        (Failure failure) => expect(failure.message, 'Please enter your email address'),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when email is null', () {
      final Either<Failure, String?> result = EmailValidation(null).value;
      result.fold(
        (Failure failure) => expect(failure.message, 'Please enter your email address'),
        (String? r) => fail('Expected failure but got success'),
      );
    });

  test('should return left with failure when email is too long', () {
  final String email = '${'a' * 64}@${'b' * 186}.com'; // 64 + 1 + 186 + 4 + 1 = 256
  final Either<Failure, String> result = EmailValidation.validateEmail(email);
  result.fold(
    (Failure failure) => expect(
      failure.message,
      'Email address is too long (max 254 characters). '
      'Please shorten it and try again',
    ),
    (String r) => fail('Expected failure but got success'),
  );
});

    test(
      'should return left with failure when local part exceeds 64 chars',
      () {
        final String email = '${'a' * 65}@domain.com';
        final Either<Failure, String> result = EmailValidation.validateEmail(email);
        result.fold(
          (Failure failure) => expect(
            failure.message,
            'The local part of the email (before @) is too long '
            '(maximum 64 characters). Please shorten it.',
          ),
          (String r) => fail('Expected failure but got success'),
        );
      },
    );

    test('should return left with failure when email has invalid format', () {
      const String email = 'invalid';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when email has consecutive dots', () {
      const String email = 'test..email@example.com';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when email starts with a dot', () {
      const String email = '.test@example.com';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when email ends with a dot', () {
      const String email = 'test.@example.com';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when email has spaces', () {
      const String email = 'test @example.com';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test(
      'should return left with failure when email has invalid special characters',
      () {
        const String email = 'us*er@domain.com';
        final Either<Failure, String> result = EmailValidation.validateEmail(email);
        result.fold(
          (Failure failure) => expect(
            failure.message,
            'Invalid email format. Please make sure:\n'
            '• It follows example@domain.com format\n'
            '• No spaces are present\n'
            '• Special characters (.+_%-) are used correctly',
          ),
          (String r) => fail('Expected failure but got success'),
        );
      },
    );

    test('should return left with failure when domain is missing', () {
      const String email = 'test@';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when local part is missing', () {
      const String email = '@example.com';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test(
      'should return left with failure when email has multiple @ symbols',
      () {
        const String email = 'user@@example.com';
        final Either<Failure, String> result = EmailValidation.validateEmail(email);
        result.fold(
          (Failure failure) => expect(
            failure.message,
            'Invalid email format. Please make sure:\n'
            '• It follows example@domain.com format\n'
            '• No spaces are present\n'
            '• Special characters (.+_%-) are used correctly',
          ),
          (String r) => fail('Expected failure but got success'),
        );
      },
    );

    test('should return left with failure when TLD is missing', () {
      const String email = 'test@example';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test(
      'should return left with failure when email contains control characters',
      () {
        const String email = 'test\u0000@example.com';
        final Either<Failure, String> result = EmailValidation.validateEmail(email);
        result.fold(
          (Failure failure) => expect(
            failure.message,
            'Invalid email format. Please make sure:\n'
            '• It follows example@domain.com format\n'
            '• No spaces are present\n'
            '• Special characters (.+_%-) are used correctly',
          ),
          (String r) => fail('Expected failure but got success'),
        );
      },
    );

    test('should return left with failure when email contains emoji', () {
      const String email = 'test😊@example.com';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });

    test('should return left with failure when email contains only domain', () {
      const String email = 'example.com';
      final Either<Failure, String> result = EmailValidation.validateEmail(email);
      result.fold(
        (Failure failure) => expect(
          failure.message,
          'Invalid email format. Please make sure:\n'
          '• It follows example@domain.com format\n'
          '• No spaces are present\n'
          '• Special characters (.+_%-) are used correctly',
        ),
        (String r) => fail('Expected failure but got success'),
      );
    });
  });
}
