import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive_x.dart';

// import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'transaction_item.dart';

/// Recent transactions list section
class TransactionsList extends StatelessWidget {
  const TransactionsList({
    super.key,
    required this.transactions,
    this.onFilterTap,
  });

  final List<TransactionData> transactions;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Tooltip(
                message: 'Add New Transaction',
                child: GestureDetector(
                  onTap: onFilterTap,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: Icon(
                      Icons.add,
                      size: 30.r,
                      // color: AppColors.textSub,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingMd),
        // Transaction items
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          separatorBuilder: (_, __) =>
              SizedBox(height: AppDimensions.spacingSm),
          itemBuilder: (context, index) {
            return TransactionItem(
              data: transactions[index],
              onTap: () {
                // TODO: Navigate to transaction details
              },
            );
          },
        ),
      ],
    );
  }
}
