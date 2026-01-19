import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../entities/validation_failure.dart';
import '../validators/display_name_validator.dart';

/// Use case for validating display names
/// Follows Clean Architecture - domain layer owns validation logic
@injectable
class ValidateDisplayNameUseCase {
  final DisplayNameValidator _validator;

  ValidateDisplayNameUseCase(this._validator);

  /// Validates a display name
  /// Returns Right(name) if valid, Left(ValidationFailure) if invalid
  Either<ValidationFailure, String> call(String? displayName) {
    return _validator.validate(displayName);
  }
}
