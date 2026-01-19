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

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetCurrentUserUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = GetCurrentUserUseCase(mockRepository);
  });

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

  group('GetCurrentUserUseCase', () {
    test('should return user when user is authenticated', () async {
      // Arrange
      when(
        () => mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => Right(testUser));

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(Right<AuthFailure, UserEntity?>(testUser)));
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('should return null when no user is authenticated', () async {
      // Arrange
      when(
        () => mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(const Right<AuthFailure, UserEntity?>(null)));
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      const failure = UnknownAuthFailure(message: 'Test error');
      when(
        () => mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(const Left<AuthFailure, UserEntity?>(failure)));
      verify(() => mockRepository.getCurrentUser()).called(1);
    });
  });
}
