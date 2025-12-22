import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_state.dart';

/// Cubit for managing settings screen state
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  /// Toggle smart alerts
  void toggleSmartAlerts() {
    emit(state.copyWith(smartAlertsEnabled: !state.smartAlertsEnabled));
  }

  /// Set AI coach style
  void setAiCoachStyle(AiCoachStyle style) {
    emit(state.copyWith(aiCoachStyle: style));
  }

  /// Set currency
  void setCurrency(String currency) {
    emit(state.copyWith(currency: currency));
  }
}
