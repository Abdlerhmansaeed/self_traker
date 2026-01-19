// import 'package:fpdart/fpdart.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../entities/validation_failure.dart';

/// Display name validator following Clean Architecture principles
/// Validates user display name for registration
@injectable
class DisplayNameValidator {
  static const int minNameLength = 1;

  /// Validates a display name
  /// Returns Right(name) if valid, Left(ValidationFailure) if invalid
  Either<ValidationFailure, String> validate(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return const Left(DisplayNameEmptyFailure());
    }

    final trimmedName = displayName.trim();

    if (trimmedName.length < minNameLength) {
      return Left(DisplayNameTooShortFailure(minNameLength));
    }

    return Right(trimmedName);
  }
}
