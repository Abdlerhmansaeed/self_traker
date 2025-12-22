import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Category data for spending breakdown
class CategoryData {
  const CategoryData({
    required this.name,
    required this.amount,
    required this.percentage,
    required this.icon,
    this.color,
  });

  final String name;
  final double amount;
  final double percentage;
  final IconData icon;
  final Color? color;
}

/// Spending chart card with donut chart and category breakdown
class SpendingChartCard extends StatelessWidget {
  const SpendingChartCard({
    super.key,
    required this.totalSpent,
    required this.percentageChange,
    required this.isPositive,
    required this.categories,
    required this.topCategory,
    this.onViewBreakdownTap,
  });

  final String totalSpent;
  final String percentageChange;
  final bool isPositive;
  final List<CategoryData> categories;
  final String topCategory;
  final VoidCallback? onViewBreakdownTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingHorizontal),
      padding: EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        ),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Spent',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSub,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    totalSpent,
                    style: AppTextStyles.headline2.copyWith(fontSize: 28.sp),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: (isPositive ? AppColors.negative : AppColors.positive)
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
                          ? AppColors.negative
                          : AppColors.positive,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      percentageChange,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: isPositive
                            ? AppColors.negative
                            : AppColors.positive,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacingLg),
          // Donut Chart
          SizedBox(
            height: 200.r,
            width: 200.r,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(200.r, 200.r),
                  painter: _DonutChartPainter(
                    categories: categories,
                    isDark: isDark,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Top Category', style: AppTextStyles.caption),
                    SizedBox(height: 4.h),
                    Text(
                      topCategory,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${categories.first.percentage.toInt()}%',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.spacingLg),
          // Category list
          ...categories.map((cat) => _CategoryItem(category: cat)),
          SizedBox(height: AppDimensions.spacingMd),
          // View breakdown button
          TextButton(
            onPressed: onViewBreakdownTap,
            child: Text(
              'View Full Breakdown',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category});

  final CategoryData category;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isFirst = category.color == AppColors.primary;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: isFirst
                  ? AppColors.primary.withOpacity(0.2)
                  : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
              shape: BoxShape.circle,
            ),
            child: Icon(
              category.icon,
              size: 20.r,
              color: isFirst
                  ? (isDark ? Colors.yellow.shade200 : AppColors.textDark)
                  : (isDark ? AppColors.textLight : AppColors.textDark),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${category.percentage.toInt()}% of total',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Text(
            '\$${category.amount.toStringAsFixed(2)}',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  _DonutChartPainter({required this.categories, required this.isDark});

  final List<CategoryData> categories;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 14.0;

    // Background circle
    final bgPaint = Paint()
      ..color = isDark ? Colors.grey.shade800 : Colors.grey.shade100
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Draw segments
    double startAngle = -math.pi / 2;
    final colors = [
      AppColors.primary,
      isDark ? Colors.grey.shade400 : Colors.grey.shade800,
      isDark ? Colors.grey.shade600 : Colors.grey.shade300,
    ];

    for (var i = 0; i < categories.length && i < 3; i++) {
      final sweepAngle = (categories[i].percentage / 100) * 2 * math.pi;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle - 0.05,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
