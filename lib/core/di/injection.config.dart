// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/home/presentation/cubit/home_cubit.dart' as _i9;
import '../../features/voice_expense/cubit/voice_expense_cubit.dart' as _i627;
import '../cubit/theme_cubit.dart' as _i319;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i627.VoiceExpenseCubit>(() => _i627.VoiceExpenseCubit());
    gh.singleton<_i9.HomeCubit>(() => _i9.HomeCubit());
    gh.lazySingleton<_i319.ThemeCubit>(() => _i319.ThemeCubit());
    return this;
  }
}
