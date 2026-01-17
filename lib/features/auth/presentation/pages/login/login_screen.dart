import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../../core/routing/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../widgets/auth_bottom_link.dart';
import '../../widgets/auth_divider.dart';
import '../../widgets/auth_form_field.dart';
import '../../widgets/auth_header_icon.dart';
import '../../widgets/auth_primary_button.dart';
import '../../widgets/auth_social_row.dart';

/// Login screen with email/password authentication.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60.h),
                // Header Icon
                const AuthHeaderIcon(icon: Icons.graphic_eq),
                SizedBox(height: AppDimensions.spacingLg),
                // Title
                Text(
                  'Welcome Back',
                  style: AppTextStyles.headline1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimensions.spacingSm),
                // Subtitle
                Text(
                  'Log in to your AI finance dashboard',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),
                // Email Field
                AuthFormField(
                  controller: _emailController,
                  label: 'Email Address',
                  hintText: 'alex@example.com',
                  prefixIcon: Icons.mail_outline,
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
                // Password Field with Forgot Password link
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Password',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              context.pushNamed(RoutesNames.forgotPassword),
                          child: Text(
                            'Forgot Password?',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    AuthFormField(
                      controller: _passwordController,
                      hintText: '••••••••',
                      prefixIcon: Icons.lock_outline,
                      isPasswordField: true,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                // Login Button
                AuthPrimaryButton(
                  label: 'Log In',
                  showArrow: true,
                  isLoading: _isLoading,
                  onPressed: _handleLogin,
                ),
                SizedBox(height: AppDimensions.spacingLg),
                // Divider
                const AuthDivider(text: 'Or continue with'),
                SizedBox(height: AppDimensions.spacingLg),
                // Social Auth Row
                AuthSocialRow(
                  onGoogleTap: () {
                    // TODO: Implement Google sign in
                    context.goNamed(RoutesNames.main);
                  },
                  onAppleTap: () {
                    // TODO: Implement Apple sign in
                    context.goNamed(RoutesNames.main);
                  },
                ),
                SizedBox(height: 48.h),
                // Bottom Link
                AuthBottomLink(
                  prefixText: "Don't have an account?",
                  linkText: 'Sign up',
                  onLinkTap: () => context.pushNamed(RoutesNames.signup),
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
