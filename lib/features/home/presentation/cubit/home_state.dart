import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeState extends Equatable {
  const HomeState({
    this.permissionStatus,
    this.isListening = false,
    this.speechResult = '',
    this.isSpeechInitialized = false,
  });

  final PermissionStatus? permissionStatus;
  final bool isListening;
  final String speechResult;
  final bool isSpeechInitialized;

  HomeState copyWith({
    PermissionStatus? permissionStatus,
    bool? isListening,
    String? speechResult,
    bool? isSpeechInitialized,
  }) {
    return HomeState(
      permissionStatus: permissionStatus ?? this.permissionStatus,
      isListening: isListening ?? this.isListening,
      speechResult: speechResult ?? this.speechResult,
      isSpeechInitialized: isSpeechInitialized ?? this.isSpeechInitialized,
    );
  }

  @override
  @override
  List<Object?> get props => [
    permissionStatus,
    isListening,
    speechResult,
    isSpeechInitialized,
  ];
}
