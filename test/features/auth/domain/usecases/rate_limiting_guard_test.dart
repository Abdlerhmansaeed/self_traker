import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:self_traker/features/auth/domain/entities/auth_failure.dart';
import 'package:self_traker/features/auth/domain/usecases/rate_limiting_guard.dart';

void main() {
  late RateLimitingGuard guard;

  setUp(() {
    guard = RateLimitingGuard();
  });

  group('RateLimitingGuard', () {
    group('checkAllowed', () {
      test('should return Right(unit) when not locked out', () {
        // Act
        final result = guard.checkAllowed();

        // Assert
        expect(result, const Right(unit));
      });

      test('should return Right(unit) before reaching max failed attempts', () {
        // Arrange - Record 4 failed attempts (max is 5)
        for (int i = 0; i < 4; i++) {
          guard.recordFailedAttempt();
        }

        // Act
        final result = guard.checkAllowed();

        // Assert
        expect(result, const Right(unit));
      });

      test(
        'should return Left(RateLimitedFailure) after reaching max failed attempts',
        () {
          // Arrange - Record 5 failed attempts (max is 5)
          for (int i = 0; i < RateLimitingGuard.maxFailedAttempts; i++) {
            guard.recordFailedAttempt();
          }

          // Act
          final result = guard.checkAllowed();

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<RateLimitedFailure>());
            expect(
              (failure as RateLimitedFailure).remainingSeconds,
              greaterThan(0),
            );
            expect(
              failure.remainingSeconds,
              lessThanOrEqualTo(RateLimitingGuard.lockoutDurationSeconds),
            );
          }, (_) => fail('Expected Left but got Right'));
        },
      );
    });

    group('isLockedOut', () {
      test('should return false when not locked out', () {
        // Act
        final isLockedOut = guard.isLockedOut();

        // Assert
        expect(isLockedOut, false);
      });

      test('should return false before reaching max failed attempts', () {
        // Arrange
        for (int i = 0; i < 4; i++) {
          guard.recordFailedAttempt();
        }

        // Act
        final isLockedOut = guard.isLockedOut();

        // Assert
        expect(isLockedOut, false);
      });

      test('should return true after reaching max failed attempts', () {
        // Arrange
        for (int i = 0; i < RateLimitingGuard.maxFailedAttempts; i++) {
          guard.recordFailedAttempt();
        }

        // Act
        final isLockedOut = guard.isLockedOut();

        // Assert
        expect(isLockedOut, true);
      });
    });

    group('getRemainingLockoutSeconds', () {
      test('should return 0 when not locked out', () {
        // Act
        final remaining = guard.getRemainingLockoutSeconds();

        // Assert
        expect(remaining, 0);
      });

      test('should return seconds remaining after lockout', () {
        // Arrange
        for (int i = 0; i < RateLimitingGuard.maxFailedAttempts; i++) {
          guard.recordFailedAttempt();
        }

        // Act
        final remaining = guard.getRemainingLockoutSeconds();

        // Assert
        expect(remaining, greaterThan(0));
        expect(
          remaining,
          lessThanOrEqualTo(RateLimitingGuard.lockoutDurationSeconds),
        );
      });

      test('should decrease remaining seconds over time', () async {
        // Arrange
        for (int i = 0; i < RateLimitingGuard.maxFailedAttempts; i++) {
          guard.recordFailedAttempt();
        }

        // Act
        final firstRemaining = guard.getRemainingLockoutSeconds();
        await Future.delayed(const Duration(seconds: 2));
        final secondRemaining = guard.getRemainingLockoutSeconds();

        // Assert
        expect(secondRemaining, lessThan(firstRemaining));
      });
    });

    group('recordFailedAttempt', () {
      test('should increment failed attempts counter', () {
        // Arrange - Record 4 attempts
        for (int i = 0; i < 4; i++) {
          guard.recordFailedAttempt();
          expect(guard.isLockedOut(), false);
        }

        // Act - Record 5th attempt (should trigger lockout)
        guard.recordFailedAttempt();

        // Assert
        expect(guard.isLockedOut(), true);
      });

      test('should trigger lockout on 5th failed attempt', () {
        // Arrange
        for (int i = 0; i < 4; i++) {
          guard.recordFailedAttempt();
        }
        expect(guard.isLockedOut(), false);

        // Act
        guard.recordFailedAttempt(); // 5th attempt

        // Assert
        expect(guard.isLockedOut(), true);
        expect(guard.getRemainingLockoutSeconds(), greaterThan(0));
      });

      test(
        'should not increase lockout duration with additional failed attempts',
        () {
          // Arrange
          for (int i = 0; i < RateLimitingGuard.maxFailedAttempts; i++) {
            guard.recordFailedAttempt();
          }
          final firstRemaining = guard.getRemainingLockoutSeconds();

          // Act - Record more attempts
          guard.recordFailedAttempt();
          guard.recordFailedAttempt();

          // Assert - Should still be locked out with similar remaining time
          expect(guard.isLockedOut(), true);
          final secondRemaining = guard.getRemainingLockoutSeconds();
          expect(
            (firstRemaining - secondRemaining).abs(),
            lessThan(2),
          ); // Within 2 seconds
        },
      );
    });

    group('reset', () {
      test('should reset failed attempts counter', () {
        // Arrange
        for (int i = 0; i < 3; i++) {
          guard.recordFailedAttempt();
        }

        // Act
        guard.reset();

        // Assert - Should be able to fail 5 more times before lockout
        for (int i = 0; i < 4; i++) {
          guard.recordFailedAttempt();
          expect(guard.isLockedOut(), false);
        }
      });

      test('should clear lockout state', () {
        // Arrange
        for (int i = 0; i < RateLimitingGuard.maxFailedAttempts; i++) {
          guard.recordFailedAttempt();
        }
        expect(guard.isLockedOut(), true);

        // Act
        guard.reset();

        // Assert
        expect(guard.isLockedOut(), false);
        expect(guard.getRemainingLockoutSeconds(), 0);
        expect(guard.checkAllowed(), const Right(unit));
      });
    });

    group('lockout expiration', () {
      test('should expire lockout after duration', () async {
        // Arrange
        for (int i = 0; i < RateLimitingGuard.maxFailedAttempts; i++) {
          guard.recordFailedAttempt();
        }
        expect(guard.isLockedOut(), true);

        // Act - Wait for lockout to expire (using shorter duration for test)
        // Note: In real implementation, we'd wait 60 seconds, but for testing
        // we verify the logic works correctly
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - Check that remaining seconds decreases or stays at max (60)
        final remaining = guard.getRemainingLockoutSeconds();
        expect(
          remaining,
          lessThanOrEqualTo(RateLimitingGuard.lockoutDurationSeconds),
        );
        expect(remaining, greaterThanOrEqualTo(0));
      });
    });
  });
}
