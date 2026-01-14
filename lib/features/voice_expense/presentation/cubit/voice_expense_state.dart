import 'package:equatable/equatable.dart';

/// Speech recognition status
enum SpeechStatus { idle, listening, processing, result, error }

/// Parsed transaction from voice input
class ParsedTransaction extends Equatable {
  const ParsedTransaction({
    this.amount,
    this.currency,
    this.category,
    this.note,
    this.date,
  });

  final double? amount;
  final String? currency;
  final String? category;
  final String? note;
  final DateTime? date;

  ParsedTransaction copyWith({
    double? amount,
    String? currency,
    String? category,
    String? note,
    DateTime? date,
  }) {
    return ParsedTransaction(
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [amount, currency, category, note, date];
}

/// State for voice expense tracking
class VoiceExpenseState extends Equatable {
  const VoiceExpenseState({
    this.status = SpeechStatus.idle,
    this.speechText = '',
    this.parsedTransactions = const [],
    this.errorMessage,
    this.isSpeechInitialized = false,
  });

  final SpeechStatus status;
  final String speechText;

  /// List of parsed transactions (supports multiple expenses in one input)
  final List<ParsedTransaction> parsedTransactions;

  final String? errorMessage;
  final bool isSpeechInitialized;

  bool get isListening => status == SpeechStatus.listening;
  bool get hasResult => status == SpeechStatus.result;
  bool get hasError => status == SpeechStatus.error;

  /// Returns the first transaction for backwards compatibility
  ParsedTransaction? get parsedTransaction =>
      parsedTransactions.isNotEmpty ? parsedTransactions.first : null;

  /// Returns the total amount of all parsed transactions
  double get totalAmount =>
      parsedTransactions.fold(0.0, (sum, t) => sum + (t.amount ?? 0));

  /// Returns the count of parsed transactions
  int get transactionCount => parsedTransactions.length;

  /// Returns the primary currency (from first transaction)
  String get primaryCurrency => parsedTransactions.isNotEmpty
      ? (parsedTransactions.first.currency ?? 'EGP')
      : 'EGP';

  VoiceExpenseState copyWith({
    SpeechStatus? status,
    String? speechText,
    List<ParsedTransaction>? parsedTransactions,
    String? errorMessage,
    bool? isSpeechInitialized,
  }) {
    return VoiceExpenseState(
      status: status ?? this.status,
      speechText: speechText ?? this.speechText,
      parsedTransactions: parsedTransactions ?? this.parsedTransactions,
      errorMessage: errorMessage ?? this.errorMessage,
      isSpeechInitialized: isSpeechInitialized ?? this.isSpeechInitialized,
    );
  }

  @override
  List<Object?> get props => [
    status,
    speechText,
    parsedTransactions,
    errorMessage,
    isSpeechInitialized,
  ];
}
