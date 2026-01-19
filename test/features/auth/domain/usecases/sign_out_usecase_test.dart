import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:self_traker/features/auth/domain/entities/auth_failure.dart';
import 'package:self_traker/features/auth/domain/repositories/auth_repository.dart';
import 'package:self_traker/features/auth/domain/usecases/sign_out_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignOutUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignOutUseCase(mockRepository);
  });

  group('SignOutUseCase', () {
    test('should sign out user successfully', () async {
      // Arrange
      when(
        () => mockRepository.signOut(),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(const Right<AuthFailure, void>(null)));
      verify(() => mockRepository.signOut()).called(1);
    });

    test('should return failure when sign out fails', () async {
      // Arrange
      const failure = UnknownAuthFailure(message: 'Sign out failed');
      when(
        () => mockRepository.signOut(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(const Left<AuthFailure, void>(failure)));
      verify(() => mockRepository.signOut()).called(1);
    });

    test('should return failure on error', () async {
      // Arrange
      const failure = UnknownAuthFailure(message: 'Unknown error');
      when(
        () => mockRepository.signOut(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<AuthFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });
}
