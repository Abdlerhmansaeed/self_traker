import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

/// Reusable wave image container with glow effect and gradient overlay.
class WaveImageContainer extends StatelessWidget {
  const WaveImageContainer({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.glowColor,
            blurRadius: 60.r,
            spreadRadius: -15.r,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Main Image
            Image.asset(imagePath, fit: BoxFit.cover),
            // Primary color overlay
            Container(
              decoration: const BoxDecoration(color: AppColors.primaryOverlay),
            ),
            // Gradient overlay for blending
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
