import 'package:go_router/go_router.dart';
import 'package:self_traker/features/notifications/UI/notification_screen.dart';

import '../../features/app_layout/main_layout/main_layout.dart';
import '../../features/onboarding/UI/onboarding_screen.dart';

/// Route paths constants
abstract class RoutesNames {
  static const String onboarding = '/onboarding';
  static const String main = '/main';
  static const String notifications = '/notifications';
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
    ],
  );
}
