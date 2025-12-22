import 'package:flutter/material.dart';

/// Centralized app color constants for consistent theming.
abstract class AppColors {
  // Primary
  static const Color primary = Color(0xFFF9F506);

  // Background
  static const Color backgroundLight = Color(0xFFF8F8F5);
  static const Color backgroundDark = Color(0xFF23220F);

  // Text
  static const Color textDark = Color(0xFF181811);
  static const Color textLight = Color(0xFFFFFFFF);

  // Neutral
  static const Color neutral400 = Color(0xFF9CA3AF);
  static const Color neutral500 = Color(0xFF6B7280);

  // Surface
  static const Color surfaceLight = Color(0xFFF5F5F0);
  static const Color surfaceDark = Color(0xFF2C2C2C);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1A1A1A);

  // Overlay
  static const Color primaryOverlay = Color(0x1AF9F506); // 10% opacity

  // Glow
  static const Color glowColor = Color(0x66F9F506); // 40% opacity

  // Semantic colors
  static const Color positive = Color(0xFF22C55E);
  static const Color negative = Color(0xFFEF4444);

  // Text
  static const Color textSub = Color(0xFF8C8B5F);

  // Icon backgrounds
  static const Color iconBgLight = Color(0xFFF4F2EE);
  static const Color iconBgDark = Color(0xFF3A392A);
  static const Color iconBgPositive = Color(0xFFECFDF5);
  static const Color iconBgPositiveDark = Color(0xFF1E3A2F);
}
