import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

/// Configurable social authentication button with icon and text.
class SocialAuthButton extends StatefulWidget {
  const SocialAuthButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDark = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  @override
  State<SocialAuthButton> createState() => _SocialAuthButtonState();
}

class _SocialAuthButtonState extends State<SocialAuthButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Determine colors based on button style and theme
    final backgroundColor = widget.isDark
        ? (isDarkMode ? AppColors.textLight : AppColors.textDark)
        : (isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight);

    final foregroundColor = widget.isDark
        ? (isDarkMode ? AppColors.textDark : AppColors.textLight)
        : (isDarkMode ? AppColors.textLight : AppColors.textDark);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: AppDimensions.buttonHeight,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: widget.isDark
                ? null
                : Border.all(color: Colors.transparent, width: 1),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              onTap: widget.onTap,
              splashColor: AppColors.primary.withOpacity(0.1),
              highlightColor: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: AppDimensions.iconMd,
                    color: foregroundColor,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    widget.label,
                    style: AppTextStyles.buttonText.copyWith(
                      color: foregroundColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
