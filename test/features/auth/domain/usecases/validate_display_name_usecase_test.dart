import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:self_traker/features/auth/domain/entities/validation_failure.dart';
import 'package:self_traker/features/auth/domain/usecases/validate_display_name_usecase.dart';
import 'package:self_traker/features/auth/domain/validators/display_name_validator.dart';

void main() {
  late DisplayNameValidator validator;
  late ValidateDisplayNameUseCase useCase;

  setUp(() {
    validator = DisplayNameValidator();
    useCase = ValidateDisplayNameUseCase(validator);
  });

  group('ValidateDisplayNameUseCase', () {
    test(
      'should delegate to DisplayNameValidator and return Right for valid name',
      () {
        // Arrange
        const displayName = 'John Doe';

        // Act
        final result = useCase(displayName);

        // Assert
        expect(result, const Right('John Doe'));
      },
    );

    test(
      'should delegate to DisplayNameValidator and return Right for single character',
      () {
        // Arrange
        const displayName = 'J';

        // Act
        final result = useCase(displayName);

        // Assert
        expect(result, const Right('J'));
      },
    );

    test(
      'should delegate to DisplayNameValidator and return Left for empty name',
      () {
        // Act
        final result = useCase('');

        // Assert
        expect(result, const Left(DisplayNameEmptyFailure()));
      },
    );

    test(
      'should delegate to DisplayNameValidator and return Left for null name',
      () {
        // Act
        final result = useCase(null);

        // Assert
        expect(result, const Left(DisplayNameEmptyFailure()));
      },
    );

    test('should delegate to DisplayNameValidator and trim whitespace', () {
      // Arrange
      const displayName = '  John Doe  ';

      // Act
      final result = useCase(displayName);

      // Assert
      expect(result, const Right('John Doe'));
    });

    test(
      'should delegate to DisplayNameValidator and return Left for whitespace only',
      () {
        // Arrange
        const displayName = '   ';

        // Act
        final result = useCase(displayName);

        // Assert - After trimming becomes empty, too short
        expect(
          result,
          Left(DisplayNameTooShortFailure(DisplayNameValidator.minNameLength)),
        );
      },
    );
  });
}
