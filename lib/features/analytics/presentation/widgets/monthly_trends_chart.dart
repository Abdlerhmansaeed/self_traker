import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Monthly data point for bar chart
class MonthlyData {
  const MonthlyData({
    required this.month,
    required this.value,
    this.isActive = false,
  });

  final String month;
  final double value; // 0.0 to 1.0
  final bool isActive;
}

/// Monthly trends bar chart widget
class MonthlyTrendsChart extends StatelessWidget {
  const MonthlyTrendsChart({super.key, required this.data, this.activeLabel});

  final List<MonthlyData> data;
  final String? activeLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingHorizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: EdgeInsets.only(
              left: 4.w,
              bottom: AppDimensions.spacingMd,
            ),
            child: Text('Monthly Trends', style: AppTextStyles.headline3),
          ),
          // Chart container
          Container(
            padding: EdgeInsets.all(AppDimensions.spacingLg),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              ),
            ),
            child: SizedBox(
              height: 180.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: data
                    .map((item) => _buildBar(context, item, isDark))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(BuildContext context, MonthlyData item, bool isDark) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Tooltip for active bar
            if (item.isActive && activeLabel != null)
              Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardLight : AppColors.textDark,
                  borderRadius: BorderRadius.circular(6.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  activeLabel!,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
              ),
            // Bar
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: item.isActive
                      ? AppColors.primary.withOpacity(0.1)
                      : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: item.value,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: item.isActive
                          ? AppColors.primary
                          : (isDark
                                ? Colors.grey.shade600
                                : Colors.grey.shade300),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                      boxShadow: item.isActive
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.5),
                                blurRadius: 15,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            // Label
            Text(
              item.month,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: item.isActive ? FontWeight.bold : FontWeight.w500,
                color: item.isActive
                    ? (isDark ? AppColors.textLight : AppColors.textDark)
                    : AppColors.textSub,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
