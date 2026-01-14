import 'dart:convert';
import 'dart:developer';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../model/parsed_expense_model.dart';
import 'voice_expense_tracker_data_source.dart';

/// System instruction for Gemini to parse expenses.
///
/// This prompt configures Gemini to act as an expense parsing AI
/// that handles Egyptian Arabic, code-switching, and returns
/// structured JSON output. Supports single or multiple expenses.
const String _systemInstruction = '''
You are an expense parsing AI assistant. Your ONLY job is to extract structured expense data from user input.

CRITICAL RULES:
1. Return ONLY valid JSON. No conversational text, explanations, or markdown formatting.
2. Handle Egyptian Arabic dialects (e.g., "جنيه", "geneh", "جنية") and Arabic numerals.
3. Handle code-switching between Arabic and English seamlessly.
4. Default currency to "EGP" if the context implies Egypt or is ambiguous.
5. For dates, if not specified, use "today". Otherwise use YYYY-MM-DD format.
6. If multiple expenses are detected in the input, return a JSON Array of objects [{}, {}].
7. If only one expense is detected, return a single JSON object {}.

CATEGORY MAPPING (choose the most appropriate):
- Food: meals, groceries, restaurants, coffee, snacks, أكل, طعام, مطعم
- Transport: uber, taxi, bus, fuel, parking, مواصلات, بنزين, اوبر, سواق, driver
- Rent: rent, housing, mortgage, إيجار, سكن
- Utilities: electricity, water, gas, internet, phone, كهرباء, مياه, غاز, نت
- Entertainment: movies, games, streaming, concerts, ترفيه, سينما
- Shopping: clothes, electronics, general purchases, تسوق, ملابس
- Healthcare: medicine, doctor, hospital, pharmacy, دكتور, دواء, صيدلية, علاج
- Education: courses, books, tuition, تعليم, كتب, كورس
- Other: anything that doesn't fit above

OUTPUT JSON STRUCTURE per expense:
{
  "amount": <number>,
  "currency": "<ISO code: EGP, USD, EUR, SAR, AED, etc>",
  "category": "<One of the categories above>",
  "description": "<Brief description in English>",
  "date": "<YYYY-MM-DD or 'today'>",
  "confidence": <0.0 to 1.0>
}

EXAMPLES:
Input: "دفعت خمسين جنيه على الأكل"
Output: {"amount": 50, "currency": "EGP", "category": "Food", "description": "Food purchase", "date": "today", "confidence": 0.95}

Input: "I paid 1000 to the driver and then he asked for another 2000"
Output: [{"amount": 1000, "currency": "EGP", "category": "Transport", "description": "Driver payment", "date": "today", "confidence": 0.92}, {"amount": 2000, "currency": "EGP", "category": "Transport", "description": "Additional driver payment", "date": "today", "confidence": 0.92}]

Input: "paid 20 dollars for uber yesterday"
Output: {"amount": 20, "currency": "USD", "category": "Transport", "description": "Uber ride", "date": "YESTERDAY_DATE_HERE", "confidence": 0.98}

Input: "اشتريت دواء ب ١٥٠ جنيه"
Output: {"amount": 150, "currency": "EGP", "category": "Healthcare", "description": "Medicine purchase", "date": "today", "confidence": 0.92}
''';

/// Implementation of [VoiceExpenseTrackerDataSource] using Google Gemini AI.
///
/// This service sends user voice input to the Gemini model with specialized
/// system instructions for expense parsing, handles the response, cleans
/// any markdown formatting, and returns a list of [ParsedExpenseModel].
///
/// Supports both single expenses and multiple expenses in one input.
@Injectable(as: VoiceExpenseTrackerDataSource)
class VoiceExpenseTrackerDataSourceImpl
    implements VoiceExpenseTrackerDataSource {
  VoiceExpenseTrackerDataSourceImpl() {
    _initializeModel();
  }

  late final GenerativeModel _model;

  /// Initializes the Gemini model with system instructions.
  void _initializeModel() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash-lite',
      apiKey: '',
      systemInstruction: Content.system(_buildSystemInstruction()),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 0.1, // Low temperature for consistent output
      ),
    );
  }

  /// Builds the system instruction with today's date for context.
  String _buildSystemInstruction() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final yesterday = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now().subtract(const Duration(days: 1)));
    return _systemInstruction
        .replaceAll('today', today)
        .replaceFirst('YESTERDAY_DATE_HERE', yesterday);
  }

  @override
  Future<List<ParsedExpenseModel>> parseUserTransaction({
    required String userInput,
  }) async {
    if (userInput.trim().isEmpty) {
      throw ArgumentError('User input cannot be empty');
    }

    try {
      log('Parsing expense from input: $userInput');

      final content = [Content.text(userInput)];
      final response = await _model.generateContent(content);

      final responseText = response.text;
      if (responseText == null || responseText.isEmpty) {
        throw Exception('Empty response from Gemini');
      }

      log('Gemini raw response: $responseText');

      // Clean and parse the JSON response
      final cleanedJson = _cleanJsonResponse(responseText);
      log('Cleaned JSON: $cleanedJson');

      final decoded = jsonDecode(cleanedJson);

      // Handle both single object and array responses
      final List<Map<String, dynamic>> expensesList;
      if (decoded is List) {
        // Multiple expenses returned as array
        expensesList = decoded.cast<Map<String, dynamic>>();
      } else if (decoded is Map<String, dynamic>) {
        // Single expense returned as object - wrap in list
        expensesList = [decoded];
      } else {
        throw Exception('Unexpected JSON format from Gemini');
      }

      // Handle empty list edge case
      if (expensesList.isEmpty) {
        throw Exception('No expenses detected in input');
      }

      // Process each expense and convert to model
      final results = <ParsedExpenseModel>[];
      for (final jsonMap in expensesList) {
        // Process date field - replace 'today' with actual date
        if (jsonMap['date'] == 'today') {
          jsonMap['date'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
        }
        results.add(ParsedExpenseModel.fromJson(jsonMap));
      }

      log('Parsed ${results.length} expense(s)');
      return results;
    } on FormatException catch (e) {
      log('JSON parsing error: $e');
      throw Exception('Failed to parse expense: Invalid JSON response');
    } on GenerativeAIException catch (e) {
      log('Gemini API error: $e');
      throw Exception('AI service error: ${e.message}');
    } catch (e) {
      log('Unexpected error parsing expense: $e');
      rethrow;
    }
  }

  /// Cleans the JSON response by removing markdown code block markers.
  ///
  /// Gemini sometimes wraps JSON responses in markdown code blocks like:
  /// ```json
  /// {...}
  /// ```
  ///
  /// This method strips those markers to get clean JSON.
  String _cleanJsonResponse(String response) {
    String cleaned = response.trim();

    // Remove ```json or ``` prefix
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.substring(7);
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3);
    }

    // Remove ``` suffix
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }

    return cleaned.trim();
  }
}
