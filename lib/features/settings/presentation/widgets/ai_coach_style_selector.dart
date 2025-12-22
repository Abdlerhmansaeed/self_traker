import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/settings_cubit.dart';

/// AI Coach style selector widget
class AiCoachStyleSelector extends StatelessWidget {
  const AiCoachStyleSelector({
    super.key,
    required this.selectedStyle,
    required this.onStyleChanged,
  });

  final AiCoachStyle selectedStyle;
  final ValueChanged<AiCoachStyle> onStyleChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: AiCoachStyle.values.map((style) {
          final isSelected = style == selectedStyle;
          return Expanded(
            child: GestureDetector(
              onTap: () => onStyleChanged(style),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? AppColors.cardDark : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  _getStyleLabel(style),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? AppColors.textLight : AppColors.textDark)
                        : AppColors.textSub,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getStyleLabel(AiCoachStyle style) {
    switch (style) {
      case AiCoachStyle.strict:
        return 'Strict';
      case AiCoachStyle.balanced:
        return 'Balanced';
      case AiCoachStyle.friendly:
        return 'Friendly';
    }
  }
}
