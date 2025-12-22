import 'package:resposive_xx/responsive_x.dart';

/// Centralized responsive dimension constants.
abstract class AppDimensions {
  // Border Radius
  static double get radiusSm => 8.r;
  static double get radiusMd => 16.r;
  static double get radiusLg => 24.r;
  static double get radiusXl => 32.r;
  static double get radiusFull => 9999.r;

  // Button
  static double get buttonHeight => 52.h;
  static double get buttonHeightSm => 44.h;

  // Spacing
  static double get spacingXs => 4.h;
  static double get spacingSm => 8.h;
  static double get spacingMd => 16.h;
  static double get spacingLg => 24.h;
  static double get spacingXl => 32.h;

  // Padding
  static double get paddingHorizontal => 24.w;
  static double get paddingVertical => 32.h;

  // Icon
  static double get iconSm => 18.r;
  static double get iconMd => 22.r;
  static double get iconLg => 28.r;
}
