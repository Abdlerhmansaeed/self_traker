// import 'package:fpdart/fpdart.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../entities/auth_failure.dart';
// import '../../domain/entities/user_entity.dart';

/// Rate limiting guard for sign-in attempts
/// Prevents brute force attacks by enforcing lockout after failed attempts
/// Follows Clean Architecture - business logic in domain layer
@injectable
class RateLimitingGuard {
  static const int maxFailedAttempts = 5;
  static const int lockoutDurationSeconds = 60;

  int _failedAttempts = 0;
  DateTime? _lockoutStartTime;

  /// Check if currently locked out
  bool isLockedOut() {
    if (_lockoutStartTime == null) return false;

    final elapsed = DateTime.now().difference(_lockoutStartTime!);
    return elapsed.inSeconds < lockoutDurationSeconds;
  }

  /// Get remaining lockout seconds
  int getRemainingLockoutSeconds() {
    if (_lockoutStartTime == null) return 0;

    final elapsed = DateTime.now().difference(_lockoutStartTime!);
    final remaining = lockoutDurationSeconds - elapsed.inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  /// Record a failed attempt
  void recordFailedAttempt() {
    _failedAttempts++;

    if (_failedAttempts >= maxFailedAttempts) {
      _lockoutStartTime = DateTime.now();
    }
  }

  /// Reset rate limiting state after successful authentication
  void reset() {
    _failedAttempts = 0;
    _lockoutStartTime = null;
  }

  /// Check if operation is allowed (not locked out)
  /// Returns Left(RateLimitFailure) if locked out, Right(unit) if allowed
  Either<AuthFailure, Unit> checkAllowed() {
    if (isLockedOut()) {
      final remaining = getRemainingLockoutSeconds();
      return Left(RateLimitedFailure(remainingSeconds: remaining));
    }
    return const Right(unit);
  }
}
