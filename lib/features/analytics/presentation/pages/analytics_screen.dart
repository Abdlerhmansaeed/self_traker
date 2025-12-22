import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../cubit/analytics_cubit.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/monthly_trends_chart.dart';
import '../widgets/smart_suggestion_card.dart';
import '../widgets/spending_chart_card.dart';
import '../widgets/time_filter_chips.dart';

/// Analytics screen with statistics and insights
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnalyticsCubit(),
      child: const _AnalyticsView(),
    );
  }
}

class _AnalyticsView extends StatelessWidget {
  const _AnalyticsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context),
              SizedBox(height: AppDimensions.spacingLg),
              // Time filters
              BlocBuilder<AnalyticsCubit, AnalyticsState>(
                builder: (context, state) {
                  return TimeFilterChips(
                    selectedIndex: state.selectedFilterIndex,
                    onSelected: (index) {
                      context.read<AnalyticsCubit>().selectFilter(index);
                    },
                  );
                },
              ),
              SizedBox(height: AppDimensions.spacingLg),
              // AI Insight card
              AiInsightCard(
                title: 'Spending Alert',
                message:
                    'You spent 20% more on coffee this week compared to last week. Consider setting a limit for the \'Dining Out\' category.',
                onButtonTap: () {
                  // TODO: Navigate to budget adjustment
                },
              ),
              SizedBox(height: AppDimensions.spacingLg),
              // Spending chart
              SpendingChartCard(
                totalSpent: '\$2,450.80',
                percentageChange: '+12%',
                isPositive: true,
                topCategory: 'Housing',
                categories: _mockCategories,
                onViewBreakdownTap: () {
                  // TODO: Navigate to full breakdown
                },
              ),
              SizedBox(height: AppDimensions.spacingLg),
              // Monthly trends
              MonthlyTrendsChart(data: _mockMonthlyData, activeLabel: '\$2.4k'),
              SizedBox(height: AppDimensions.spacingLg),
              // Smart suggestions
              SmartSuggestionCard(
                title: 'Boost your savings',
                subtitle:
                    'Save \$50 more this month to reach your vacation goal.',
                goalName: 'Vacation 2024',
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAfajmW_-Hs7GlK-cZnNoTTccxP0LpknZnTM1q6S2s8mgkEqU94d-sbbQm_XTA0A0g_WFL297L1Hia4pp9x04O0tkPJ-B-VrkdiYkY5_TzIOra4X5FpRYhGwy2Zi-TUElOuGM0KjhnY48ODSaIY7rCoFB0uMq_uFdgiCdqy1HMwHR9pX505JwvUiSSE1JYkhj1vsKEtanCX5k19qfiw3Z1qKy1J-U6kOg0wzTbgW0m1wyRHXX82SWUWHveHKBhxxxsR37DGiPvU3tU',
                onViewPlanTap: () {
                  // TODO: Navigate to savings plan
                },
              ),
              SizedBox(height: AppDimensions.spacingLg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingHorizontal,
        vertical: AppDimensions.spacingMd,
      ),
      child: Text(
        'Statistics',
        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Mock data for demo
final _mockCategories = [
  const CategoryData(
    name: 'Housing',
    amount: 980.00,
    percentage: 40,
    icon: Icons.home,
  ),
  const CategoryData(
    name: 'Food & Dining',
    amount: 612.50,
    percentage: 25,
    icon: Icons.restaurant,
  ),
  const CategoryData(
    name: 'Transport',
    amount: 367.60,
    percentage: 15,
    icon: Icons.directions_car,
  ),
];

final _mockMonthlyData = [
  const MonthlyData(month: 'May', value: 0.45),
  const MonthlyData(month: 'Jun', value: 0.60),
  const MonthlyData(month: 'Jul', value: 0.35),
  const MonthlyData(month: 'Aug', value: 0.75, isActive: true),
  const MonthlyData(month: 'Sep', value: 0.50),
];
