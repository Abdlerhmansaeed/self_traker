import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Smart suggestion card with image background
class SmartSuggestionCard extends StatelessWidget {
  const SmartSuggestionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.goalName,
    this.imageUrl,
    this.onViewPlanTap,
  });

  final String title;
  final String subtitle;
  final String goalName;
  final String? imageUrl;
  final VoidCallback? onViewPlanTap;

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
            child: Text('Smart Suggestions', style: AppTextStyles.headline3),
          ),
          // Card
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                // Image section
                Container(
                  height: 160.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary.withOpacity(0.3),
                        AppColors.primary.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (imageUrl != null)
                        Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholder(),
                        )
                      else
                        _buildPlaceholder(),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                      // Text content
                      Positioned(
                        left: AppDimensions.spacingLg,
                        right: AppDimensions.spacingLg,
                        bottom: AppDimensions.spacingLg,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              subtitle,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Footer
                Padding(
                  padding: EdgeInsets.all(AppDimensions.spacingMd),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.savings,
                            size: 20.r,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Goal: $goalName',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: onViewPlanTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? AppColors.cardLight
                              : AppColors.textDark,
                          foregroundColor: isDark
                              ? AppColors.textDark
                              : AppColors.textLight,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull,
                            ),
                          ),
                        ),
                        child: Text(
                          'View Plan',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.4),
            Colors.green.withOpacity(0.3),
            Colors.blue.withOpacity(0.2),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.savings,
          size: 60.r,
          color: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}
