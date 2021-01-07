import 'package:flutter/material.dart';

class CarrierCard extends StatelessWidget {
  final Color color;
  final Color pinColor;
  final Widget child;
  const CarrierCard(this.color, this.pinColor, {this.child});
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
        width: width/4,
        height: width/3.2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: this.color),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                width: width/5,
                height: width/30,
                decoration: BoxDecoration(
                    color: this.pinColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            this.child
          ],
        ));
  }
}
