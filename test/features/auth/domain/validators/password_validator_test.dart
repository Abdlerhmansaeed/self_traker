import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:self_traker/features/auth/domain/entities/validation_failure.dart';
import 'package:self_traker/features/auth/domain/validators/password_validator.dart';

void main() {
  late PasswordValidator validator;

  setUp(() {
    validator = PasswordValidator();
  });

  group('PasswordValidator', () {
    group('valid passwords', () {
      test('should return Right for password meeting all requirements', () {
        // Arrange - 8+ chars, uppercase, lowercase, number
        const password = 'Password123';

        // Act
        final result = validator.validate(password);

        // Assert
        expect(result, const Right('Password123'));
      });

      test('should return Right for password with special characters', () {
        const password = 'Pass@word123!';
        final result = validator.validate(password);
        expect(result, const Right('Pass@word123!'));
      });

      test('should return Right for longer password', () {
        const password = 'ThisIsAVeryLongPassword123WithManyCharacters';
        final result = validator.validate(password);
        expect(
          result,
          const Right('ThisIsAVeryLongPassword123WithManyCharacters'),
        );
      });

      test('should return Right for password with multiple numbers', () {
        const password = 'Password123456789';
        final result = validator.validate(password);
        expect(result, const Right('Password123456789'));
      });

      test(
        'should return Right for password with multiple uppercase letters',
        () {
          const password = 'PASSword123';
          final result = validator.validate(password);
          expect(result, const Right('PASSword123'));
        },
      );
    });

    group('empty or null passwords', () {
      test('should return Left(PasswordEmptyFailure) for null password', () {
        final result = validator.validate(null);
        expect(result, const Left(PasswordEmptyFailure()));
      });

      test('should return Left(PasswordEmptyFailure) for empty string', () {
        final result = validator.validate('');
        expect(result, const Left(PasswordEmptyFailure()));
      });
    });

    group('password length validation', () {
      test(
        'should return Left(PasswordTooShortFailure) for password with 7 chars',
        () {
          const password = 'Pass12A'; // 7 chars but meets other requirements
          final result = validator.validate(password);
          expect(
            result,
            Left(PasswordTooShortFailure(PasswordValidator.minPasswordLength)),
          );
        },
      );

      test(
        'should return Left(PasswordTooShortFailure) for single character',
        () {
          const password = 'A';
          final result = validator.validate(password);
          expect(
            result,
            Left(PasswordTooShortFailure(PasswordValidator.minPasswordLength)),
          );
        },
      );

      test('should return Right for password with exactly 8 characters', () {
        const password = 'Pass123A';
        final result = validator.validate(password);
        expect(result, const Right('Pass123A'));
      });
    });

    group('missing uppercase letter', () {
      test(
        'should return Left(PasswordMissingUppercaseFailure) when no uppercase',
        () {
          const password = 'password123';
          final result = validator.validate(password);
          expect(result, const Left(PasswordMissingUppercaseFailure()));
        },
      );

      test(
        'should return Left(PasswordMissingUppercaseFailure) for all lowercase with numbers',
        () {
          const password = 'abcdefgh123';
          final result = validator.validate(password);
          expect(result, const Left(PasswordMissingUppercaseFailure()));
        },
      );
    });

    group('missing lowercase letter', () {
      test(
        'should return Left(PasswordMissingLowercaseFailure) when no lowercase',
        () {
          const password = 'PASSWORD123';
          final result = validator.validate(password);
          expect(result, const Left(PasswordMissingLowercaseFailure()));
        },
      );

      test(
        'should return Left(PasswordMissingLowercaseFailure) for all uppercase with numbers',
        () {
          const password = 'ABCDEFGH123';
          final result = validator.validate(password);
          expect(result, const Left(PasswordMissingLowercaseFailure()));
        },
      );
    });

    group('missing number', () {
      test(
        'should return Left(PasswordMissingNumberFailure) when no number',
        () {
          const password = 'Password';
          final result = validator.validate(password);
          expect(result, const Left(PasswordMissingNumberFailure()));
        },
      );

      test(
        'should return Left(PasswordMissingNumberFailure) for letters and special chars only',
        () {
          const password = 'Password!@#';
          final result = validator.validate(password);
          expect(result, const Left(PasswordMissingNumberFailure()));
        },
      );
    });

    group('multiple validation failures', () {
      test(
        'should return first failure in order: too short before missing uppercase',
        () {
          const password = 'pass1'; // Too short (5), no uppercase
          final result = validator.validate(password);
          expect(
            result,
            Left(PasswordTooShortFailure(PasswordValidator.minPasswordLength)),
          );
        },
      );

      test('should return missing uppercase when length OK but no uppercase', () {
        const password =
            'password123'; // Length OK, has lowercase and number, missing uppercase
        final result = validator.validate(password);
        expect(result, const Left(PasswordMissingUppercaseFailure()));
      });

      test(
        'should return missing lowercase when has uppercase and number but no lowercase',
        () {
          const password =
              'PASSWORD123'; // Length OK, has uppercase and number, missing lowercase
          final result = validator.validate(password);
          expect(result, const Left(PasswordMissingLowercaseFailure()));
        },
      );

      test(
        'should return missing number when has uppercase and lowercase but no number',
        () {
          const password =
              'Password'; // Length OK, has uppercase and lowercase, missing number
          final result = validator.validate(password);
          expect(result, const Left(PasswordMissingNumberFailure()));
        },
      );
    });
  });
}
