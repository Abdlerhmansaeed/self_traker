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
import '../../../domain/entities/validation_failure.dart';
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

  /// Convert ValidationFailure to user-friendly error message
  String? _getValidationErrorMessage(ValidationFailure? failure) {
    if (failure == null) return null;

    return switch (failure) {
      EmailEmptyFailure() => 'Please enter your email',
      EmailInvalidFormatFailure() => 'Please enter a valid email address',
      EmailTooLongFailure(:final maxLength) =>
        'Email must be less than $maxLength characters',
      PasswordEmptyFailure() => 'Please enter a password',
      PasswordTooShortFailure(:final minLength) =>
        'Password must be at least $minLength characters',
      PasswordMissingUppercaseFailure() =>
        'Password must contain an uppercase letter',
      PasswordMissingLowercaseFailure() =>
        'Password must contain a lowercase letter',
      PasswordMissingNumberFailure() => 'Password must contain a number',
      DisplayNameEmptyFailure() => 'Please enter your name',
      // ignore: unreachable_switch_case
      DisplayNameEmptyFailure() => 'Please enter your name',
      DisplayNameTooShortFailure() => 'Please enter a valid name',
    };
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
                          final failure = context
                              .read<AuthCubit>()
                              .validateDisplayName(value);
                          return _getValidationErrorMessage(failure);
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
                        validator: (value) {
                          final failure = context
                              .read<AuthCubit>()
                              .validateEmail(value);
                          return _getValidationErrorMessage(failure);
                        },
                      ),
                      SizedBox(height: AppDimensions.spacingMd),
                      // Password Field
                      AuthFormField(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: '********',
                        isPasswordField: true,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          final failure = context
                              .read<AuthCubit>()
                              .validatePassword(value);
                          return _getValidationErrorMessage(failure);
                        },
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
