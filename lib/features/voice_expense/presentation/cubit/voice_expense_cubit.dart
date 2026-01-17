import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:self_traker/core/di/injection.dart';
import 'package:self_traker/features/home/presentation/cubit/home_cubit.dart';
import 'package:self_traker/features/home/presentation/widgets/transaction_item.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../data/data_source/voice_expense_tracker_data_source.dart';
import 'voice_expense_state.dart';

/// Cubit for managing voice expense tracking state.
///
/// This cubit handles:
/// - Speech recognition initialization and listening
/// - Microphone permission management
/// - Integration with AI expense parsing service
/// - Transaction confirmation workflow
/// - Multiple expense detection and handling
@injectable
class VoiceExpenseCubit extends Cubit<VoiceExpenseState> {
  VoiceExpenseCubit(this._dataSource) : super(const VoiceExpenseState());

  final VoiceExpenseTrackerDataSource _dataSource;
  final SpeechToText _speechToText = SpeechToText();

  /// Initialize speech recognition
  Future<void> initSpeech() async {
    try {
      bool available = await _speechToText.initialize(
        onError: (error) {
          log('Speech error: ${error.errorMsg}');
          emit(
            state.copyWith(
              status: SpeechStatus.error,
              errorMessage: error.errorMsg,
            ),
          );
        },
        onStatus: (status) {
          log('Speech status: $status');
        },
      );

      if (available) {
        final locales = await _speechToText.locales();
        for (var locale in locales) {
          log('Available locale: ${locale.localeId} - ${locale.name}');
        }
      }

      emit(state.copyWith(isSpeechInitialized: available));
    } catch (e) {
      log('Speech init error: $e');
      emit(
        state.copyWith(
          status: SpeechStatus.error,
          errorMessage: 'Failed to initialize speech recognition',
        ),
      );
    }
  }

  /// Check and request microphone permission
  Future<bool> checkMicPermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }

  /// Start listening for voice input
  Future<void> startListening({String localeId = 'ar-SA'}) async {
    final hasPermission = await checkMicPermission();
    if (!hasPermission) {
      emit(
        state.copyWith(
          status: SpeechStatus.error,
          errorMessage: 'Microphone permission denied',
        ),
      );
      return;
    }

    if (!state.isSpeechInitialized) {
      await initSpeech();
    }

    if (!state.isSpeechInitialized) {
      emit(
        state.copyWith(
          status: SpeechStatus.error,
          errorMessage: 'Speech recognition not available',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: SpeechStatus.listening,
        speechText: '',
        parsedTransactions: [],
      ),
    );

    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: localeId,
      cancelOnError: false,
      partialResults: true,
      listenMode: ListenMode.dictation,
      listenFor: const Duration(seconds: 30),
    );
  }

  /// Stop listening
  Future<void> stopListening() async {
    await _speechToText.stop();
    if (state.speechText.isNotEmpty) {
      emit(state.copyWith(status: SpeechStatus.processing));
      await _parseTransaction();
    } else {
      emit(state.copyWith(status: SpeechStatus.idle));
    }
  }

  /// Cancel listening without processing
  void cancelListening() {
    _speechToText.cancel();
    emit(state.copyWith(status: SpeechStatus.idle, speechText: ''));
  }

  /// Handle speech recognition result
  void _onSpeechResult(SpeechRecognitionResult result) {
    log('Speech Result: ${result.recognizedWords}');
    emit(state.copyWith(speechText: result.recognizedWords));

    if (result.finalResult) {
      emit(state.copyWith(status: SpeechStatus.processing));
      _parseTransaction();
    }
  }

  /// Parse transaction(s) from speech text using AI service.
  ///
  /// Calls the [VoiceExpenseTrackerDataSource] to parse the speech text
  /// and converts the results to [ParsedTransaction] list for display.
  /// Handles multiple expenses in a single input.
  Future<void> _parseTransaction() async {
    try {
      log('Parsing transaction from: ${state.speechText}');

      final parsedExpenses = await _dataSource.parseUserTransaction(
        userInput: state.speechText,
      );

      log('Parsed ${parsedExpenses.length} expense(s)');

      // Handle empty result edge case
      if (parsedExpenses.isEmpty) {
        emit(
          state.copyWith(
            status: SpeechStatus.error,
            errorMessage:
                'No expenses detected in your input. Please try again.',
          ),
        );
        return;
      }

      // Convert ParsedExpenseModel list to ParsedTransaction list for the UI
      final transactions = parsedExpenses
          .map(
            (expense) => ParsedTransaction(
              amount: expense.amount,
              currency: expense.currency,
              category: expense.category,
              note: expense.description,
              date: expense.resolvedDate,
            ),
          )
          .toList();

      log('Converted to ${transactions.length} transaction(s)');

      emit(
        state.copyWith(
          status: SpeechStatus.result,
          parsedTransactions: transactions,
        ),
      );
    } catch (e) {
      log('Error parsing transaction: $e');
      emit(
        state.copyWith(
          status: SpeechStatus.error,
          errorMessage: 'Failed to parse expense: ${e.toString()}',
        ),
      );
    }
  }

  /// Confirm all transactions
  void confirmTransaction() {
    // TODO: Save all transactions to repository still
    final homeCubit = getIt<HomeCubit>();
    final userBalanceUpdated =
        state.totalAmount + homeCubit.state.totalUserBalance;
    homeCubit.updateUserBalance(amount: userBalanceUpdated);

    for (var transaction in state.parsedTransactions) {
      homeCubit.updateUserTransactionsList(
        userTransactionData: TransactionData(
          amount: transaction.amount.toString(),
          title: transaction.note ?? 'No Title',
          // isPositive: state.parsedTransaction.,
          subtitle: transaction.category ?? 'No Sub',
        ),
      );
    }

    // homeCubit.updateUserTransactionsList(
    //   userTransactionData: TransactionData(
    //     amount: state.totalAmount.toString(),
    //     title: state.parsedTransaction?.note ?? '',
    //     // isPositive: state.parsedTransaction.,
    //     subtitle: state.parsedTransaction?.category ?? 'No Sub' ,
    //   ),
    // );

    log(
      'Confirmed ${state.transactionCount} transaction(s) totaling ${state.totalAmount} ${state.primaryCurrency}',
    );
    for (final transaction in state.parsedTransactions) {
      log(
        'Transaction: ${transaction.amount} ${transaction.currency} - ${transaction.category}',
      );
    }
    reset();
  }

  /// Try again - restart listening
  Future<void> tryAgain() async {
    reset();
    await startListening();
  }

  /// Reset state
  void reset() {
    emit(const VoiceExpenseState());
  }
}
