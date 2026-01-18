import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';

@injectable
class SendPasswordResetUseCase {
  final AuthRepository _repository;

  SendPasswordResetUseCase(this._repository);

  Future<Either<AuthFailure, void>> call(String email) {
    return _repository.sendPasswordResetEmail(email);
  }
}
