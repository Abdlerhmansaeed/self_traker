import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/theme/app_colors.dart';

/// Reusable circular icon widget for auth screen headers.
/// Used for voice waveform icon on login, lock icon on forgot/reset password.
class AuthHeaderIcon extends StatelessWidget {
  const AuthHeaderIcon({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.size,
    this.iconSize,
    this.showAccent = false,
  });

  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;
  final double? iconSize;
  final bool showAccent;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        backgroundColor ??
        (isDarkMode ? AppColors.surfaceDark : AppColors.cardLight);
    final fgColor = iconColor ?? AppColors.primary;
    final containerSize = size ?? 60.r;
    final icSize = iconSize ?? 28.r;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.glowColor.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, size: icSize, color: fgColor),
          ),
        ),
        if (showAccent)
          Positioned(
            top: -4.r,
            right: -4.r,
            child: Container(
              width: 12.r,
              height: 12.r,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
