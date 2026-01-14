import 'package:self_traker/features/voice_expense/data/model/parsed_expense_model.dart';

/// Abstract interface for voice expense data source.
///
/// This data source is responsible for parsing user voice input
/// into structured expense data using AI services.
abstract interface class VoiceExpenseTrackerDataSource {
  /// Parses user voice input into structured expense data.
  ///
  /// Takes the transcribed [userInput] text and returns a list of
  /// [ParsedExpenseModel] containing the extracted expense details.
  ///
  /// Returns a list to handle cases where the user mentions multiple
  /// expenses in a single input (e.g., "paid 1000 for uber and 500 for food").
  ///
  /// Throws an exception if parsing fails or the AI service
  /// returns an invalid response.
  Future<List<ParsedExpenseModel>> parseUserTransaction({
    required String userInput,
  });
}
