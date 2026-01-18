import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:self_traker/features/auth/domain/entities/auth_failure.dart';
import 'package:self_traker/features/auth/domain/repositories/auth_repository.dart';
import 'package:self_traker/features/auth/domain/usecases/send_verification_email_usecase.dart';
import 'package:self_traker/features/auth/domain/entities/user_entity.dart';

// Mock repository
class MockAuthRepository implements AuthRepository {
  Either<AuthFailure, void>? sendVerificationResult;

  @override
  Future<Either<AuthFailure, void>> sendVerificationEmail() async {
    return sendVerificationResult ?? Left(const UnknownAuthFailure());
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
  late SendVerificationEmailUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SendVerificationEmailUseCase(mockRepository);
  });

  group('SendVerificationEmailUseCase', () {
    test('should return success when verification email is sent', () async {
      // Arrange
      mockRepository.sendVerificationResult = const Right(null);

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (_) => expect(true, true),
      );
    });

    test('should return NetworkErrorFailure when network fails', () async {
      // Arrange
      mockRepository.sendVerificationResult = Left(const NetworkErrorFailure());

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkErrorFailure>()),
        (_) => fail('Should not return success'),
      );
    });

    test(
      'should return UnknownAuthFailure when an unexpected error occurs',
      () async {
        // Arrange
        mockRepository.sendVerificationResult = Left(
          const UnknownAuthFailure(),
        );

        // Act
        final result = await useCase();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<UnknownAuthFailure>()),
          (_) => fail('Should not return success'),
        );
      },
    );

    test(
      'should return EmailNotVerifiedFailure when email is already verified',
      () async {
        // Arrange
        mockRepository.sendVerificationResult = Left(
          const EmailNotVerifiedFailure(),
        );

        // Act
        final result = await useCase();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<EmailNotVerifiedFailure>()),
          (_) => fail('Should not return success'),
        );
      },
    );
  });
}
