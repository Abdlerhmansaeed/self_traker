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

  group('AuthCubit - Signup', () {
    const testEmail = 'test@example.com';
    const testPassword = 'TestPass123';
    const testDisplayName = 'Test User';

    final testUser = UserEntity(
      id: 'test-uid',
      email: testEmail,
      displayName: testDisplayName,
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
      notificationSettings: NotificationSettings(),
      metadata: UserMetadata(),
    );

    final verifiedTestUser = UserEntity(
      id: 'test-uid',
      email: testEmail,
      displayName: testDisplayName,
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
      notificationSettings: NotificationSettings(),
      metadata: UserMetadata(),
    );

    test(
      'emits [AuthLoading, EmailVerificationRequired] when signup succeeds with unverified email',
      () async {
        // Arrange
        when(
          () => mockRepository.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenAnswer((_) async => Right(testUser));

        // Act
        authCubit.signUpWithEmail(
          email: testEmail,
          password: testPassword,
          displayName: testDisplayName,
        );

        // Assert
        await expectLater(
          authCubit.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<EmailVerificationRequired>()
                .having((s) => s.user.email, 'email', testEmail)
                .having((s) => s.user.emailVerified, 'emailVerified', false),
          ]),
        );
      },
    );

    test(
      'emits [AuthLoading, AuthAuthenticated] when signup succeeds with verified email',
      () async {
        // Arrange
        when(
          () => mockRepository.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenAnswer((_) async => Right(verifiedTestUser));

        // Act
        authCubit.signUpWithEmail(
          email: testEmail,
          password: testPassword,
          displayName: testDisplayName,
        );

        // Assert
        await expectLater(
          authCubit.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthAuthenticated>()
                .having((s) => s.user.email, 'email', testEmail)
                .having((s) => s.user.emailVerified, 'emailVerified', true),
          ]),
        );
      },
    );

    test(
      'emits [AuthLoading, AuthError] when signup fails with EmailAlreadyInUseFailure',
      () async {
        // Arrange
        when(
          () => mockRepository.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenAnswer((_) async => Left(const EmailAlreadyInUseFailure()));

        // Act
        authCubit.signUpWithEmail(
          email: testEmail,
          password: testPassword,
          displayName: testDisplayName,
        );

        // Assert
        await expectLater(
          authCubit.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthError>().having(
              (s) => s.failure,
              'failure',
              isA<EmailAlreadyInUseFailure>(),
            ),
          ]),
        );
      },
    );

    test(
      'emits [AuthLoading, AuthError] when signup fails with EmailExistsWithGoogleFailure',
      () async {
        // Arrange
        when(
          () => mockRepository.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenAnswer((_) async => Left(const EmailExistsWithGoogleFailure()));

        // Act
        authCubit.signUpWithEmail(
          email: testEmail,
          password: testPassword,
          displayName: testDisplayName,
        );

        // Assert
        await expectLater(
          authCubit.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthError>().having(
              (s) => s.failure,
              'failure',
              isA<EmailExistsWithGoogleFailure>(),
            ),
          ]),
        );
      },
    );

    test(
      'emits [AuthLoading, AuthError] when signup fails with WeakPasswordFailure',
      () async {
        // Arrange
        when(
          () => mockRepository.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenAnswer((_) async => Left(const WeakPasswordFailure()));

        // Act
        authCubit.signUpWithEmail(
          email: testEmail,
          password: 'weak',
          displayName: testDisplayName,
        );

        // Assert
        await expectLater(
          authCubit.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthError>().having(
              (s) => s.failure,
              'failure',
              isA<WeakPasswordFailure>(),
            ),
          ]),
        );
      },
    );

    test(
      'emits [AuthLoading, AuthError] when signup fails with NetworkErrorFailure',
      () async {
        // Arrange
        when(
          () => mockRepository.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenAnswer((_) async => Left(const NetworkErrorFailure()));

        // Act
        authCubit.signUpWithEmail(
          email: testEmail,
          password: testPassword,
          displayName: testDisplayName,
        );

        // Assert
        await expectLater(
          authCubit.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthError>().having(
              (s) => s.failure,
              'failure',
              isA<NetworkErrorFailure>(),
            ),
          ]),
        );
      },
    );
  });

  group('AuthCubit - Send Verification Email', () {
    test('keeps current state when sendVerificationEmail succeeds', () async {
      // Arrange
      when(
        () => mockRepository.sendVerificationEmail(),
      ).thenAnswer((_) async => const Right(null));

      // Act
      authCubit.sendVerificationEmail();

      // Assert - should not emit any new state (stays at initial)
      await expectLater(
        authCubit.stream,
        emitsInOrder([
          // No new states expected
        ]),
      );
    });

    test('emits AuthError when sendVerificationEmail fails', () async {
      // Arrange
      when(
        () => mockRepository.sendVerificationEmail(),
      ).thenAnswer((_) async => Left(const NetworkErrorFailure()));

      // Act
      authCubit.sendVerificationEmail();

      // Assert
      await expectLater(
        authCubit.stream,
        emitsInOrder([
          isA<AuthError>().having(
            (s) => s.failure,
            'failure',
            isA<NetworkErrorFailure>(),
          ),
        ]),
      );
    });
  });
}
