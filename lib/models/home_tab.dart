import 'package:flutter/widgets.dart';

class HomeTab {
  final String appBarTitle;
  final String tabTitle;
  final String icon;
  final String id;
  final Widget screen;
  final bool isSelected;

  HomeTab(
      {@required this.appBarTitle,
      @required this.tabTitle,
      @required this.icon,
      @required this.id,
      @required this.screen,
      this.isSelected = false});

  HomeTab copyWith({
    final String appBarTitle,
    final String tabTitle,
    final String icon,
    final String id,
    final Widget screen,
    final bool isSelected,
  }) {
    return HomeTab(
      id: id ?? this.id,
      appBarTitle: appBarTitle ?? this.appBarTitle,
      tabTitle: tabTitle ?? this.tabTitle,
      icon: icon ?? this.icon,
      screen: screen ?? this.screen,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
