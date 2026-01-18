import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_failure.dart';
import '../../domain/entities/user_entity.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthCheckingState extends AuthState {
  const AuthCheckingState();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final AuthFailure failure;

  const AuthError(this.failure);

  @override
  List<Object?> get props => [failure];
}

class AuthRateLimited extends AuthState {
  final int remainingSeconds;

  const AuthRateLimited(this.remainingSeconds);

  @override
  List<Object?> get props => [remainingSeconds];
}

class EmailVerificationRequired extends AuthState {
  final UserEntity user;

  const EmailVerificationRequired(this.user);

  @override
  List<Object?> get props => [user];
}
