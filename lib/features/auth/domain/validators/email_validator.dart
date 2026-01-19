// import 'package:fpdart/fpdart.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../entities/validation_failure.dart';

/// Email validator following Clean Architecture principles
/// Validates email format according to RFC 5322 and application requirements
@injectable
class EmailValidator {
  // RFC 5322 compliant email regex
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
  );

  // Maximum email length per RFC 5321
  static const int maxEmailLength = 320;

  /// Validates an email address
  /// Returns Right(email) if valid, Left(ValidationFailure) if invalid
  Either<ValidationFailure, String> validate(String? email) {
    if (email == null || email.isEmpty) {
      return const Left(EmailEmptyFailure());
    }

    final trimmedEmail = email.trim();

    if (trimmedEmail.length > maxEmailLength) {
      return Left(EmailTooLongFailure(maxEmailLength));
    }

    if (!_emailRegex.hasMatch(trimmedEmail)) {
      return const Left(EmailInvalidFormatFailure());
    }

    return Right(trimmedEmail);
  }
}
