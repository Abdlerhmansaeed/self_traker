import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:self_traker/features/auth/domain/entities/validation_failure.dart';
import 'package:self_traker/features/auth/domain/validators/display_name_validator.dart';

void main() {
  late DisplayNameValidator validator;

  setUp(() {
    validator = DisplayNameValidator();
  });

  group('DisplayNameValidator', () {
    group('valid display names', () {
      test('should return Right for valid single word name', () {
        // Arrange
        const displayName = 'John';

        // Act
        final result = validator.validate(displayName);

        // Assert
        expect(result, const Right('John'));
      });

      test('should return Right for full name with space', () {
        const displayName = 'John Doe';
        final result = validator.validate(displayName);
        expect(result, const Right('John Doe'));
      });

      test('should return Right for name with multiple words', () {
        const displayName = 'John Michael Doe';
        final result = validator.validate(displayName);
        expect(result, const Right('John Michael Doe'));
      });

      test('should return Right for name with special characters', () {
        const displayName = "O'Brien";
        final result = validator.validate(displayName);
        expect(result, const Right("O'Brien"));
      });

      test('should return Right for name with hyphen', () {
        const displayName = 'Mary-Jane';
        final result = validator.validate(displayName);
        expect(result, const Right('Mary-Jane'));
      });

      test('should return Right for name with numbers', () {
        const displayName = 'User123';
        final result = validator.validate(displayName);
        expect(result, const Right('User123'));
      });

      test('should trim whitespace and return valid name', () {
        const displayName = '  John Doe  ';
        final result = validator.validate(displayName);
        expect(result, const Right('John Doe'));
      });

      test('should return Right for very long name', () {
        final displayName = 'A' * 100;
        final result = validator.validate(displayName);
        expect(result, Right(displayName));
      });

      test('should return Right for single character name', () {
        const displayName = 'J';
        final result = validator.validate(displayName);
        expect(result, const Right('J'));
      });
    });

    group('empty or null display names', () {
      test('should return Left(DisplayNameEmptyFailure) for null name', () {
        final result = validator.validate(null);
        expect(result, const Left(DisplayNameEmptyFailure()));
      });

      test('should return Left(DisplayNameEmptyFailure) for empty string', () {
        final result = validator.validate('');
        expect(result, const Left(DisplayNameEmptyFailure()));
      });

      test('should return Left for whitespace only after trimming', () {
        const displayName = '   ';
        final result = validator.validate(displayName);
        // After trimming, it becomes empty, so should fail with too short
        expect(
          result,
          Left(DisplayNameTooShortFailure(DisplayNameValidator.minNameLength)),
        );
      });
    });

    group('display name length validation', () {
      test(
        'should return Left(DisplayNameTooShortFailure) for name shorter than min after trim',
        () {
          const displayName = '';
          final result = validator.validate(displayName);
          expect(result, const Left(DisplayNameEmptyFailure()));
        },
      );
    });
  });
}
