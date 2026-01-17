import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Bottom text with clickable link for auth screen navigation.
/// Example: "Already have an account? Log In"
class AuthBottomLink extends StatelessWidget {
  const AuthBottomLink({
    super.key,
    required this.prefixText,
    required this.linkText,
    required this.onLinkTap,
  });

  final String prefixText;
  final String linkText;
  final VoidCallback onLinkTap;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: prefixText,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral500),
        children: [
          const TextSpan(text: '  '),
          TextSpan(
            text: linkText,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()..onTap = onLinkTap,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
