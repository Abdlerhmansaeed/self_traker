import 'package:equatable/equatable.dart';

/// Speech recognition status
enum SpeechStatus { idle, listening, processing, result, error }

/// Parsed transaction from voice input (placeholder for AI integration)
class ParsedTransaction extends Equatable {
  const ParsedTransaction({this.amount, this.category, this.note, this.date});

  final double? amount;
  final String? category;
  final String? note;
  final DateTime? date;

  ParsedTransaction copyWith({
    double? amount,
    String? category,
    String? note,
    DateTime? date,
  }) {
    return ParsedTransaction(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [amount, category, note, date];
}

/// State for voice expense tracking
class VoiceExpenseState extends Equatable {
  const VoiceExpenseState({
    this.status = SpeechStatus.idle,
    this.speechText = '',
    this.parsedTransaction,
    this.errorMessage,
    this.isSpeechInitialized = false,
  });

  final SpeechStatus status;
  final String speechText;
  final ParsedTransaction? parsedTransaction;
  final String? errorMessage;
  final bool isSpeechInitialized;

  bool get isListening => status == SpeechStatus.listening;
  bool get hasResult => status == SpeechStatus.result;
  bool get hasError => status == SpeechStatus.error;

  VoiceExpenseState copyWith({
    SpeechStatus? status,
    String? speechText,
    ParsedTransaction? parsedTransaction,
    String? errorMessage,
    bool? isSpeechInitialized,
  }) {
    return VoiceExpenseState(
      status: status ?? this.status,
      speechText: speechText ?? this.speechText,
      parsedTransaction: parsedTransaction ?? this.parsedTransaction,
      errorMessage: errorMessage ?? this.errorMessage,
      isSpeechInitialized: isSpeechInitialized ?? this.isSpeechInitialized,
    );
  }

  @override
  List<Object?> get props => [
    status,
    speechText,
    parsedTransaction,
    errorMessage,
    isSpeechInitialized,
  ];
}
