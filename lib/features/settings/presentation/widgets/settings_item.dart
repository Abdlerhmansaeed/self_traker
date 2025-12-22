import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Trailing type for settings item
enum SettingsItemTrailing { chevron, toggle, custom }

/// Reusable settings item widget
class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconBackgroundColor,
    this.iconColor,
    this.trailing = SettingsItemTrailing.chevron,
    this.trailingText,
    this.toggleValue = false,
    this.onToggleChanged,
    this.customTrailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final SettingsItemTrailing trailing;
  final String? trailingText;
  final bool toggleValue;
  final ValueChanged<bool>? onToggleChanged;
  final Widget? customTrailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final bgColor =
        iconBackgroundColor ??
        (isDark ? Colors.grey.shade800 : Colors.grey.shade100);
    final iColor =
        iconColor ?? (isDark ? AppColors.textLight : AppColors.textDark);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMd,
          vertical: 14.h,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, size: 20.r, color: iColor),
            ),
            SizedBox(width: AppDimensions.spacingMd),
            // Title & subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSub,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Trailing
            _buildTrailing(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailing(BuildContext context, bool isDark) {
    switch (trailing) {
      case SettingsItemTrailing.chevron:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null)
              Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Text(
                  trailingText!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSub,
                  ),
                ),
              ),
            Icon(Icons.chevron_right, size: 20.r, color: AppColors.textSub),
          ],
        );
      case SettingsItemTrailing.toggle:
        return _CustomToggle(value: toggleValue, onChanged: onToggleChanged);
      case SettingsItemTrailing.custom:
        return customTrailing ?? const SizedBox.shrink();
    }
  }
}

/// Custom toggle switch matching the design
class _CustomToggle extends StatelessWidget {
  const _CustomToggle({required this.value, this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50.w,
        height: 30.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: value
              ? AppColors.primary
              : (isDark ? Colors.grey.shade700 : Colors.grey.shade200),
        ),
        padding: EdgeInsets.all(4.r),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22.r,
            height: 22.r,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
