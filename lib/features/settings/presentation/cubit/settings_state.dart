part of 'settings_cubit.dart';

/// AI Coach style options
enum AiCoachStyle { strict, balanced, friendly }

/// State for settings screen
class SettingsState extends Equatable {
  const SettingsState({
    this.smartAlertsEnabled = true,
    this.aiCoachStyle = AiCoachStyle.balanced,
    this.currency = 'USD',
  });

  final bool smartAlertsEnabled;
  final AiCoachStyle aiCoachStyle;
  final String currency;

  SettingsState copyWith({
    bool? smartAlertsEnabled,
    AiCoachStyle? aiCoachStyle,
    String? currency,
  }) {
    return SettingsState(
      smartAlertsEnabled: smartAlertsEnabled ?? this.smartAlertsEnabled,
      aiCoachStyle: aiCoachStyle ?? this.aiCoachStyle,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object> get props => [smartAlertsEnabled, aiCoachStyle, currency];
}
