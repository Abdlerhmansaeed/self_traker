import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/theme/app_colors.dart';

/// Circular back button for auth screen navigation.
class AuthBackButton extends StatelessWidget {
  const AuthBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onPressed ?? () => context.pop(),
      child: Container(
        width: 40.r,
        height: 40.r,
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.surfaceDark : AppColors.cardLight,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDarkMode
                ? AppColors.neutral500.withOpacity(0.2)
                : AppColors.neutral400.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back,
            size: 20.r,
            color: isDarkMode ? AppColors.textLight : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
