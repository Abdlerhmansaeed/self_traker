import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:resposive_xx/responsive_x.dart';
import 'package:self_traker/features/auth/domain/extensions/auth_failure_localization.dart';

import '../../../../../core/routing/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';
// import '../../domain/extensions/auth_failure_localization.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  void _handleGoogleSignIn(BuildContext context) {
    context.read<AuthCubit>().signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.goNamed(RoutesNames.main);
        } else if (state is AuthRateLimited) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Too many attempts. Please wait ${state.remainingSeconds} seconds.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.getLocalizedMessage(context)),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is EmailVerificationRequired) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please verify your email to continue.'),
            ),
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final remainingSeconds = (state is AuthRateLimited)
              ? (state).remainingSeconds
              : 0;

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
                      // Rate limit warning
                      if (state is AuthRateLimited)
                        Container(
                          padding: EdgeInsets.all(AppDimensions.spacingMd),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Too many failed attempts. Please wait $remainingSeconds seconds.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      if (state is AuthRateLimited)
                        SizedBox(height: AppDimensions.spacingMd),
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
                                onTap: () => context.pushNamed(
                                  RoutesNames.forgotPassword,
                                ),
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
                        isLoading: isLoading,
                        onPressed: (!isLoading && state is! AuthRateLimited)
                            ? () => _handleLogin(context)
                            : null,
                      ),
                      SizedBox(height: AppDimensions.spacingLg),
                      // Divider
                      const AuthDivider(text: 'Or continue with'),
                      SizedBox(height: AppDimensions.spacingLg),
                      // Social Auth Row
                      AuthSocialRow(
                        onGoogleTap: () => _handleGoogleSignIn(context),
                        onAppleTap: () {}, // Not supported yet
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
        },
      ),
    );
  }
}
