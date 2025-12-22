import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resposive_xx/responsive_x.dart';

import 'app_colors.dart';

/// Centralized typography definitions using Google Fonts Spline Sans.
abstract class AppTextStyles {
  // Headlines
  static TextStyle get headline1 => GoogleFonts.splineSans(
    fontSize: 36.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
    height: 1.1,
    letterSpacing: -0.5,
  );

  static TextStyle get headline2 => GoogleFonts.splineSans(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
    height: 1.2,
  );

  static TextStyle get headline3 => GoogleFonts.splineSans(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  // Body
  static TextStyle get bodyLarge => GoogleFonts.splineSans(
    fontSize: 17.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static TextStyle get bodyMedium => GoogleFonts.splineSans(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral500,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.splineSans(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.neutral500,
  );

  // Button
  static TextStyle get buttonText => GoogleFonts.splineSans(
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  // Caption
  static TextStyle get caption => GoogleFonts.splineSans(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.neutral400,
  );
}
