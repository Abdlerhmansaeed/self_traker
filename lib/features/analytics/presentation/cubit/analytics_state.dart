part of 'analytics_cubit.dart';

/// State for analytics screen
class AnalyticsState extends Equatable {
  const AnalyticsState({this.selectedFilterIndex = 0});

  final int selectedFilterIndex;

  AnalyticsState copyWith({int? selectedFilterIndex}) {
    return AnalyticsState(
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
    );
  }

  @override
  List<Object> get props => [selectedFilterIndex];
}
