import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Side-by-side Google and Apple buttons for Login/Signup screens.
class AuthSocialRow extends StatelessWidget {
  const AuthSocialRow({
    super.key,
    required this.onGoogleTap,
    required this.onAppleTap,
  });

  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SocialButton(
            icon: 'G',
            label: 'Google',
            onTap: onGoogleTap,
            isGoogle: true,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _SocialButton(
            icon: '',
            label: 'Apple',
            onTap: onAppleTap,
            isGoogle: false,
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isGoogle,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isGoogle;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? AppColors.surfaceDark : AppColors.cardLight;
    final borderColor = isDarkMode
        ? AppColors.neutral500.withOpacity(0.2)
        : AppColors.neutral400.withOpacity(0.3);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimensions.buttonHeight,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isGoogle)
              Text(
                'G',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              )
            else
              Icon(
                Icons.apple,
                size: AppDimensions.iconMd,
                color: isDarkMode ? AppColors.textLight : AppColors.textDark,
              ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: isDarkMode ? AppColors.textLight : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
