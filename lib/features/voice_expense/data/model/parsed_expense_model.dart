import 'package:equatable/equatable.dart';

/// Represents a parsed expense from Gemini AI.
///
/// This model maps directly to the JSON response from the Gemini
/// expense parsing service.
class ParsedExpenseModel extends Equatable {
  const ParsedExpenseModel({
    required this.amount,
    required this.currency,
    required this.category,
    required this.description,
    required this.date,
    required this.confidence,
  });

  /// The expense amount as a number.
  final double amount;

  /// ISO currency code (e.g., "EGP", "USD").
  final String currency;

  /// Expense category.
  /// One of: Food, Transport, Rent, Utilities, Entertainment,
  /// Shopping, Healthcare, Education, Other.
  final String category;

  /// Brief description of the expense in English.
  final String description;

  /// Date in YYYY-MM-DD format or "today".
  final String date;

  /// AI confidence score from 0.0 to 1.0.
  final double confidence;

  /// Creates a [ParsedExpenseModel] from a JSON map.
  ///
  /// Handles type coercion for amount and confidence fields
  /// which may come as int or double from JSON parsing.
  factory ParsedExpenseModel.fromJson(Map<String, dynamic> json) {
    return ParsedExpenseModel(
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EGP',
      category: json['category'] as String? ?? 'Other',
      description: json['description'] as String? ?? '',
      date: json['date'] as String? ?? 'today',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.5,
    );
  }

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'category': category,
      'description': description,
      'date': date,
      'confidence': confidence,
    };
  }

  /// Resolves the date string to an actual [DateTime].
  ///
  /// If the date is "today", returns the current date.
  /// Otherwise, attempts to parse the YYYY-MM-DD formatted string.
  DateTime get resolvedDate {
    if (date.toLowerCase() == 'today') {
      return DateTime.now();
    }
    return DateTime.tryParse(date) ?? DateTime.now();
  }

  @override
  List<Object?> get props => [
    amount,
    currency,
    category,
    description,
    date,
    confidence,
  ];

  @override
  String toString() {
    return 'ParsedExpenseModel('
        'amount: $amount, '
        'currency: $currency, '
        'category: $category, '
        'description: $description, '
        'date: $date, '
        'confidence: $confidence)';
  }
}
