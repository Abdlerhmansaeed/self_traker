part of 'main_layout_cubit.dart';

/// State for main layout navigation
class MainLayoutState extends Equatable {
  const MainLayoutState({this.currentIndex = 0});

  final int currentIndex;

  MainLayoutState copyWith({int? currentIndex}) {
    return MainLayoutState(currentIndex: currentIndex ?? this.currentIndex);
  }

  @override
  List<Object> get props => [currentIndex];
}
