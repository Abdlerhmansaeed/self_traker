import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:self_traker/features/auth/domain/entities/validation_failure.dart';
import 'package:self_traker/features/auth/domain/usecases/validate_password_usecase.dart';
import 'package:self_traker/features/auth/domain/validators/password_validator.dart';

void main() {
  late PasswordValidator validator;
  late ValidatePasswordUseCase useCase;

  setUp(() {
    validator = PasswordValidator();
    useCase = ValidatePasswordUseCase(validator);
  });

  group('ValidatePasswordUseCase', () {
    test(
      'should delegate to PasswordValidator and return Right for valid password',
      () {
        // Arrange
        const password = 'Password123';

        // Act
        final result = useCase(password);

        // Assert
        expect(result, const Right('Password123'));
      },
    );

    test(
      'should delegate to PasswordValidator and return Left for empty password',
      () {
        // Act
        final result = useCase('');

        // Assert
        expect(result, const Left(PasswordEmptyFailure()));
      },
    );

    test(
      'should delegate to PasswordValidator and return Left for null password',
      () {
        // Act
        final result = useCase(null);

        // Assert
        expect(result, const Left(PasswordEmptyFailure()));
      },
    );

    test(
      'should delegate to PasswordValidator and return Left for too short password',
      () {
        // Arrange
        const password = 'Pass12'; // Only 6 characters

        // Act
        final result = useCase(password);

        // Assert
        expect(
          result,
          Left(PasswordTooShortFailure(PasswordValidator.minPasswordLength)),
        );
      },
    );

    test(
      'should delegate to PasswordValidator and return Left for password missing uppercase',
      () {
        // Arrange
        const password = 'password123';

        // Act
        final result = useCase(password);

        // Assert
        expect(result, const Left(PasswordMissingUppercaseFailure()));
      },
    );

    test(
      'should delegate to PasswordValidator and return Left for password missing lowercase',
      () {
        // Arrange
        const password = 'PASSWORD123';

        // Act
        final result = useCase(password);

        // Assert
        expect(result, const Left(PasswordMissingLowercaseFailure()));
      },
    );

    test(
      'should delegate to PasswordValidator and return Left for password missing number',
      () {
        // Arrange
        const password = 'Password';

        // Act
        final result = useCase(password);

        // Assert
        expect(result, const Left(PasswordMissingNumberFailure()));
      },
    );
  });
}
