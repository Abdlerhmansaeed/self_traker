import 'package:go_router/go_router.dart';

import '../../features/app_layout/main_layout/main_layout.dart';
import '../../features/onboarding/UI/onboarding_screen.dart';

/// Route paths constants
abstract class Routes {
  static const String onboarding = '/onboarding';
  static const String main = '/main';
}

/// App router configuration using GoRouter
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: Routes.onboarding,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: Routes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.main,
        name: 'main',
        builder: (context, state) => const MainLayout(),
      ),
    ],
  );
}
