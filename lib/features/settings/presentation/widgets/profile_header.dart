import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Profile header widget with avatar, name, badge, and email
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.badge,
    this.onEditTap,
  });

  final String name;
  final String email;
  final String? avatarUrl;
  final String? badge;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingLg),
      child: Column(
        children: [
          // Avatar with edit button
          GestureDetector(
            onTap: onEditTap,
            child: Stack(
              children: [
                Container(
                  width: 112.r,
                  height: 112.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: avatarUrl != null
                        ? Image.network(
                            avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                          )
                        : _buildDefaultAvatar(),
                  ),
                ),
                // Edit button
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 16.r,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.spacingMd),
          // Name
          Text(
            name,
            style: AppTextStyles.headline2,
            textAlign: TextAlign.center,
          ),
          // Badge
          if (badge != null) ...[
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                badge!.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.primary : AppColors.textDark,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
          SizedBox(height: 8.h),
          // Email
          Text(
            email,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSub),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.surfaceLight,
      child: Icon(Icons.person, size: 48.r, color: AppColors.textSub),
    );
  }
}
