import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:zocontact/models/models.dart';
import 'package:zocontact/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'home_tab_event.dart';
part 'home_tab_state.dart';

class HomeTabBloc extends Bloc<HomeTabEvent, HomeTabState> {
  final HomeTabRepository repository;
  final int defaultSelected;

  HomeTabBloc(
    this.repository, {
    this.defaultSelected = 0,
  }) : super(HomeTabInitial());

  @override
  Stream<HomeTabState> mapEventToState(
    HomeTabEvent event,
  ) async* {
    var currentState = state;
   //yield HomeTabListInProgress();
    if (event is HomeTabListed) {
        final tabs = this.repository.getTabs();
        if (currentState is HomeTabListSuccess) {
          yield currentState.copyWith(tabs: tabs);
        } else {
          yield HomeTabListSuccess(
              tabs: tabs,
              selectedIndex: this.defaultSelected < tabs.length
                  ? this.defaultSelected
                  : 0);
        }
      
    } else if (event is HomeTabSelected) {
      if (currentState is HomeTabListSuccess) {
        yield currentState.copyWith(selectedIndex: event.index);
      }
    }
  }
}
