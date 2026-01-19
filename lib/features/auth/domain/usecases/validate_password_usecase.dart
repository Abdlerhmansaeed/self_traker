// import 'package:fpdart/fpdart.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../entities/validation_failure.dart';
import '../validators/password_validator.dart';

/// Use case for validating passwords
/// Follows Clean Architecture - domain layer owns validation logic
@injectable
class ValidatePasswordUseCase {
  final PasswordValidator _validator;

  ValidatePasswordUseCase(this._validator);

  /// Validates a password
  /// Returns Right(password) if valid, Left(ValidationFailure) if invalid
  Either<ValidationFailure, String> call(String? password) {
    return _validator.validate(password);
  }
}
