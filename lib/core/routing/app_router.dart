import 'package:go_router/go_router.dart';
import 'package:self_traker/features/auth/presentation/pages/forgot_password/forgot_password_screen.dart';
import 'package:self_traker/features/auth/presentation/pages/login/login_screen.dart';
import 'package:self_traker/features/auth/presentation/pages/reset_password/reset_password_screen.dart';
import 'package:self_traker/features/auth/presentation/pages/signup/signup_screen.dart';
import 'package:self_traker/features/notifications/UI/notification_screen.dart';

import '../../features/app_layout/main_layout/main_layout.dart';
import '../../features/onboarding/UI/onboarding_screen.dart';

/// Route paths constants
abstract class RoutesNames {
  static const String onboarding = '/onboarding';
  static const String main = '/main';
  static const String notifications = '/notifications';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
}

/// App router configuration using GoRouter
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RoutesNames.onboarding,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RoutesNames.onboarding,
        name: RoutesNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutesNames.main,
        name: RoutesNames.main,
        builder: (context, state) => const MainLayout(),
      ),
      GoRoute(
        path: RoutesNames.notifications,
        name: RoutesNames.notifications,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: RoutesNames.login,
        name: RoutesNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutesNames.signup,
        name: RoutesNames.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RoutesNames.forgotPassword,
        name: RoutesNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RoutesNames.resetPassword,
        name: RoutesNames.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
    ],
  );
}
