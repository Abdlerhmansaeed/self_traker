import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:self_traker/features/auth/domain/entities/validation_failure.dart';
import 'package:self_traker/features/auth/domain/validators/email_validator.dart';

void main() {
  late EmailValidator validator;

  setUp(() {
    validator = EmailValidator();
  });

  group('EmailValidator', () {
    group('valid emails', () {
      test('should return Right for valid standard email', () {
        // Arrange
        const email = 'test@example.com';

        // Act
        final result = validator.validate(email);

        // Assert
        expect(result, const Right('test@example.com'));
      });

      test('should return Right for email with subdomain', () {
        const email = 'user@mail.example.com';
        final result = validator.validate(email);
        expect(result, const Right('user@mail.example.com'));
      });

      test('should return Right for email with special characters', () {
        const email = 'user.name+tag@example.com';
        final result = validator.validate(email);
        expect(result, const Right('user.name+tag@example.com'));
      });

      test('should trim whitespace and return valid email', () {
        const email = '  test@example.com  ';
        final result = validator.validate(email);
        expect(result, const Right('test@example.com'));
      });

      test('should return Right for email at maximum length (320 chars)', () {
        // Create a 320-character valid email
        final localPart = 'a' * 64; // max local part length
        final domainLabel = 'b' * 63; // max domain label
        final email =
            '$localPart@$domainLabel.$domainLabel.$domainLabel.com'; // ~320 chars

        final result = validator.validate(email);
        expect(result.isRight(), true);
      });
    });

    group('empty or null emails', () {
      test('should return Left(EmailEmptyFailure) for null email', () {
        final result = validator.validate(null);
        expect(result, const Left(EmailEmptyFailure()));
      });

      test('should return Left(EmailEmptyFailure) for empty string', () {
        final result = validator.validate('');
        expect(result, const Left(EmailEmptyFailure()));
      });

      test(
        'should return Left(EmailInvalidFormatFailure) for whitespace only',
        () {
          final result = validator.validate('   ');
          expect(result, const Left(EmailInvalidFormatFailure()));
        },
      );
    });

    group('invalid email formats', () {
      test(
        'should return Left(EmailInvalidFormatFailure) for email without @',
        () {
          const email = 'invalidemail.com';
          final result = validator.validate(email);
          expect(result, const Left(EmailInvalidFormatFailure()));
        },
      );

      test(
        'should return Left(EmailInvalidFormatFailure) for email without domain',
        () {
          const email = 'user@';
          final result = validator.validate(email);
          expect(result, const Left(EmailInvalidFormatFailure()));
        },
      );

      test(
        'should return Left(EmailInvalidFormatFailure) for email without local part',
        () {
          const email = '@example.com';
          final result = validator.validate(email);
          expect(result, const Left(EmailInvalidFormatFailure()));
        },
      );

      test(
        'should return Left(EmailInvalidFormatFailure) for email with spaces',
        () {
          const email = 'user name@example.com';
          final result = validator.validate(email);
          expect(result, const Left(EmailInvalidFormatFailure()));
        },
      );

      test('should return Left(EmailInvalidFormatFailure) for multiple @', () {
        const email = 'user@@example.com';
        final result = validator.validate(email);
        expect(result, const Left(EmailInvalidFormatFailure()));
      });
    });

    group('email length validation', () {
      test(
        'should return Left(EmailTooLongFailure) for email exceeding 320 chars',
        () {
          // Create a 321-character email
          final email = '${'a' * 310}@example.com';

          final result = validator.validate(email);
          expect(
            result,
            Left(EmailTooLongFailure(EmailValidator.maxEmailLength)),
          );
        },
      );
    });
  });
}
