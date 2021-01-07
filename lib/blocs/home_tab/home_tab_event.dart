part of 'home_tab_bloc.dart';

@immutable
abstract class HomeTabEvent {}

class HomeTabListed extends HomeTabEvent {}

class HomeTabSelected extends HomeTabEvent {
  final int index;
  HomeTabSelected(this.index);
}
