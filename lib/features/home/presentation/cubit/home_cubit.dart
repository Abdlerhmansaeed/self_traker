import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:self_traker/features/home/presentation/cubit/home_state.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

@singleton
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  final SpeechToText _speechToText = SpeechToText();

  Future<void> initSpeech() async {
    bool available = await _speechToText.initialize();
    if (available) {
      final locales = await _speechToText.locales();
      for (var locale in locales) {
        log('Available locale: ${locale.localeId} - ${locale.name}');
      }
    }
    emit(state.copyWith(isSpeechInitialized: available));
  }

  void startListening() async {
    if (!state.isSpeechInitialized) {
      await initSpeech();
    }
    if (state.isSpeechInitialized) {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: 'ar-SA', // Arabic - Saudi Arabia
        cancelOnError: false,
        partialResults: true,
        listenMode: ListenMode.confirmation,
        listenFor: const Duration(seconds: 40),
      );
      emit(state.copyWith(isListening: true, speechResult: ''));
    }
  }

  void stopListening() async {
    await _speechToText.stop();
    emit(state.copyWith(isListening: false));
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    log('Speech Result: ${result.recognizedWords}');
    emit(state.copyWith(speechResult: result.recognizedWords));
  }

  Future<void> handelMicPermissionStatus() async {
    final micPermissionStatus = await Permission.microphone.status;
    log(micPermissionStatus.name);
    switch (micPermissionStatus) {
      case PermissionStatus.denied:
        requestMicPermission();
        break;
      case PermissionStatus.granted:
        break;
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.provisional:
        break;
    }

    emit(state.copyWith(permissionStatus: micPermissionStatus));
  }

  Future<void> requestMicPermission() async {
    final status = await Permission.microphone.request();

    emit(state.copyWith(permissionStatus: status));
  }
}
