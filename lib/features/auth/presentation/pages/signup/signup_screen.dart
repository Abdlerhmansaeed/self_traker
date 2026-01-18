import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../../core/routing/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';
import '../../../domain/extensions/auth_failure_localization.dart';
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

  // Regex patterns for validation
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
  );

  static final _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignup(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        displayName: _nameController.text.trim(),
      );
    }
  }

  void _handleGoogleSignUp(BuildContext context) {
    context.read<AuthCubit>().signInWithGoogle();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (value.length > 320) {
      return 'Email must be less than 320 characters';
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!_passwordRegex.hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, and number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Navigate to home screen
          context.goNamed(RoutesNames.main);
        } else if (state is EmailVerificationRequired) {
          // Navigate to verification screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Verification email sent. Please check your inbox.',
              ),
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.getLocalizedMessage(context)),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;

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
                        hintText: 'user name',
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
                        hintText: 'email',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: _validateEmail,
                      ),
                      SizedBox(height: AppDimensions.spacingMd),
                      // Password Field
                      AuthFormField(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: '********',
                        isPasswordField: true,
                        textInputAction: TextInputAction.done,
                        validator: _validatePassword,
                      ),
                      SizedBox(height: 8.h),
                      // Password requirements hint
                      Text(
                        'Min 8 characters, 1 uppercase, 1 lowercase, 1 number',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSub,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      // Create Account Button
                      AuthPrimaryButton(
                        label: 'Create Account',
                        isLoading: isLoading,
                        onPressed: !isLoading
                            ? () => _handleSignup(context)
                            : null,
                      ),
                      SizedBox(height: AppDimensions.spacingLg),
                      // Divider
                      const AuthDivider(text: 'Or sign up with'),
                      SizedBox(height: AppDimensions.spacingLg),
                      // Social Auth Row
                      AuthSocialRow(
                        onGoogleTap: () => _handleGoogleSignUp(context),
                        onAppleTap: () {}, // Not supported yet
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
        },
      ),
    );
  }
}
