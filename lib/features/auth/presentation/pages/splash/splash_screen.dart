import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';

/// Splash screen that checks authentication state on app startup
/// Navigates to appropriate screen based on auth state and onboarding status
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check auth state when splash screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().checkAuthState();
    });
  }

  void _navigateBasedOnAuthState(AuthState state) {
    if (state is AuthAuthenticated) {
      // User is authenticated - check onboarding status
      if (state.user.metadata.onboardingCompleted) {
        context.goNamed(RoutesNames.main);
      } else {
        context.goNamed(RoutesNames.onboarding);
      }
    } else if (state is EmailVerificationRequired) {
      // User authenticated but email not verified - go to main with banner
      if (state.user.metadata.onboardingCompleted) {
        context.goNamed(RoutesNames.main);
      } else {
        context.goNamed(RoutesNames.onboarding);
      }
    } else if (state is AuthUnauthenticated) {
      // Not authenticated - show login
      context.goNamed(RoutesNames.login);
    } else if (state is AuthError) {
      // Error occurred - show login with option to retry
      context.goNamed(RoutesNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Navigate when auth state is determined
        if (state is! AuthCheckingState &&
            state is! AuthInitial &&
            state is! AuthLoading) {
          _navigateBasedOnAuthState(state);
        }
      },
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo or icon
              Icon(
                Icons.account_balance_wallet,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              // App name
              Text(
                'Self Tracker',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 48),
              // Loading indicator
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
