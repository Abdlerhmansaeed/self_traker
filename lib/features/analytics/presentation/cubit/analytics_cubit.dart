import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'analytics_state.dart';

/// Cubit for managing analytics screen state
class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit() : super(const AnalyticsState());

  /// Change the selected time filter
  void selectFilter(int index) {
    emit(state.copyWith(selectedFilterIndex: index));
  }
}
