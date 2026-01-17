import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../widgets/auth_back_button.dart';
import '../../widgets/auth_bottom_link.dart';
import '../../widgets/auth_form_field.dart';
import '../../widgets/auth_header_icon.dart';
import '../../widgets/auth_primary_button.dart';

/// Forgot password screen with email input.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendResetLink() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      // TODO: Integrate with auth cubit to send reset link
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
          // Show success message or navigate to reset password
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reset link sent! Check your email.')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingHorizontal,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppDimensions.spacingMd),
                // Back Button (aligned left)
                Align(
                  alignment: Alignment.centerLeft,
                  child: const AuthBackButton(),
                ),
                SizedBox(height: 40.h),
                // Header Icon with accent
                const AuthHeaderIcon(
                  icon: Icons.lock_reset_outlined,
                  showAccent: true,
                ),
                SizedBox(height: AppDimensions.spacingLg),
                // Title
                Text(
                  'Forgot Password?',
                  style: AppTextStyles.headline1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimensions.spacingSm),
                // Subtitle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "Don't worry! It happens. Please enter the email associated with your account.",
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 40.h),
                // Email Field
                AuthFormField(
                  controller: _emailController,
                  label: 'Email Address',
                  hintText: 'alex@example.com',
                  prefixIcon: Icons.alternate_email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.h),
                // Send Reset Link Button
                AuthPrimaryButton(
                  label: 'Send Reset Link',
                  isLoading: _isLoading,
                  onPressed: _handleSendResetLink,
                ),
                SizedBox(height: 40.h),
                // Bottom Link
                AuthBottomLink(
                  prefixText: 'Remember your password?',
                  linkText: 'Log in',
                  onLinkTap: () => context.pop(),
                ),
                SizedBox(height: AppDimensions.spacingLg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
