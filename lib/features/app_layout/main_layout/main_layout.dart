import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../analytics/presentation/pages/analytics_screen.dart';
import '../../budget/presentation/pages/budget_screen.dart';
import '../../home/presentation/pages/home_screen.dart';
import '../../settings/presentation/pages/settings_screen.dart';
import 'cubit/main_layout_cubit.dart';
import 'widgets/custom_bottom_nav_bar.dart';

/// Main layout with bottom navigation and FAB
class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainLayoutCubit(),
      child: const _MainLayoutView(),
    );
  }
}

class _MainLayoutView extends StatelessWidget {
  const _MainLayoutView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainLayoutCubit, MainLayoutState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentIndex,
            children: const [
              HomeScreen(),
              AnalyticsScreen(),
              BudgetScreen(),
              SettingsScreen(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: state.currentIndex,
            onTap: (index) {
              context.read<MainLayoutCubit>().changeTab(index);
            },
            onFabPressed: () {
              // TODO: Implement voice input
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Voice input coming soon!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
