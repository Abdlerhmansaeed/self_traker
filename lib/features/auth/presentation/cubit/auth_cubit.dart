import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/auth_failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/validation_failure.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/rate_limiting_guard.dart';
import '../../domain/usecases/send_password_reset_usecase.dart';
import '../../domain/usecases/send_verification_email_usecase.dart';
import '../../domain/usecases/sign_in_with_email_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_with_email_usecase.dart';
import '../../domain/usecases/validate_display_name_usecase.dart';
import '../../domain/usecases/validate_email_usecase.dart';
import '../../domain/usecases/validate_password_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
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
  final ValidateEmailUseCase _validateEmailUseCase;
  final ValidatePasswordUseCase _validatePasswordUseCase;
  final ValidateDisplayNameUseCase _validateDisplayNameUseCase;
  final RateLimitingGuard _rateLimitingGuard;
  final AuthRepository _authRepository;

  StreamSubscription<UserEntity?>? _authStateSubscription;

  AuthCubit({
    required SignUpWithEmailUseCase signUpWithEmailUseCase,
    required SendVerificationEmailUseCase sendVerificationEmailUseCase,
    required SignInWithEmailUseCase signInWithEmailUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required SendPasswordResetUseCase sendPasswordResetUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required SignOutUseCase signOutUseCase,
    required ValidateEmailUseCase validateEmailUseCase,
    required ValidatePasswordUseCase validatePasswordUseCase,
    required ValidateDisplayNameUseCase validateDisplayNameUseCase,
    required RateLimitingGuard rateLimitingGuard,
    required AuthRepository authRepository,
  }) : _signUpWithEmailUseCase = signUpWithEmailUseCase,
       _sendVerificationEmailUseCase = sendVerificationEmailUseCase,
       _signInWithEmailUseCase = signInWithEmailUseCase,
       _signInWithGoogleUseCase = signInWithGoogleUseCase,
       _sendPasswordResetUseCase = sendPasswordResetUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _signOutUseCase = signOutUseCase,
       _validateEmailUseCase = validateEmailUseCase,
       _validatePasswordUseCase = validatePasswordUseCase,
       _validateDisplayNameUseCase = validateDisplayNameUseCase,
       _rateLimitingGuard = rateLimitingGuard,
       _authRepository = authRepository,
       super(const AuthInitial());

  Timer? _lockoutTimer;

  /// Validate email field
  /// Returns ValidationFailure if invalid, null if valid
  ValidationFailure? validateEmail(String? email) {
    final result = _validateEmailUseCase(email);
    return result.fold((failure) => failure, (_) => null);
  }

  /// Validate password field
  /// Returns ValidationFailure if invalid, null if valid
  ValidationFailure? validatePassword(String? password) {
    final result = _validatePasswordUseCase(password);
    return result.fold((failure) => failure, (_) => null);
  }

  /// Validate display name field
  /// Returns ValidationFailure if invalid, null if valid
  ValidationFailure? validateDisplayName(String? displayName) {
    final result = _validateDisplayNameUseCase(displayName);
    return result.fold((failure) => failure, (_) => null);
  }

  /// Validate all signup fields
  /// Returns map of field errors, empty if all valid
  Map<String, ValidationFailure> validateSignupFields({
    required String? email,
    required String? password,
    required String? displayName,
  }) {
    final errors = <String, ValidationFailure>{};

    final emailError = validateEmail(email);
    if (emailError != null) errors['email'] = emailError;

    final passwordError = validatePassword(password);
    if (passwordError != null) errors['password'] = passwordError;

    final nameError = validateDisplayName(displayName);
    if (nameError != null) errors['displayName'] = nameError;

    return errors;
  }

  /// Validate login fields
  /// Returns map of field errors, empty if all valid
  Map<String, ValidationFailure> validateLoginFields({
    required String? email,
    required String? password,
  }) {
    final errors = <String, ValidationFailure>{};

    final emailError = validateEmail(email);
    if (emailError != null) errors['email'] = emailError;

    final passwordError = validatePassword(password);
    if (passwordError != null) errors['password'] = passwordError;

    return errors;
  }

  /// Sign up with email and password
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
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
    // Check rate limiting using domain guard
    final rateLimitCheck = _rateLimitingGuard.checkAllowed();
    if (rateLimitCheck.isLeft()) {
      final remaining = _rateLimitingGuard.getRemainingLockoutSeconds();
      emit(AuthRateLimited(remaining));
      _startLockoutTimer();
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
          _rateLimitingGuard.recordFailedAttempt();
          if (_rateLimitingGuard.isLockedOut()) {
            final remaining = _rateLimitingGuard.getRemainingLockoutSeconds();
            emit(AuthRateLimited(remaining));
            _startLockoutTimer();
          } else {
            emit(AuthError(failure));
          }
        } else {
          emit(AuthError(failure));
        }
      },
      (user) {
        _rateLimitingGuard.reset();
        _cancelLockoutTimer();

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
        _rateLimitingGuard.reset();
        _cancelLockoutTimer();

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
      _rateLimitingGuard.reset();
      _cancelLockoutTimer();
      emit(const AuthUnauthenticated());
    });
  }

  // Rate limiting timer management
  void _startLockoutTimer() {
    _lockoutTimer?.cancel();
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isClosed) {
        final remaining = _rateLimitingGuard.getRemainingLockoutSeconds();
        if (remaining <= 0) {
          _cancelLockoutTimer();
          emit(const AuthUnauthenticated());
        } else {
          emit(AuthRateLimited(remaining));
        }
      }
    });
  }

  void _cancelLockoutTimer() {
    _lockoutTimer?.cancel();
    _lockoutTimer = null;
  }

  /// Subscribe to authentication state changes
  /// Call this on app startup to listen for auth state changes
  void subscribeToAuthStateChanges() {
    _authStateSubscription?.cancel();
    _authStateSubscription = _authRepository.watchAuthState().listen(
      (user) {
        if (isClosed) return;

        if (user == null) {
          // Only emit unauthenticated if not already in a transitional state
          if (state is! AuthLoading && state is! AuthCheckingState) {
            emit(const AuthUnauthenticated());
          }
        } else {
          if (!user.emailVerified) {
            emit(EmailVerificationRequired(user));
          } else {
            emit(AuthAuthenticated(user));
          }
        }
      },
      onError: (error) {
        log('AuthCubit: Auth state stream error: $error');
        if (!isClosed) {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  /// Cancel auth state subscription
  void _cancelAuthStateSubscription() {
    _authStateSubscription?.cancel();
    _authStateSubscription = null;
  }

  @override
  Future<void> close() {
    _cancelLockoutTimer();
    _cancelAuthStateSubscription();
    return super.close();
  }
}
