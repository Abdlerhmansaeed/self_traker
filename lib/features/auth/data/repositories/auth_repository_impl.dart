import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/auth_failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../exceptions/auth_exceptions.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AuthFailure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userModel = await _remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      return Right(userModel.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthErrorMapper.mapFirebaseAuthException(e));
    } catch (e) {
      return Left(UnknownAuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, void>> sendVerificationEmail() async {
    try {
      await _remoteDataSource.sendVerificationEmail();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthErrorMapper.mapFirebaseAuthException(e));
    } catch (e) {
      return Left(UnknownAuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return Right(userModel.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthErrorMapper.mapFirebaseAuthException(e));
    } catch (e) {
      return Left(UnknownAuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> signInWithGoogle() async {
    try {
      final userModel = await _remoteDataSource.signInWithGoogle();
      return Right(userModel.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthErrorMapper.mapFirebaseAuthException(e));
    } catch (e) {
      if (e.toString().contains('cancelled')) {
        return Left(const CancelledFailure());
      }
      return Left(UnknownAuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, void>> sendPasswordResetEmail(
    String email,
  ) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthErrorMapper.mapFirebaseAuthException(e));
    } catch (e) {
      return Left(UnknownAuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthErrorMapper.mapFirebaseAuthException(e));
    } catch (e) {
      return Left(UnknownAuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity?>> getCurrentUser() async {
    try {
      final firebaseUser = _remoteDataSource.getCurrentFirebaseUser();
      if (firebaseUser == null) {
        return const Right(null);
      }

      final userModel = await _remoteDataSource.getUserDocument(firebaseUser.uid);
      return Right(userModel?.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthErrorMapper.mapFirebaseAuthException(e));
    } catch (e) {
      return Left(UnknownAuthFailure(message: e.toString()));
    }
  }

  @override
  Stream<UserEntity?> watchAuthState() {
    return _remoteDataSource.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }
      final userModel = await _remoteDataSource.getUserDocument(firebaseUser.uid);
      return userModel?.toEntity();
    });
  }
}
