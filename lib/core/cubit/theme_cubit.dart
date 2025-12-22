import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'theme_state.dart';

/// Cubit for managing app-wide theme state
@lazySingleton
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  /// Toggle between light and dark mode
  void toggleTheme() {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(state.copyWith(themeMode: newMode));
  }

  /// Set theme to light mode
  void setLightMode() {
    emit(state.copyWith(themeMode: ThemeMode.light));
  }

  /// Set theme to dark mode
  void setDarkMode() {
    emit(state.copyWith(themeMode: ThemeMode.dark));
  }

  /// Set theme to system mode
  void setSystemMode() {
    emit(state.copyWith(themeMode: ThemeMode.system));
  }

  /// Set theme mode directly
  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }
}
