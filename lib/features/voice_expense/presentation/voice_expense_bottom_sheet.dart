import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../cubit/voice_expense_cubit.dart';
import '../cubit/voice_expense_state.dart';

/// Voice expense bottom sheet matching the design
class VoiceExpenseBottomSheet extends StatelessWidget {
  const VoiceExpenseBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VoiceExpenseBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceExpenseCubit, VoiceExpenseState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutral400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // Content based on state
              Padding(
                padding: const EdgeInsets.all(20),
                child: _buildContent(context, state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, VoiceExpenseState state) {
    switch (state.status) {
      case SpeechStatus.idle:
        return _buildIdleState(context);
      case SpeechStatus.listening:
        return _buildListeningState(context, state);
      case SpeechStatus.processing:
        return _buildProcessingState(context, state);
      case SpeechStatus.result:
        return _buildResultState(context, state);
      case SpeechStatus.error:
        return _buildErrorState(context, state);
    }
  }

  Widget _buildIdleState(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.mic, size: 48, color: AppColors.primary),
        const SizedBox(height: 16),
        Text(
          'Tap the mic to start',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        _buildPrimaryButton(
          context: context,
          label: 'Start Listening',
          onPressed: () => context.read<VoiceExpenseCubit>().startListening(),
        ),
      ],
    );
  }

  Widget _buildListeningState(BuildContext context, VoiceExpenseState state) {
    return Column(
      children: [
        // Animated listening indicator
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.2),
          ),
          child: const Center(
            child: Icon(Icons.mic, size: 40, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Listening...',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        // Speech text preview
        Container(
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            state.speechText.isEmpty ? 'Say something...' : state.speechText,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: state.speechText.isEmpty
                  ? AppColors.neutral500
                  : AppColors.textDark,
            ),
            textAlign: TextAlign.center,
            // textDirection: TextDirection.rtl, // For Arabic support
          ),
        ),
        const SizedBox(height: 24),
        _buildPrimaryButton(
          context: context,
          label: 'Done',
          onPressed: () => context.read<VoiceExpenseCubit>().stopListening(),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            context.read<VoiceExpenseCubit>().cancelListening();
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildProcessingState(BuildContext context, VoiceExpenseState state) {
    return Column(
      children: [
        const CircularProgressIndicator(color: AppColors.primary),
        const SizedBox(height: 16),
        Text('Processing...', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          state.speechText,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.neutral500),
          // textDirection: TextDirection.,
        ),
      ],
    );
  }

  Widget _buildResultState(BuildContext context, VoiceExpenseState state) {
    final transaction = state.parsedTransaction;
    final amount = transaction?.amount ?? 0;
    final category = transaction?.category ?? 'Unknown';
    final note = transaction?.note ?? '';
    final date = transaction?.date ?? DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // AI Processed badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, size: 16, color: AppColors.textDark),
              const SizedBox(width: 4),
              Text(
                'AI PROCESSED',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Transaction Detected
        Text(
          'Transaction Detected',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.neutral500),
        ),
        const SizedBox(height: 8),

        // Amount
        Text(
          '${amount.toStringAsFixed(2)} EGP',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Category chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.restaurant, size: 16),
              const SizedBox(width: 8),
              Text(category, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.positive,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Note field
        _buildInfoRow(context, 'Note', note, Icons.edit),
        const SizedBox(height: 12),

        // Date field
        _buildInfoRow(
          context,
          'Date',
          DateFormat('EEEE, h:mm a').format(date),
          Icons.calendar_today,
        ),
        const SizedBox(height: 24),

        // Confirm button
        _buildPrimaryButton(
          context: context,
          label: 'Confirm Transaction',
          icon: Icons.arrow_forward,
          onPressed: () {
            context.read<VoiceExpenseCubit>().confirmTransaction();
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 12),

        // Try Again
        TextButton.icon(
          onPressed: () => context.read<VoiceExpenseCubit>().tryAgain(),
          icon: const Icon(Icons.refresh),
          label: const Text('Try Again'),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, VoiceExpenseState state) {
    return Column(
      children: [
        const Icon(Icons.error_outline, size: 48, color: AppColors.negative),
        const SizedBox(height: 16),
        Text('Error', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          state.errorMessage ?? 'Something went wrong',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.neutral500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _buildPrimaryButton(
          context: context,
          label: 'Try Again',
          onPressed: () => context.read<VoiceExpenseCubit>().tryAgain(),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: AppColors.neutral500),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                  // textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          Icon(icon, size: 20, color: AppColors.neutral500),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textDark,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
