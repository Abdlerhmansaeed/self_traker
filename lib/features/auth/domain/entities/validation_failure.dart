import 'package:equatable/equatable.dart';

/// Base class for validation failures
sealed class ValidationFailure extends Equatable {
  const ValidationFailure();

  @override
  List<Object?> get props => [];
}

/// Email validation failures
class EmailEmptyFailure extends ValidationFailure {
  const EmailEmptyFailure();
}

class EmailInvalidFormatFailure extends ValidationFailure {
  const EmailInvalidFormatFailure();
}

class EmailTooLongFailure extends ValidationFailure {
  final int maxLength;
  const EmailTooLongFailure(this.maxLength);

  @override
  List<Object?> get props => [maxLength];
}

/// Password validation failures
class PasswordEmptyFailure extends ValidationFailure {
  const PasswordEmptyFailure();
}

class PasswordTooShortFailure extends ValidationFailure {
  final int minLength;
  const PasswordTooShortFailure(this.minLength);

  @override
  List<Object?> get props => [minLength];
}

class PasswordMissingUppercaseFailure extends ValidationFailure {
  const PasswordMissingUppercaseFailure();
}

class PasswordMissingLowercaseFailure extends ValidationFailure {
  const PasswordMissingLowercaseFailure();
}

class PasswordMissingNumberFailure extends ValidationFailure {
  const PasswordMissingNumberFailure();
}

/// Display name validation failures
class DisplayNameEmptyFailure extends ValidationFailure {
  const DisplayNameEmptyFailure();
}

class DisplayNameTooShortFailure extends ValidationFailure {
  final int minLength;
  const DisplayNameTooShortFailure(this.minLength);

  @override
  List<Object?> get props => [minLength];
}
