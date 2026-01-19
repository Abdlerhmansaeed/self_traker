import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:self_traker/features/auth/domain/entities/auth_failure.dart';
import 'package:self_traker/features/auth/domain/entities/notification_settings.dart';
import 'package:self_traker/features/auth/domain/entities/subscription_status.dart';
import 'package:self_traker/features/auth/domain/entities/user_entity.dart';
import 'package:self_traker/features/auth/domain/entities/user_metadata.dart';
import 'package:self_traker/features/auth/domain/repositories/auth_repository.dart';
import 'package:self_traker/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:self_traker/features/auth/domain/usecases/rate_limiting_guard.dart';
import 'package:self_traker/features/auth/domain/usecases/send_password_reset_usecase.dart';
import 'package:self_traker/features/auth/domain/usecases/send_verification_email_usecase.dart';
import 'package:self_traker/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:self_traker/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:self_traker/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:self_traker/features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:self_traker/features/auth/domain/usecases/validate_display_name_usecase.dart';
import 'package:self_traker/features/auth/domain/usecases/validate_email_usecase.dart';
import 'package:self_traker/features/auth/domain/usecases/validate_password_usecase.dart';
import 'package:self_traker/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:self_traker/features/auth/presentation/cubit/auth_state.dart';

// Mocks
class MockSignUpWithEmailUseCase extends Mock
    implements SignUpWithEmailUseCase {}

class MockSendVerificationEmailUseCase extends Mock
    implements SendVerificationEmailUseCase {}

class MockSignInWithEmailUseCase extends Mock
    implements SignInWithEmailUseCase {}

class MockSignInWithGoogleUseCase extends Mock
    implements SignInWithGoogleUseCase {}

class MockSendPasswordResetUseCase extends Mock
    implements SendPasswordResetUseCase {}

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockValidateEmailUseCase extends Mock implements ValidateEmailUseCase {}

class MockValidatePasswordUseCase extends Mock
    implements ValidatePasswordUseCase {}

class MockValidateDisplayNameUseCase extends Mock
    implements ValidateDisplayNameUseCase {}

class MockRateLimitingGuard extends Mock implements RateLimitingGuard {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthCubit authCubit;
  late MockSignUpWithEmailUseCase mockSignUpWithEmailUseCase;
  late MockSendVerificationEmailUseCase mockSendVerificationEmailUseCase;
  late MockSignInWithEmailUseCase mockSignInWithEmailUseCase;
  late MockSignInWithGoogleUseCase mockSignInWithGoogleUseCase;
  late MockSendPasswordResetUseCase mockSendPasswordResetUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockSignOutUseCase mockSignOutUseCase;
  late MockValidateEmailUseCase mockValidateEmailUseCase;
  late MockValidatePasswordUseCase mockValidatePasswordUseCase;
  late MockValidateDisplayNameUseCase mockValidateDisplayNameUseCase;
  late MockRateLimitingGuard mockRateLimitingGuard;
  late MockAuthRepository mockAuthRepository;

  final testUser = UserEntity(
    id: 'test-user-id',
    email: 'test@example.com',
    displayName: 'Test User',
    photoURL: null,
    phoneNumber: null,
    preferredCurrency: 'EGP',
    preferredLanguage: 'en',
    subscriptionStatus: SubscriptionStatus.free,
    subscriptionExpiration: null,
    monthlyBudget: null,
    createdAt: DateTime.now(),
    lastLoginAt: DateTime.now(),
    totalExpenses: 0,
    emailVerified: true,
    notificationSettings: NotificationSettings(
      budgetAlerts: true,
      weeklyReports: true,
      tips: true,
    ),
    metadata: UserMetadata(
      onboardingCompleted: false,
      firstExpenseDate: null,
      appVersion: '1.0.0',
    ),
  );

  final unverifiedUser = UserEntity(
    id: 'test-user-id',
    email: 'test@example.com',
    displayName: 'Test User',
    photoURL: null,
    phoneNumber: null,
    preferredCurrency: 'EGP',
    preferredLanguage: 'en',
    subscriptionStatus: SubscriptionStatus.free,
    subscriptionExpiration: null,
    monthlyBudget: null,
    createdAt: DateTime.now(),
    lastLoginAt: DateTime.now(),
    totalExpenses: 0,
    emailVerified: false,
    notificationSettings: NotificationSettings(
      budgetAlerts: true,
      weeklyReports: true,
      tips: true,
    ),
    metadata: UserMetadata(
      onboardingCompleted: false,
      firstExpenseDate: null,
      appVersion: '1.0.0',
    ),
  );

  setUp(() {
    mockSignUpWithEmailUseCase = MockSignUpWithEmailUseCase();
    mockSendVerificationEmailUseCase = MockSendVerificationEmailUseCase();
    mockSignInWithEmailUseCase = MockSignInWithEmailUseCase();
    mockSignInWithGoogleUseCase = MockSignInWithGoogleUseCase();
    mockSendPasswordResetUseCase = MockSendPasswordResetUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockSignOutUseCase = MockSignOutUseCase();
    mockValidateEmailUseCase = MockValidateEmailUseCase();
    mockValidatePasswordUseCase = MockValidatePasswordUseCase();
    mockValidateDisplayNameUseCase = MockValidateDisplayNameUseCase();
    mockRateLimitingGuard = MockRateLimitingGuard();
    mockAuthRepository = MockAuthRepository();

    authCubit = AuthCubit(
      signUpWithEmailUseCase: mockSignUpWithEmailUseCase,
      sendVerificationEmailUseCase: mockSendVerificationEmailUseCase,
      signInWithEmailUseCase: mockSignInWithEmailUseCase,
      signInWithGoogleUseCase: mockSignInWithGoogleUseCase,
      sendPasswordResetUseCase: mockSendPasswordResetUseCase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      signOutUseCase: mockSignOutUseCase,
      validateEmailUseCase: mockValidateEmailUseCase,
      validatePasswordUseCase: mockValidatePasswordUseCase,
      validateDisplayNameUseCase: mockValidateDisplayNameUseCase,
      rateLimitingGuard: mockRateLimitingGuard,
      authRepository: mockAuthRepository,
    );
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit Session Methods', () {
    group('checkAuthState', () {
      test(
        'emits [AuthCheckingState, AuthAuthenticated] when user is authenticated',
        () async {
          // Arrange
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => Right(testUser));

          final states = <AuthState>[];
          final subscription = authCubit.stream.listen(states.add);

          // Act
          await authCubit.checkAuthState();
          await Future.delayed(const Duration(milliseconds: 100));

          // Assert
          expect(states, [
            const AuthCheckingState(),
            AuthAuthenticated(testUser),
          ]);

          await subscription.cancel();
        },
      );

      test(
        'emits [AuthCheckingState, EmailVerificationRequired] when user email is not verified',
        () async {
          // Arrange
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => Right(unverifiedUser));

          final states = <AuthState>[];
          final subscription = authCubit.stream.listen(states.add);

          // Act
          await authCubit.checkAuthState();
          await Future.delayed(const Duration(milliseconds: 100));

          // Assert
          expect(states, [
            const AuthCheckingState(),
            EmailVerificationRequired(unverifiedUser),
          ]);

          await subscription.cancel();
        },
      );

      test(
        'emits [AuthCheckingState, AuthUnauthenticated] when no user is authenticated',
        () async {
          // Arrange
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => const Right(null));

          final states = <AuthState>[];
          final subscription = authCubit.stream.listen(states.add);

          // Act
          await authCubit.checkAuthState();
          await Future.delayed(const Duration(milliseconds: 100));

          // Assert
          expect(states, [
            const AuthCheckingState(),
            const AuthUnauthenticated(),
          ]);

          await subscription.cancel();
        },
      );

      test(
        'emits [AuthCheckingState, AuthUnauthenticated] when getting user fails',
        () async {
          // Arrange
          when(() => mockGetCurrentUserUseCase()).thenAnswer(
            (_) async => const Left(UnknownAuthFailure(message: 'Error')),
          );

          final states = <AuthState>[];
          final subscription = authCubit.stream.listen(states.add);

          // Act
          await authCubit.checkAuthState();
          await Future.delayed(const Duration(milliseconds: 100));

          // Assert
          expect(states, [
            const AuthCheckingState(),
            const AuthUnauthenticated(),
          ]);

          await subscription.cancel();
        },
      );
    });

    group('signOut', () {
      test(
        'emits [AuthLoading, AuthUnauthenticated] when sign out succeeds',
        () async {
          // Arrange
          when(
            () => mockSignOutUseCase(),
          ).thenAnswer((_) async => const Right(null));
          when(() => mockRateLimitingGuard.reset()).thenReturn(null);

          final states = <AuthState>[];
          final subscription = authCubit.stream.listen(states.add);

          // Act
          await authCubit.signOut();
          await Future.delayed(const Duration(milliseconds: 100));

          // Assert
          expect(states, [const AuthLoading(), const AuthUnauthenticated()]);

          verify(() => mockSignOutUseCase()).called(1);
          verify(() => mockRateLimitingGuard.reset()).called(1);

          await subscription.cancel();
        },
      );

      test('emits [AuthLoading, AuthError] when sign out fails', () async {
        // Arrange
        const failure = UnknownAuthFailure(message: 'Sign out failed');
        when(
          () => mockSignOutUseCase(),
        ).thenAnswer((_) async => const Left(failure));

        final states = <AuthState>[];
        final subscription = authCubit.stream.listen(states.add);

        // Act
        await authCubit.signOut();
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(states, [
          const AuthLoading(),
          const AuthError(UnknownAuthFailure(message: 'Sign out failed')),
        ]);

        await subscription.cancel();
      });
    });

    group('subscribeToAuthStateChanges', () {
      test('updates state when auth state changes to authenticated', () async {
        // Arrange
        final controller = StreamController<UserEntity?>();
        when(
          () => mockAuthRepository.watchAuthState(),
        ).thenAnswer((_) => controller.stream);

        // Act
        authCubit.subscribeToAuthStateChanges();
        controller.add(testUser);

        // Wait for stream to process
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(authCubit.state, equals(AuthAuthenticated(testUser)));

        // Cleanup
        await controller.close();
      });

      test(
        'updates state when auth state changes to unauthenticated',
        () async {
          // Arrange
          final controller = StreamController<UserEntity?>();
          when(
            () => mockAuthRepository.watchAuthState(),
          ).thenAnswer((_) => controller.stream);

          // Act
          authCubit.subscribeToAuthStateChanges();
          controller.add(null);

          // Wait for stream to process
          await Future.delayed(const Duration(milliseconds: 100));

          // Assert
          expect(authCubit.state, equals(const AuthUnauthenticated()));

          // Cleanup
          await controller.close();
        },
      );

      test(
        'emits EmailVerificationRequired when user email is not verified',
        () async {
          // Arrange
          final controller = StreamController<UserEntity?>();
          when(
            () => mockAuthRepository.watchAuthState(),
          ).thenAnswer((_) => controller.stream);

          // Act
          authCubit.subscribeToAuthStateChanges();
          controller.add(unverifiedUser);

          // Wait for stream to process
          await Future.delayed(const Duration(milliseconds: 100));

          // Assert
          expect(
            authCubit.state,
            equals(EmailVerificationRequired(unverifiedUser)),
          );

          // Cleanup
          await controller.close();
        },
      );
    });
  });
}
