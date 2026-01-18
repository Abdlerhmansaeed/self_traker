import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';

@injectable
class SendVerificationEmailUseCase {
  final AuthRepository _repository;

  SendVerificationEmailUseCase(this._repository);

  Future<Either<AuthFailure, void>> call() {
    return _repository.sendVerificationEmail();
  }
}
