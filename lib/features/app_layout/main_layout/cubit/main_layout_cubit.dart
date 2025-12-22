import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_layout_state.dart';

/// Cubit for managing main layout navigation state
class MainLayoutCubit extends Cubit<MainLayoutState> {
  MainLayoutCubit() : super(const MainLayoutState());

  /// Change the current navigation tab
  void changeTab(int index) {
    if (index != state.currentIndex) {
      emit(state.copyWith(currentIndex: index));
    }
  }

  /// Navigate to home tab
  void goToHome() => changeTab(0);

  /// Navigate to analytics tab
  void goToAnalytics() => changeTab(1);

  /// Navigate to budget tab
  void goToBudget() => changeTab(2);

  /// Navigate to settings tab
  void goToSettings() => changeTab(3);
}
