// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart'
    as _i123;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i17;
import '../../features/auth/domain/usecases/send_password_reset_usecase.dart'
    as _i71;
import '../../features/auth/domain/usecases/send_verification_email_usecase.dart'
    as _i358;
import '../../features/auth/domain/usecases/sign_in_with_email_usecase.dart'
    as _i744;
import '../../features/auth/domain/usecases/sign_in_with_google_usecase.dart'
    as _i673;
import '../../features/auth/domain/usecases/sign_out_usecase.dart' as _i915;
import '../../features/auth/domain/usecases/sign_up_with_email_usecase.dart'
    as _i254;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/home/presentation/cubit/home_cubit.dart' as _i9;
import '../../features/voice_expense/data/data_source/voice_expense_tracker_data_source.dart'
    as _i191;
import '../../features/voice_expense/data/data_source/voice_expense_tracker_data_source_impl.dart'
    as _i986;
import '../../features/voice_expense/presentation/cubit/voice_expense_cubit.dart'
    as _i851;
import '../cubit/theme_cubit.dart' as _i319;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i9.HomeCubit>(() => _i9.HomeCubit());
    gh.lazySingleton<_i319.ThemeCubit>(() => _i319.ThemeCubit());
    gh.factory<_i191.VoiceExpenseTrackerDataSource>(
      () => _i986.VoiceExpenseTrackerDataSourceImpl(),
    );
    gh.factory<_i851.VoiceExpenseCubit>(
      () => _i851.VoiceExpenseCubit(gh<_i191.VoiceExpenseTrackerDataSource>()),
    );
    gh.factory<_i107.AuthRemoteDataSource>(
      () => _i123.AuthRemoteDataSourceImpl(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        firestore: gh<_i974.FirebaseFirestore>(),
        googleSignIn: gh<_i116.GoogleSignIn>(),
      ),
    );
    gh.factory<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(gh<_i107.AuthRemoteDataSource>()),
    );
    gh.factory<_i17.GetCurrentUserUseCase>(
      () => _i17.GetCurrentUserUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i71.SendPasswordResetUseCase>(
      () => _i71.SendPasswordResetUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i358.SendVerificationEmailUseCase>(
      () => _i358.SendVerificationEmailUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i744.SignInWithEmailUseCase>(
      () => _i744.SignInWithEmailUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i673.SignInWithGoogleUseCase>(
      () => _i673.SignInWithGoogleUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i915.SignOutUseCase>(
      () => _i915.SignOutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i254.SignUpWithEmailUseCase>(
      () => _i254.SignUpWithEmailUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i117.AuthCubit>(
      () => _i117.AuthCubit(
        signUpWithEmailUseCase: gh<_i254.SignUpWithEmailUseCase>(),
        sendVerificationEmailUseCase: gh<_i358.SendVerificationEmailUseCase>(),
        signInWithEmailUseCase: gh<_i744.SignInWithEmailUseCase>(),
        signInWithGoogleUseCase: gh<_i673.SignInWithGoogleUseCase>(),
        sendPasswordResetUseCase: gh<_i71.SendPasswordResetUseCase>(),
        getCurrentUserUseCase: gh<_i17.GetCurrentUserUseCase>(),
        signOutUseCase: gh<_i915.SignOutUseCase>(),
      ),
    );
    return this;
  }
}
