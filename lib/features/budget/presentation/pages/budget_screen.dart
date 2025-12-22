import 'package:flutter/material.dart';
import 'package:self_traker/core/theme/app_text_styles.dart';

// import '../../../core/theme/app_text_styles.dart';

/// Placeholder budget screen
class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Budget', style: AppTextStyles.headline2)),
    );
  }
}
