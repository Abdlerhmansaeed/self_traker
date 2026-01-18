import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:self_traker/features/auth/domain/entities/auth_failure.dart';
import 'package:self_traker/features/auth/domain/entities/subscription_status.dart';
import 'package:self_traker/features/auth/domain/entities/user_entity.dart';
import 'package:self_traker/features/auth/domain/entities/notification_settings.dart';
import 'package:self_traker/features/auth/domain/entities/user_metadata.dart';
import 'package:self_traker/features/auth/domain/repositories/auth_repository.dart';
import 'package:self_traker/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:self_traker/features/auth/domain/usecases/send_password_reset_usecase.dart';
import 'package:self_traker/features/auth/domain/usecases/send_verification_email_usecase.dart';
import 'package:self_traker/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:self_traker/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:self_traker/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:self_traker/features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:self_traker/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:self_traker/features/auth/presentation/cubit/auth_state.dart';

// Mock repository using mocktail
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthCubit authCubit;
  late MockAuthRepository mockRepository;
  late SignUpWithEmailUseCase signUpUseCase;
  late SendVerificationEmailUseCase sendVerificationUseCase;
  late SignInWithEmailUseCase signInUseCase;
  late SignInWithGoogleUseCase signInWithGoogleUseCase;
  late SendPasswordResetUseCase sendPasswordResetUseCase;
  late GetCurrentUserUseCase getCurrentUserUseCase;
  late SignOutUseCase signOutUseCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    signUpUseCase = SignUpWithEmailUseCase(mockRepository);
    sendVerificationUseCase = SendVerificationEmailUseCase(mockRepository);
    signInUseCase = SignInWithEmailUseCase(mockRepository);
    signInWithGoogleUseCase = SignInWithGoogleUseCase(mockRepository);
    sendPasswordResetUseCase = SendPasswordResetUseCase(mockRepository);
    getCurrentUserUseCase = GetCurrentUserUseCase(mockRepository);
    signOutUseCase = SignOutUseCase(mockRepository);

    authCubit = AuthCubit(
      signUpWithEmailUseCase: signUpUseCase,
      sendVerificationEmailUseCase: sendVerificationUseCase,
      signInWithEmailUseCase: signInUseCase,
      signInWithGoogleUseCase: signInWithGoogleUseCase,
      sendPasswordResetUseCase: sendPasswordResetUseCase,
      getCurrentUserUseCase: getCurrentUserUseCase,
      signOutUseCase: signOutUseCase,
    );
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit - Google Sign-In', () {
    const testEmail = 'test@gmail.com';
    const testDisplayName = 'Test User';

    final testGoogleUser = UserEntity(
      id: 'google-uid',
      email: testEmail,
      displayName: testDisplayName,
      photoURL: 'https://example.com/photo.jpg',
      phoneNumber: null,
      preferredCurrency: 'EGP',
      preferredLanguage: 'en',
      subscriptionStatus: SubscriptionStatus.free,
      subscriptionExpiration: null,
      monthlyBudget: null,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
      totalExpenses: 0,
      emailVerified: true, // Google accounts are pre-verified
      notificationSettings: NotificationSettings(),
      metadata: UserMetadata(),
    );

    test('emits [AuthLoading, AuthAuthenticated] when Google sign-in succeeds', () async {
      // Arrange
      when(() => mockRepository.signInWithGoogle())
          .thenAnswer((_) async => Right(testGoogleUser));

      // Assert first - set up expectation before act
      final futureStates = authCubit.stream.take(2).toList();

      // Act
      await authCubit.signInWithGoogle();

      // Assert
      final states = await futureStates;
      expect(states[0], isA<AuthLoading>());
      expect(states[1], isA<AuthAuthenticated>());
      expect((states[1] as AuthAuthenticated).user.email, testEmail);
      expect((states[1] as AuthAuthenticated).user.emailVerified, true);
      expect((states[1] as AuthAuthenticated).user.photoURL, isNotNull);
    });

    test('does not emit error when user cancels Google sign-in', () async {
      // Arrange
      when(() => mockRepository.signInWithGoogle())
          .thenAnswer((_) async => Left(const CancelledFailure()));

      // Assert first - only expect loading state
      final futureStates = authCubit.stream.take(1).toList();

      // Act
      await authCubit.signInWithGoogle();

      // Assert - should only emit loading state, no error
      final states = await futureStates;
      expect(states.length, 1);
      expect(states[0], isA<AuthLoading>());
      // Verify no AuthError is in the final state
      expect(authCubit.state, isNot(isA<AuthError>()));
    });

    test('emits [AuthLoading, AuthError] when Google sign-in fails with NetworkErrorFailure', () async {
      // Arrange
      when(() => mockRepository.signInWithGoogle())
          .thenAnswer((_) async => Left(const NetworkErrorFailure()));

      // Assert first
      final futureStates = authCubit.stream.take(2).toList();

      // Act
      await authCubit.signInWithGoogle();

      // Assert
      final states = await futureStates;
      expect(states[0], isA<AuthLoading>());
      expect(states[1], isA<AuthError>());
      expect((states[1] as AuthError).failure, isA<NetworkErrorFailure>());
    });

    test('emits [AuthLoading, AuthError] when Google sign-in fails with AccountDisabledFailure', () async {
      // Arrange
      when(() => mockRepository.signInWithGoogle())
          .thenAnswer((_) async => Left(const AccountDisabledFailure()));

      // Assert first
      final futureStates = authCubit.stream.take(2).toList();

      // Act
      await authCubit.signInWithGoogle();

      // Assert
      final states = await futureStates;
      expect(states[0], isA<AuthLoading>());
      expect(states[1], isA<AuthError>());
      expect((states[1] as AuthError).failure, isA<AccountDisabledFailure>());
    });

    test('emits [AuthLoading, AuthError] when Google sign-in fails with UnknownAuthFailure', () async {
      // Arrange
      when(() => mockRepository.signInWithGoogle())
          .thenAnswer((_) async => Left(const UnknownAuthFailure(message: 'Unexpected error')));

      // Assert first
      final futureStates = authCubit.stream.take(2).toList();

      // Act
      await authCubit.signInWithGoogle();

      // Assert
      final states = await futureStates;
      expect(states[0], isA<AuthLoading>());
      expect(states[1], isA<AuthError>());
      expect((states[1] as AuthError).failure, isA<UnknownAuthFailure>());
    });
  });
}
