import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:self_traker/features/auth/domain/entities/auth_failure.dart';
import 'package:self_traker/features/auth/domain/entities/subscription_status.dart';
import 'package:self_traker/features/auth/domain/entities/user_entity.dart';
import 'package:self_traker/features/auth/domain/entities/notification_settings.dart';
import 'package:self_traker/features/auth/domain/entities/user_metadata.dart';
import 'package:self_traker/features/auth/domain/repositories/auth_repository.dart';
import 'package:self_traker/features/auth/domain/usecases/sign_up_with_email_usecase.dart';

// Mock repository
class MockAuthRepository implements AuthRepository {
  Either<AuthFailure, UserEntity>? signUpResult;
  
  @override
  Future<Either<AuthFailure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return signUpResult ?? Left(const UnknownAuthFailure());
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
  Future<Either<AuthFailure, UserEntity>> signInWithGoogle() async {
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
  late SignUpWithEmailUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignUpWithEmailUseCase(mockRepository);
  });

  group('SignUpWithEmailUseCase', () {
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

    test('should return UserEntity when signup is successful', () async {
      // Arrange
      mockRepository.signUpResult = Right(testUser);

      // Act
      final result = await useCase(
        email: testEmail,
        password: testPassword,
        displayName: testDisplayName,
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (user) {
          expect(user.email, testEmail);
          expect(user.displayName, testDisplayName);
          expect(user.emailVerified, false);
        },
      );
    });

    test('should return EmailAlreadyInUseFailure when email exists', () async {
      // Arrange
      mockRepository.signUpResult = Left(const EmailAlreadyInUseFailure());

      // Act
      final result = await useCase(
        email: testEmail,
        password: testPassword,
        displayName: testDisplayName,
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<EmailAlreadyInUseFailure>()),
        (user) => fail('Should not return user'),
      );
    });

    test('should return EmailExistsWithGoogleFailure when email is linked to Google', () async {
      // Arrange
      mockRepository.signUpResult = Left(const EmailExistsWithGoogleFailure());

      // Act
      final result = await useCase(
        email: testEmail,
        password: testPassword,
        displayName: testDisplayName,
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<EmailExistsWithGoogleFailure>()),
        (user) => fail('Should not return user'),
      );
    });

    test('should return WeakPasswordFailure when password is weak', () async {
      // Arrange
      mockRepository.signUpResult = Left(const WeakPasswordFailure());

      // Act
      final result = await useCase(
        email: testEmail,
        password: 'weak',
        displayName: testDisplayName,
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<WeakPasswordFailure>()),
        (user) => fail('Should not return user'),
      );
    });

    test('should return NetworkErrorFailure when network fails', () async {
      // Arrange
      mockRepository.signUpResult = Left(const NetworkErrorFailure());

      // Act
      final result = await useCase(
        email: testEmail,
        password: testPassword,
        displayName: testDisplayName,
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkErrorFailure>()),
        (user) => fail('Should not return user'),
      );
    });
  });
}
