part of 'theme_cubit.dart';

/// State for app theme management
class ThemeState extends Equatable {
  const ThemeState({this.themeMode = ThemeMode.light});

  final ThemeMode themeMode;

  /// Check if dark mode is enabled
  bool get isDarkMode => themeMode == ThemeMode.dark;

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }

  @override
  List<Object> get props => [themeMode];
}
