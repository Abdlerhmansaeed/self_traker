import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Balance card showing total balance with trend indicator and mini chart
class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.balance,
    required this.percentageChange,
    this.isPositive = true,
  });

  final String balance;
  final String percentageChange;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.spacingLg),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSub,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    balance,
                    style: AppTextStyles.headline1.copyWith(fontSize: 32.sp),
                  ),
                ],
              ),
              // Trend indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: (isPositive ? AppColors.positive : AppColors.negative)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 14.r,
                      color: isPositive
                          ? AppColors.positive
                          : AppColors.negative,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      percentageChange,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: isPositive
                            ? AppColors.positive
                            : AppColors.negative,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacingMd),
          // Mini chart
          _buildMiniChart(isDark),
        ],
      ),
    );
  }

  Widget _buildMiniChart(bool isDark) {
    final barData = [0.4, 0.6, 0.3, 0.8, 0.5, 0.7, 0.45];
    final highlightIndex = 3;

    return SizedBox(
      height: 48.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(barData.length, (index) {
          final isHighlight = index == highlightIndex;
          return Container(
            width: 36.w,
            height: (barData[index] * 48).h,
            decoration: BoxDecoration(
              color: isHighlight
                  ? AppColors.primary.withOpacity(0.8)
                  : (isDark
                        ? Colors.grey.shade700
                        : AppColors.textSub.withOpacity(0.2)),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.r),
                topRight: Radius.circular(4.r),
              ),
            ),
          );
        }),
      ),
    );
  }
}
