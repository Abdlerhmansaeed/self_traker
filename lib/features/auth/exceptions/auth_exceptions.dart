import 'package:firebase_auth/firebase_auth.dart';
import '../domain/entities/auth_failure.dart';

class AuthExceptions implements Exception {
  final String message;
  AuthExceptions({required this.message});
}

/// Maps Firebase authentication error codes to domain AuthFailure types
class FirebaseAuthErrorMapper {
  static AuthFailure mapFirebaseAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'wrong-password':
      case 'user-not-found':
        return const InvalidCredentialsFailure();
      case 'email-already-in-use':
        return const EmailAlreadyInUseFailure();
      case 'email-exists-with-google':
        return const EmailExistsWithGoogleFailure();
      case 'weak-password':
        return const WeakPasswordFailure();
      case 'too-many-requests':
        // Extract retry-after if available, default to 60 seconds
        final remainingSeconds = _extractRetryAfter(exception.message) ?? 60;
        return RateLimitedFailure(remainingSeconds: remainingSeconds);
      case 'network-request-failed':
        return const NetworkErrorFailure();
      case 'user-disabled':
        return const AccountDisabledFailure();
      case 'operation-not-allowed':
        return const UnknownAuthFailure(
          message: 'Authentication method not enabled',
        );
      case 'invalid-email':
        return const InvalidCredentialsFailure();
      default:
        return UnknownAuthFailure(message: exception.message);
    }
  }

  static AuthFailure mapAuthException(Exception exception) {
    if (exception is FirebaseAuthException) {
      return mapFirebaseAuthException(exception);
    }
    return UnknownAuthFailure(message: exception.toString());
  }

  /// Extracts retry-after seconds from Firebase error message if available
  static int? _extractRetryAfter(String? message) {
    if (message == null) return null;
    // Firebase format: "We blocked all requests from this device due to unusual activity. Try again later. [ Too many requests from this IP address. Please try again after 60 seconds. ]"
    final match = RegExp(r'after (\d+) seconds').firstMatch(message);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '60');
    }
    return null;
  }
}
