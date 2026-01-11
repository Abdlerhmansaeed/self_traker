// import 'dart:nativewrappers/_internal/vm/bin/vmservice_io.dart' as Routes;
//
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resposive_xx/responsive_x.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/social_auth_button.dart';
import '../widgets/wave_image_container.dart';

/// Onboarding screen with voice expense tracker branding.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Section: Visual & Header
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingHorizontal,
                ),
                child: Column(
                  children: [
                    SizedBox(height: AppDimensions.spacingLg),
                    // Wave Image
                    const WaveImageContainer(
                      imagePath: 'assets/images/Wave Image.png',
                    ),
                    SizedBox(height: AppDimensions.spacingLg),
                    // Headline
                    Text(
                      'Speak Your Spend',
                      style: AppTextStyles.headline1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppDimensions.spacingSm),
                    // Subtext
                    Text(
                      'The smartest way to track money using just your voice.',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Section: Actions
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingHorizontal,
              ),
              child: Column(
                children: [
                  SizedBox(height: AppDimensions.spacingMd),
                  // Apple Button (Dark)
                  SocialAuthButton(
                    icon: Icons.apple,
                    label: 'Continue with Apple',
                    isDark: true,
                    onTap: () {
                      context.goNamed(RoutesNames.main);
                    },
                  ),
                  SizedBox(height: AppDimensions.spacingSm + 4.h),
                  // Google Button (Light)
                  SocialAuthButton(
                    icon: Icons.language,
                    label: 'Continue with Google',
                    isDark: false,
                    onTap: () {
                      // TODO: Implement Google Sign In
                    },
                  ),
                  SizedBox(height: AppDimensions.spacingLg),
                  // Terms
                  _buildTermsText(context),
                  SizedBox(height: AppDimensions.spacingLg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsText(BuildContext context) {
    final textStyle = AppTextStyles.caption;
    final linkStyle = AppTextStyles.caption.copyWith(
      decoration: TextDecoration.underline,
      color: AppColors.neutral500,
    );

    return Text.rich(
      TextSpan(
        text: 'By continuing, you agree to our ',
        style: textStyle,
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // TODO: Navigate to Terms of Service
              },
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // TODO: Navigate to Privacy Policy
              },
          ),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
