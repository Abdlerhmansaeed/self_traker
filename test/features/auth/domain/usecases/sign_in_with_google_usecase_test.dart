import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:self_traker/features/auth/domain/entities/auth_failure.dart';
import 'package:self_traker/features/auth/domain/entities/subscription_status.dart';
import 'package:self_traker/features/auth/domain/entities/user_entity.dart';
import 'package:self_traker/features/auth/domain/entities/notification_settings.dart';
import 'package:self_traker/features/auth/domain/entities/user_metadata.dart';
import 'package:self_traker/features/auth/domain/repositories/auth_repository.dart';
import 'package:self_traker/features/auth/domain/usecases/sign_in_with_google_usecase.dart';

// Mock repository
class MockAuthRepository implements AuthRepository {
  Either<AuthFailure, UserEntity>? signInWithGoogleResult;

  @override
  Future<Either<AuthFailure, UserEntity>> signInWithGoogle() async {
    return signInWithGoogleResult ?? Left(const UnknownAuthFailure());
  }

  @override
  Future<Either<AuthFailure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailure, void>> sendVerificationEmail() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailure, void>> sendPasswordResetEmail(String email) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailure, void>> signOut() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailure, UserEntity?>> getCurrentUser() async {
    throw UnimplementedError();
  }

  @override
  Stream<UserEntity?> watchAuthState() {
    throw UnimplementedError();
  }
}

void main() {
  late SignInWithGoogleUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInWithGoogleUseCase(mockRepository);
  });

  group('SignInWithGoogleUseCase', () {
    const testEmail = 'test@gmail.com';
    const testDisplayName = 'Test User';

    final testUser = UserEntity(
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

    test(
      'should return UserEntity when Google sign-in is successful',
      () async {
        // Arrange
        mockRepository.signInWithGoogleResult = Right(testUser);

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (user) {
          expect(user.email, testEmail);
          expect(user.displayName, testDisplayName);
          expect(user.emailVerified, true);
          expect(user.photoURL, isNotNull);
        });
      },
    );

    test(
      'should return CancelledFailure when user cancels Google sign-in',
      () async {
        // Arrange
        mockRepository.signInWithGoogleResult = Left(const CancelledFailure());

        // Act
        final result = await useCase();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<CancelledFailure>()),
          (user) => fail('Should not return user'),
        );
      },
    );

    test('should return NetworkErrorFailure when network fails', () async {
      // Arrange
      mockRepository.signInWithGoogleResult = Left(const NetworkErrorFailure());

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkErrorFailure>()),
        (user) => fail('Should not return user'),
      );
    });

    test(
      'should return AccountDisabledFailure when account is disabled',
      () async {
        // Arrange
        mockRepository.signInWithGoogleResult = Left(
          const AccountDisabledFailure(),
        );

        // Act
        final result = await useCase();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<AccountDisabledFailure>()),
          (user) => fail('Should not return user'),
        );
      },
    );

    test(
      'should return UnknownAuthFailure when an unexpected error occurs',
      () async {
        // Arrange
        mockRepository.signInWithGoogleResult = Left(
          const UnknownAuthFailure(message: 'Unexpected error'),
        );

        // Act
        final result = await useCase();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<UnknownAuthFailure>()),
          (user) => fail('Should not return user'),
        );
      },
    );
  });
}
