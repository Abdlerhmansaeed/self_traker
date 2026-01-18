import 'package:equatable/equatable.dart';

sealed class AuthFailure extends Equatable {
  const AuthFailure();

  @override
  List<Object?> get props => [];

  String getLocalizedMessageKey() => 'auth_error_unknown';
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure();

  @override
  String getLocalizedMessageKey() => 'auth_error_invalid_credentials';
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure();

  @override
  String getLocalizedMessageKey() => 'auth_error_email_exists';
}

class EmailExistsWithGoogleFailure extends AuthFailure {
  const EmailExistsWithGoogleFailure();

  @override
  String getLocalizedMessageKey() => 'auth_error_email_exists_google';
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure();

  @override
  String getLocalizedMessageKey() => 'auth_error_weak_password';
}

class RateLimitedFailure extends AuthFailure {
  final int remainingSeconds;

  const RateLimitedFailure({required this.remainingSeconds});

  @override
  List<Object?> get props => [remainingSeconds];

  @override
  String getLocalizedMessageKey() => 'auth_error_rate_limited';
}

class NetworkErrorFailure extends AuthFailure {
  const NetworkErrorFailure();

  @override
  String getLocalizedMessageKey() => 'auth_error_network';
}

class AccountDisabledFailure extends AuthFailure {
  const AccountDisabledFailure();

  @override
  String getLocalizedMessageKey() => 'auth_error_account_disabled';
}

class EmailNotVerifiedFailure extends AuthFailure {
  const EmailNotVerifiedFailure();

  @override
  String getLocalizedMessageKey() => 'auth_error_email_not_verified';
}

class CancelledFailure extends AuthFailure {
  const CancelledFailure();

  @override
  String getLocalizedMessageKey() => '';
}

class UnknownAuthFailure extends AuthFailure {
  final String? message;

  const UnknownAuthFailure({this.message});

  @override
  List<Object?> get props => [message];

  @override
  String getLocalizedMessageKey() => 'auth_error_unknown';
}
