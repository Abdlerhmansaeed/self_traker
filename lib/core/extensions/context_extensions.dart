import 'package:flutter/material.dart';

/// Extension on BuildContext for common theme utilities
extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  /// Check if dark mode is currently active
  bool get isDark => theme.brightness == Brightness.dark;

  /// Check if light mode is currently active
  bool get isLight => theme.brightness == Brightness.light;

  /// Get the current theme data

  /// Get the current color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get the current text theme
  TextTheme get textTheme => theme.textTheme;
}
