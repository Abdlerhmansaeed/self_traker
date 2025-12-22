import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Stats overview section with "Spent Today" and "Daily Limit" cards
class StatsOverview extends StatelessWidget {
  const StatsOverview({
    super.key,
    required this.spentToday,
    required this.dailyLimit,
    required this.spentPercentage,
    this.onSeeAnalyticsTap,
  });

  final String spentToday;
  final String dailyLimit;
  final double spentPercentage; // 0.0 to 1.0
  final VoidCallback? onSeeAnalyticsTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overview',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: onSeeAnalyticsTap,
                child: Text(
                  'See Analytics',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingMd),
        // Stats cards
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.shopping_bag_outlined,
                label: 'Spent Today',
                value: spentToday,
                progressValue: spentPercentage,
                showProgress: true,
              ),
            ),
            SizedBox(width: AppDimensions.spacingMd),
            Expanded(
              child: _StatCard(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Daily Limit',
                value: dailyLimit,
                subtitle: '${((1 - spentPercentage) * 100).toInt()}% remaining',
                accentColor: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    this.progressValue,
    this.showProgress = false,
    this.accentColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final double? progressValue;
  final bool showProgress;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = accentColor ?? AppColors.primary;

    return Container(
      height: 128.h,
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
      child: Stack(
        children: [
          // Accent blur
          Positioned(
            top: -16.r,
            right: -16.r,
            child: Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon + label
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      icon,
                      size: 18.r,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSub,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              // Value + progress/subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: AppTextStyles.headline3.copyWith(fontSize: 22.sp),
                  ),
                  SizedBox(height: 8.h),
                  if (showProgress && progressValue != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: progressValue,
                        backgroundColor: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade100,
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        minHeight: 6.h,
                      ),
                    )
                  else if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSub,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
