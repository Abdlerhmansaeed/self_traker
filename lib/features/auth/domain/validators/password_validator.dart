// import 'package:fpdart/fpdart.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../entities/validation_failure.dart';

/// Password validator following Clean Architecture principles
/// Validates password strength according to security requirements:
/// - Minimum 8 characters
/// - At least one uppercase letter
/// - At least one lowercase letter
/// - At least one number
@injectable
class PasswordValidator {
  static const int minPasswordLength = 8;

  // Regex patterns for password requirements
  static final _uppercaseRegex = RegExp(r'[A-Z]');
  static final _lowercaseRegex = RegExp(r'[a-z]');
  static final _numberRegex = RegExp(r'\d');

  /// Validates a password
  /// Returns Right(password) if valid, Left(ValidationFailure) if invalid
  Either<ValidationFailure, String> validate(String? password) {
    if (password == null || password.isEmpty) {
      return const Left(PasswordEmptyFailure());
    }

    if (password.length < minPasswordLength) {
      return Left(PasswordTooShortFailure(minPasswordLength));
    }

    if (!_uppercaseRegex.hasMatch(password)) {
      return const Left(PasswordMissingUppercaseFailure());
    }

    if (!_lowercaseRegex.hasMatch(password)) {
      return const Left(PasswordMissingLowercaseFailure());
    }

    if (!_numberRegex.hasMatch(password)) {
      return const Left(PasswordMissingNumberFailure());
    }

    return Right(password);
  }
}
