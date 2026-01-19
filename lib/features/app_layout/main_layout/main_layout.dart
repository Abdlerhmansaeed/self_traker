import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_traker/core/di/injection.dart';
import 'package:self_traker/features/voice_expense/presentation/cubit/voice_expense_cubit.dart';
import '../../analytics/presentation/pages/analytics_screen.dart';
import '../../auth/presentation/cubit/auth_cubit.dart';
import '../../auth/presentation/cubit/auth_state.dart';
import '../../auth/presentation/widgets/email_verification_banner.dart';
import '../../budget/presentation/pages/budget_screen.dart';
import '../../home/presentation/pages/home_screen.dart';
import '../../settings/presentation/pages/settings_screen.dart';
import '../../voice_expense/presentation/voice_expense_bottom_sheet.dart';
import 'cubit/main_layout_cubit.dart';
import 'widgets/custom_bottom_nav_bar.dart';

/// Main layout with bottom navigation and FAB
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MainLayoutCubit()),
        BlocProvider(create: (_) => getIt<VoiceExpenseCubit>()),
      ],
      child: BlocBuilder<MainLayoutCubit, MainLayoutState>(
        builder: (context, state) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              return Scaffold(
                body: Column(
                  children: [
                    // Show verification banner if email is not verified
                    if (authState is EmailVerificationRequired)
                      const EmailVerificationBanner(),
                    // Main content
                    Expanded(
                      child: IndexedStack(
                        index: state.currentIndex,
                        children: const [
                          HomeScreen(),
                          AnalyticsScreen(),
                          BudgetScreen(),
                          SettingsScreen(),
                        ],
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: CustomBottomNavBar(
                  currentIndex: state.currentIndex,
                  onTap: (index) {
                    context.read<MainLayoutCubit>().changeTab(index);
                  },
                  onFabPressed: () => _showVoiceExpenseSheet(context),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showVoiceExpenseSheet(BuildContext context) {
    final cubit = context.read<VoiceExpenseCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: cubit,
        child: const VoiceExpenseBottomSheet(),
      ),
    ).then((_) {
      // Reset state when sheet is dismissed
      cubit.reset();
    });

    // Start listening when sheet opens
    cubit.startListening();
  }
}
