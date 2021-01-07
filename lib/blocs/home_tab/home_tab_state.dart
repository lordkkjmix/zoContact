part of 'home_tab_bloc.dart';

@immutable
abstract class HomeTabState {}

class HomeTabInitial extends HomeTabState {}

class HomeTabListSuccess extends HomeTabState {
  final int selectedIndex;
  final List<HomeTab> tabs;

  HomeTabListSuccess({this.tabs, this.selectedIndex});

  HomeTabListSuccess copyWith({int selectedIndex, List<HomeTab> tabs}) {
    return HomeTabListSuccess(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      tabs: tabs ?? this.tabs,
    );
  }
  List<Object> get props => [tabs];

  @override
  String toString() => 'HomeTabSuccess { tabs.length : $tabs }';
}
