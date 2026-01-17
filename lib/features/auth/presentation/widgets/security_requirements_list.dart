import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A single security requirement item with check/uncheck status.
class SecurityRequirementItem extends StatelessWidget {
  const SecurityRequirementItem({
    super.key,
    required this.text,
    required this.isMet,
  });

  final String text;
  final bool isMet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Container(
            width: 20.r,
            height: 20.r,
            decoration: BoxDecoration(
              color: isMet ? AppColors.positive : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isMet ? AppColors.positive : AppColors.neutral400,
                width: 1.5,
              ),
            ),
            child: isMet
                ? Icon(Icons.check, size: 12.r, color: Colors.white)
                : null,
          ),
          SizedBox(width: 12.w),
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: isMet ? AppColors.textDark : AppColors.neutral500,
            ),
          ),
        ],
      ),
    );
  }
}

/// List of password security requirements with check/uncheck icons.
class SecurityRequirementsList extends StatelessWidget {
  const SecurityRequirementsList({super.key, required this.requirements});

  /// Map of requirement text to whether it is met
  final Map<String, bool> requirements;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SECURITY REQUIREMENTS',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.positive,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8.h),
        ...requirements.entries.map(
          (entry) =>
              SecurityRequirementItem(text: entry.key, isMet: entry.value),
        ),
      ],
    );
  }
}
