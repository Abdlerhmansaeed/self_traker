import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../../core/routing/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../widgets/auth_back_button.dart';
import '../../widgets/auth_bottom_link.dart';
import '../../widgets/auth_divider.dart';
import '../../widgets/auth_form_field.dart';
import '../../widgets/auth_primary_button.dart';
import '../../widgets/auth_social_row.dart';

/// Sign up screen with full name, email, and password.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      // TODO: Integrate with auth cubit
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
          context.goNamed(RoutesNames.main);
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
                SizedBox(height: AppDimensions.spacingLg),
                // Title
                Text('Create Account', style: AppTextStyles.headline1),
                SizedBox(height: AppDimensions.spacingSm),
                // Subtitle
                Text(
                  'Start tracking your expenses intelligently.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSub,
                  ),
                ),
                SizedBox(height: 32.h),
                // Full Name Field
                AuthFormField(
                  controller: _nameController,
                  label: 'Full Name',
                  hintText: 'Alex Morgan',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppDimensions.spacingMd),
                // Email Field
                AuthFormField(
                  controller: _emailController,
                  label: 'Email Address',
                  hintText: 'alex@example.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
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
                SizedBox(height: AppDimensions.spacingMd),
                // Password Field
                AuthFormField(
                  controller: _passwordController,
                  label: 'Password',
                  hintText: '••••••••',
                  isPasswordField: true,
                  textInputAction: TextInputAction.done,
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
                SizedBox(height: 32.h),
                // Create Account Button
                AuthPrimaryButton(
                  label: 'Create Account',
                  isLoading: _isLoading,
                  onPressed: _handleSignup,
                ),
                SizedBox(height: AppDimensions.spacingLg),
                // Divider
                const AuthDivider(text: 'Or sign up with'),
                SizedBox(height: AppDimensions.spacingLg),
                // Social Auth Row
                AuthSocialRow(
                  onGoogleTap: () {
                    // TODO: Implement Google sign up
                    context.goNamed(RoutesNames.main);
                  },
                  onAppleTap: () {
                    // TODO: Implement Apple sign up
                    context.goNamed(RoutesNames.main);
                  },
                ),
                SizedBox(height: 48.h),
                // Bottom Link
                Center(
                  child: AuthBottomLink(
                    prefixText: 'Already have an account?',
                    linkText: 'Log In',
                    onLinkTap: () => context.pop(),
                  ),
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
