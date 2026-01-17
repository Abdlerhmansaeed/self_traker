import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Yellow primary CTA button for auth screens.
/// Supports loading state and optional trailing arrow icon.
class AuthPrimaryButton extends StatefulWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.showArrow = false,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool showArrow;
  final bool isLoading;

  @override
  State<AuthPrimaryButton> createState() => _AuthPrimaryButtonState();
}

class _AuthPrimaryButtonState extends State<AuthPrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: AppDimensions.buttonHeight,
          decoration: BoxDecoration(
            color: widget.onPressed == null
                ? AppColors.primary.withOpacity(0.5)
                : AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            boxShadow: widget.onPressed != null
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.textDark,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.label,
                        style: AppTextStyles.buttonText.copyWith(
                          color: AppColors.textDark,
                        ),
                      ),
                      if (widget.showArrow) ...[
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.arrow_forward,
                          size: AppDimensions.iconSm,
                          color: AppColors.textDark,
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
