import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../../core/routing/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../widgets/auth_back_button.dart';
import '../../widgets/auth_form_field.dart';
import '../../widgets/auth_header_icon.dart';
import '../../widgets/auth_primary_button.dart';
import '../../widgets/password_strength_indicator.dart';
import '../../widgets/security_requirements_list.dart';

/// Reset password screen with new password, strength indicator, and requirements.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  int _passwordStrength = 0;
  Map<String, bool> _requirements = {
    'At least 8 characters': false,
    'Contains a number or symbol': false,
    'Contains uppercase letter': false,
  };

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength(String password) {
    int strength = 0;
    final hasMinLength = password.length >= 8;
    final hasNumberOrSymbol = RegExp(
      r'[0-9!@#$%^&*(),.?":{}|<>]',
    ).hasMatch(password);
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));

    if (hasMinLength) strength++;
    if (hasNumberOrSymbol) strength++;
    if (hasUppercase) strength++;

    setState(() {
      _passwordStrength = strength;
      _requirements = {
        'At least 8 characters': hasMinLength,
        'Contains a number or symbol': hasNumberOrSymbol,
        'Contains uppercase letter': hasUppercase,
      };
    });
  }

  void _handleResetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
        return;
      }
      setState(() => _isLoading = true);
      // TODO: Integrate with auth cubit to reset password
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset successfully!')),
          );
          context.goNamed(RoutesNames.login);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppDimensions.spacingMd),
                // Back Button
                const AuthBackButton(),
                SizedBox(height: AppDimensions.spacingMd),
                // Header Icon
                AuthHeaderIcon(
                  icon: Icons.timer_outlined,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  iconColor: AppColors.primary,
                ),
                SizedBox(height: AppDimensions.spacingLg),
                // Title
                Text('Reset Password', style: AppTextStyles.headline1),
                SizedBox(height: AppDimensions.spacingSm),
                // Subtitle
                Text(
                  'Create a strong, unique password to secure your financial data.',
                  style: AppTextStyles.bodyMedium,
                ),
                SizedBox(height: 32.h),
                // New Password Field
                AuthFormField(
                  controller: _passwordController,
                  label: 'New Password',
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_outline,
                  isPasswordField: true,
                  textInputAction: TextInputAction.next,
                  onChanged: _checkPasswordStrength,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppDimensions.spacingSm),
                // Password Strength Indicator
                PasswordStrengthIndicator(strength: _passwordStrength),
                SizedBox(height: AppDimensions.spacingMd),
                // Confirm Password Field
                AuthFormField(
                  controller: _confirmPasswordController,
                  label: 'Confirm New Password',
                  hintText: 'Re-enter your password',
                  prefixIcon: Icons.lock_outline,
                  isPasswordField: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppDimensions.spacingLg),
                // Security Requirements
                SecurityRequirementsList(requirements: _requirements),
                SizedBox(height: 40.h),
                // Reset Password Button
                AuthPrimaryButton(
                  label: 'Reset Password',
                  showArrow: true,
                  isLoading: _isLoading,
                  onPressed: _handleResetPassword,
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
