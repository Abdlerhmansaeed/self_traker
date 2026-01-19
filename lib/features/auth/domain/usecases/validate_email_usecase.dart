// import 'package:fpdart/fpdart.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../entities/validation_failure.dart';
import '../validators/email_validator.dart';

/// Use case for validating email addresses
/// Follows Clean Architecture - domain layer owns validation logic
@injectable
class ValidateEmailUseCase {
  final EmailValidator _validator;

  ValidateEmailUseCase(this._validator);

  /// Validates an email address
  /// Returns Right(email) if valid, Left(ValidationFailure) if invalid
  Either<ValidationFailure, String> call(String? email) {
    return _validator.validate(email);
  }
}
