import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resposive_xx/responsive_x.dart';
import 'package:self_traker/core/routing/app_router.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../widgets/balance_card.dart';
import '../widgets/home_header.dart';
import '../widgets/stats_overview.dart';
import '../widgets/transaction_item.dart';
import '../widgets/transactions_list.dart';

/// Home screen displaying user balance, stats, and transactions
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 100.h), // Space for FAB
          child: Column(
            children: [
              // Header
              HomeHeader(
                userName: 'Alex Morgan',
                avatarUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuARRAN24rb0KR5ETVhZGke_0uxbaqed28BikmkzIQumT-oSuNJ-HDH6hfF5SC4OFCX5Xd5Wf9eAQcdxboR7WcCdr_yyxqcm9d9ZKJuRxfSRmOso9jPxm_7Qv1jnlfh82JSR38C2QUUvm5YZIQC9rQe13kbtnhcSDGpSHo5H5IPlqs0vitCU4CXgK9kyeNF8uB2F6k_rQHX69LQhNh9piYl-5cKPSu_i44m3ihCThSwPA_Ao566gKMy0wkju7O62dd8lGMXiIeo9g_Q',
                hasNotifications: true,
                onNotificationTap: () {
                  context.goNamed(RoutesNames.notifications);
                },
              ),
              // Content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingHorizontal,
                ),
                child: Column(
                  children: [
                    SizedBox(height: AppDimensions.spacingMd),
                    // Balance card
                    const BalanceCard(
                      balance: '\$12,450.00',
                      percentageChange: '+2.4%',
                      isPositive: true,
                    ),
                    SizedBox(height: AppDimensions.spacingLg),
                    // Stats overview
                    StatsOverview(
                      spentToday: '\$45.20',
                      dailyLimit: '\$100.00',
                      spentPercentage: 0.45,
                      onSeeAnalyticsTap: () {
                        // TODO: Navigate to analytics
                      },
                    ),
                    SizedBox(height: AppDimensions.spacingLg),
                    // Transactions list
                    TransactionsList(
                      transactions: _mockTransactions,
                      onFilterTap: () {
                        // TODO: Show filter options
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mock transaction data for demo
final _mockTransactions = [
  const TransactionData(
    title: 'Starbucks',
    subtitle: 'Coffee • 10:30 AM',
    amount: '-\$5.50',
    icon: Icons.local_cafe,
    isPositive: false,
  ),
  const TransactionData(
    title: 'Upwork Inc.',
    subtitle: 'Freelance Payout • 9:15 AM',
    amount: '+\$450.00',
    icon: Icons.payments,
    isPositive: true,
  ),
  const TransactionData(
    title: 'Uber',
    subtitle: 'Transport • Yesterday',
    amount: '-\$12.30',
    icon: Icons.local_taxi,
    isPositive: false,
  ),
  const TransactionData(
    title: 'Whole Foods',
    subtitle: 'Groceries • Yesterday',
    amount: '-\$84.15',
    icon: Icons.shopping_cart,
    isPositive: false,
  ),
];
