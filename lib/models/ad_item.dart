import 'package:flutter/widgets.dart';

class AdItem {
  final String id;
  final int order;
  final String img;
  final String link;
  final bool isActive;
  AdItem(
      {@required this.id,
      @required this.order,
      @required this.img,
      @required this.link,
      this.isActive = false});

  factory AdItem.fromJson(Map<String, dynamic> json) {
    return AdItem(
      id: json['id'],
      order: json['order'],
      img: json['img'],
      link: json['link'],
      isActive: json['isActive'],
    );
  }
}
