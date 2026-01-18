import 'package:fpdart/fpdart.dart';
import '../entities/auth_failure.dart';
import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  /// Register a new user with email and password
  Future<Either<AuthFailure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Send email verification link
  Future<Either<AuthFailure, void>> sendVerificationEmail();

  /// Sign in with email and password
  Future<Either<AuthFailure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with Google
  Future<Either<AuthFailure, UserEntity>> signInWithGoogle();

  /// Send password reset email
  Future<Either<AuthFailure, void>> sendPasswordResetEmail(String email);

  /// Sign out the current user
  Future<Either<AuthFailure, void>> signOut();

  /// Get the currently authenticated user
  Future<Either<AuthFailure, UserEntity?>> getCurrentUser();

  /// Stream of authentication state changes
  Stream<UserEntity?> watchAuthState();
}
