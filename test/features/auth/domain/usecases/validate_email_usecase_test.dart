import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:self_traker/features/auth/domain/entities/validation_failure.dart';
import 'package:self_traker/features/auth/domain/usecases/validate_email_usecase.dart';
import 'package:self_traker/features/auth/domain/validators/email_validator.dart';

void main() {
  late EmailValidator validator;
  late ValidateEmailUseCase useCase;

  setUp(() {
    validator = EmailValidator();
    useCase = ValidateEmailUseCase(validator);
  });

  group('ValidateEmailUseCase', () {
    test(
      'should delegate to EmailValidator and return Right for valid email',
      () {
        // Arrange
        const email = 'test@example.com';

        // Act
        final result = useCase(email);

        // Assert
        expect(result, const Right('test@example.com'));
      },
    );

    test(
      'should delegate to EmailValidator and return Left for invalid email',
      () {
        // Arrange
        const email = 'invalid-email';

        // Act
        final result = useCase(email);

        // Assert
        expect(result, const Left(EmailInvalidFormatFailure()));
      },
    );

    test(
      'should delegate to EmailValidator and return Left for empty email',
      () {
        // Act
        final result = useCase('');

        // Assert
        expect(result, const Left(EmailEmptyFailure()));
      },
    );

    test(
      'should delegate to EmailValidator and return Left for null email',
      () {
        // Act
        final result = useCase(null);

        // Assert
        expect(result, const Left(EmailEmptyFailure()));
      },
    );

    test(
      'should delegate to EmailValidator and return Left for too long email',
      () {
        // Arrange
        final email = '${'a' * 310}@example.com'; // 321 characters

        // Act
        final result = useCase(email);

        // Assert
        expect(
          result,
          Left(EmailTooLongFailure(EmailValidator.maxEmailLength)),
        );
      },
    );
  });
}
