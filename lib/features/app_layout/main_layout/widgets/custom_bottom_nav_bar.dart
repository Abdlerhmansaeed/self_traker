import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';
import 'package:self_traker/core/theme/app_colors.dart';

// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/app_dimensions.dart';

/// Custom bottom navigation bar with center FAB cutout
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onFabPressed,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onFabPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            offset: const Offset(0, -5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Navigation items
          Row(
            children: [
              _buildNavItem(
                context,
                index: 0,
                icon: Icons.home,
                filledIcon: Icons.home,
                label: 'Home',
              ),
              _buildNavItem(
                context,
                index: 1,
                icon: Icons.insert_chart_outlined,
                filledIcon: Icons.insert_chart,
                label: 'Analytics',
              ),
              // Center spacer for FAB
              const Spacer(),
              _buildNavItem(
                context,
                index: 2,
                icon: Icons.account_balance_wallet_outlined,
                filledIcon: Icons.account_balance_wallet,
                label: 'Budget',
              ),
              _buildNavItem(
                context,
                index: 3,
                icon: Icons.settings_outlined,
                filledIcon: Icons.settings,
                label: 'Settings',
              ),
            ],
          ),
          // Center FAB
          Positioned(
            top: -28.h,
            left: 0,
            right: 0,
            child: Center(child: _buildFab(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData filledIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final color = isSelected
        ? (isDark ? AppColors.textLight : AppColors.textDark)
        : AppColors.textSub;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? filledIcon : icon, color: color, size: 24.r),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return GestureDetector(
      onTap: onFabPressed,
      child: Container(
        width: 64.r,
        height: 64.r,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: -5,
            ),
          ],
        ),
        child: Icon(Icons.graphic_eq, size: 32.r, color: AppColors.textDark),
      ),
    );
  }
}
