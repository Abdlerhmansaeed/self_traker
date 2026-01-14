import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Data model for a transaction
class TransactionData {
  const TransactionData({
    required this.title,
    required this.subtitle,
    required this.amount,
     this.icon,
    this.isPositive = false,
  });

  final String title;
  final String subtitle;
  final String amount;
  final IconData? icon;
  final bool isPositive;
}

/// Reusable transaction item widget
class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.data, this.onTap});

  final TransactionData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.spacingMd),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: data.isPositive
                    ? (isDark
                          ? AppColors.iconBgPositiveDark
                          : AppColors.iconBgPositive)
                    : (isDark ? AppColors.iconBgDark : AppColors.iconBgLight),
                shape: BoxShape.circle,
              ),
              child: Icon(
                data.icon,
                size: 24.r,
                color: data.isPositive
                    ? AppColors.positive
                    : (isDark ? AppColors.textLight : AppColors.textDark),
              ),
            ),
            SizedBox(width: AppDimensions.spacingMd),
            // Title & subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    data.subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSub,
                    ),
                  ),
                ],
              ),
            ),
            // Amount
            Text(
              data.amount,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: data.isPositive
                    ? AppColors.positive
                    : (isDark ? AppColors.textLight : AppColors.textDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
