import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Password strength indicator with multi-segment bar.
/// Shows weak/medium/strong password strength.
class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({super.key, required this.strength});

  /// 0 = empty, 1 = weak, 2 = medium, 3 = strong
  final int strength;

  @override
  Widget build(BuildContext context) {
    String label;
    Color labelColor;

    switch (strength) {
      case 0:
        label = '';
        labelColor = AppColors.neutral500;
        break;
      case 1:
        label = 'Weak strength';
        labelColor = AppColors.negative;
        break;
      case 2:
        label = 'Medium strength';
        labelColor = Colors.orange;
        break;
      case 3:
        label = 'Strong strength';
        labelColor = AppColors.positive;
        break;
      default:
        label = '';
        labelColor = AppColors.neutral500;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            Color segmentColor;
            if (index < strength) {
              switch (strength) {
                case 1:
                  segmentColor = AppColors.negative;
                  break;
                case 2:
                  segmentColor = Colors.orange;
                  break;
                case 3:
                  segmentColor = AppColors.positive;
                  break;
                default:
                  segmentColor = AppColors.neutral400.withOpacity(0.3);
              }
            } else {
              segmentColor = AppColors.neutral400.withOpacity(0.3);
            }

            return Expanded(
              child: Container(
                height: 4.h,
                margin: EdgeInsets.only(right: index < 3 ? 4.w : 0),
                decoration: BoxDecoration(
                  color: segmentColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            );
          }),
        ),
        if (label.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, size: 14.r, color: labelColor),
              SizedBox(width: 4.w),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
