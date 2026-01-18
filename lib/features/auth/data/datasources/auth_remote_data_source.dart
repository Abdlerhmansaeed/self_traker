import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/usage_model.dart';

abstract interface class AuthRemoteDataSource {
  /// Get the current authenticated user from Firebase
  User? getCurrentFirebaseUser();

  /// Stream of auth state changes
  Stream<User?> authStateChanges();

  /// Register a new user with email and password
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Send email verification link
  Future<void> sendVerificationEmail();

  /// Sign in with email and password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  /// Update last login timestamp in Firestore
  Future<void> updateLastLoginAt(String userId);

  /// Sign in with Google
  Future<UserModel> signInWithGoogle();

  /// Check if a user document already exists
  Future<bool> checkUserExists(String userId);

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Sign out the current user
  Future<void> signOut();

  /// Create a new user document in Firestore
  Future<void> createUserDocument({
    required String userId,
    required String email,
    String? displayName,
    String? photoURL,
    required String preferredCurrency,
    required String preferredLanguage,
  });

  /// Create a new usage document in Firestore
  Future<void> createUsageDocument({
    required String userId,
  });

  /// Get user document from Firestore
  Future<UserModel?> getUserDocument(String userId);

  /// Check if an email is registered with Google Sign-In provider
  Future<bool> checkEmailExistsWithGoogle(String email);
}