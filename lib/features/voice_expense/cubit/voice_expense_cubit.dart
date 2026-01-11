import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'voice_expense_state.dart';

@injectable
class VoiceExpenseCubit extends Cubit<VoiceExpenseState> {
  VoiceExpenseCubit() : super(const VoiceExpenseState());

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
        parsedTransaction: null,
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

  /// Parse transaction from speech text (placeholder for AI integration)
  Future<void> _parseTransaction() async {
    // TODO: Integrate AI service to parse transaction from speechText
    // For now, create a placeholder parsed transaction

    // Simulate processing delay
    await Future.delayed(const Duration(milliseconds: 500));

    final parsed = ParsedTransaction(
      amount: _extractAmount(state.speechText),
      category: 'Food & Dining', // Placeholder
      note: state.speechText,
      date: DateTime.now(),
    );

    emit(
      state.copyWith(status: SpeechStatus.result, parsedTransaction: parsed),
    );
  }

  /// Simple amount extraction (placeholder for AI)
  double? _extractAmount(String text) {
    // Simple regex to find numbers in text
    final regex = RegExp(r'(\d+(?:\.\d+)?)');
    final match = regex.firstMatch(text);
    if (match != null) {
      return double.tryParse(match.group(1) ?? '');
    }
    return null;
  }

  /// Confirm transaction
  void confirmTransaction() {
    // TODO: Save transaction to repository
    log('Transaction confirmed: ${state.parsedTransaction}');
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
