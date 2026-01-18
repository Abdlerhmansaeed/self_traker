import 'dart:async';
import 'dart:developer';
// import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/auth_failure.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/send_password_reset_usecase.dart';
import '../../domain/usecases/send_verification_email_usecase.dart';
import '../../domain/usecases/sign_in_with_email_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_with_email_usecase.dart';
// import '../../exceptions/auth_exceptions.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  final SendVerificationEmailUseCase _sendVerificationEmailUseCase;
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SendPasswordResetUseCase _sendPasswordResetUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SignOutUseCase _signOutUseCase;

  AuthCubit({
    required SignUpWithEmailUseCase signUpWithEmailUseCase,
    required SendVerificationEmailUseCase sendVerificationEmailUseCase,
    required SignInWithEmailUseCase signInWithEmailUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required SendPasswordResetUseCase sendPasswordResetUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required SignOutUseCase signOutUseCase,
  }) : _signUpWithEmailUseCase = signUpWithEmailUseCase,
       _sendVerificationEmailUseCase = sendVerificationEmailUseCase,
       _signInWithEmailUseCase = signInWithEmailUseCase,
       _signInWithGoogleUseCase = signInWithGoogleUseCase,
       _sendPasswordResetUseCase = sendPasswordResetUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _signOutUseCase = signOutUseCase,
       super(const AuthInitial());

  int _failedLoginAttempts = 0;
  DateTime? _lockoutStartTime;
  Timer? _lockoutTimer;

  /// Sign up with email and password
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    print(
      'AuthCubit: Starting signUpWithEmail forxssssssssssssssssssssssssssssssssssssssssssssssssssss $email',
    );
    emit(const AuthLoading());

    final result = await _signUpWithEmailUseCase(
      email: email,
      password: password,
      displayName: displayName,
    );

    result.fold(
      (failure) {
        log(
          'AuthCubit: signUpWithEmail failed:xxxxxxxxxxxxxxxxxxxxxxxxxx $failure',
        );
        emit(AuthError(failure));
      },
      (user) {
        if (!user.emailVerified) {
          emit(EmailVerificationRequired(user));
        } else {
          emit(AuthAuthenticated(user));
        }
      },
    );
  }

  /// Send verification email to current user
  Future<void> sendVerificationEmail() async {
    final result = await _sendVerificationEmailUseCase();
    result.fold((failure) => emit(AuthError(failure)), (_) {
      // Success - keep current state or show success message
      if (state is AuthAuthenticated) {
        emit(state);
      } else if (state is EmailVerificationRequired) {
        emit(state);
      }
    });
  }

  /// Sign in with email and password
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // Check if locked out
    if (_isLockedOut()) {
      final remaining = _getRemainingLockoutSeconds();
      emit(AuthRateLimited(remaining));
      return;
    }

    emit(const AuthLoading());

    final result = await _signInWithEmailUseCase(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        if (failure is InvalidCredentialsFailure) {
          _failedLoginAttempts++;
          if (_failedLoginAttempts >= 5) {
            _startLockout();
            emit(AuthRateLimited(60));
          } else {
            emit(AuthError(failure));
          }
        } else {
          emit(AuthError(failure));
        }
      },
      (user) {
        _failedLoginAttempts = 0;
        _cancelLockout();

        if (!user.emailVerified) {
          emit(EmailVerificationRequired(user));
        } else {
          emit(AuthAuthenticated(user));
        }
      },
    );
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    emit(const AuthLoading());

    final result = await _signInWithGoogleUseCase();

    result.fold(
      (failure) {
        log(
          'AuthCubit: signInWithGoogle failed: GGGGGGGGGGGGGGGGGGGGG $failure',
        );
        if (failure is! CancelledFailure) {
          emit(AuthError(failure));
        } else {
          // User cancelled - don't emit error
          emit(state);
        }
      },
      (user) {
        _failedLoginAttempts = 0;
        _cancelLockout();

        if (!user.emailVerified) {
          emit(EmailVerificationRequired(user));
        } else {
          emit(AuthAuthenticated(user));
        }
      },
    );
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    emit(const AuthLoading());

    final result = await _sendPasswordResetUseCase(email);

    result.fold((failure) => emit(AuthError(failure)), (_) {
      // Success - show success state or return to unauthenticated
      emit(const AuthUnauthenticated());
    });
  }

  /// Check current auth state and emit appropriate state
  Future<void> checkAuthState() async {
    emit(const AuthCheckingState());

    final result = await _getCurrentUserUseCase();

    result.fold((failure) => emit(const AuthUnauthenticated()), (user) {
      if (user != null) {
        if (!user.emailVerified) {
          emit(EmailVerificationRequired(user));
        } else {
          emit(AuthAuthenticated(user));
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  /// Sign out the current user
  Future<void> signOut() async {
    emit(const AuthLoading());

    final result = await _signOutUseCase();

    result.fold((failure) => emit(AuthError(failure)), (_) {
      _failedLoginAttempts = 0;
      _cancelLockout();
      emit(const AuthUnauthenticated());
    });
  }

  // Rate limiting helpers
  void _startLockout() {
    _lockoutStartTime = DateTime.now();
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isClosed) {
        final remaining = _getRemainingLockoutSeconds();
        if (remaining <= 0) {
          _cancelLockout();
          emit(const AuthUnauthenticated());
        } else {
          emit(AuthRateLimited(remaining));
        }
      }
    });
  }

  void _cancelLockout() {
    _lockoutTimer?.cancel();
    _lockoutTimer = null;
    _lockoutStartTime = null;
  }

  bool _isLockedOut() {
    if (_lockoutStartTime == null) return false;
    final elapsed = DateTime.now().difference(_lockoutStartTime!);
    return elapsed.inSeconds < 60;
  }

  int _getRemainingLockoutSeconds() {
    if (_lockoutStartTime == null) return 0;
    final elapsed = DateTime.now().difference(_lockoutStartTime!);
    final remaining = 60 - elapsed.inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  @override
  Future<void> close() {
    _cancelLockout();
    return super.close();
  }
}
