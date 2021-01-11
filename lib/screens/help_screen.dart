import 'package:flutter/material.dart';
import 'package:zocontact/shared/shared.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
        minimum: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: BlouColors.LightBlueColor),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(5, (index) {
                  return Center(
                      child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                        width: width / 2.5,
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          Image.asset('assets/img/messenger.png', width: 50,),
                          BlouText(
                            text:'Item $index',
                            type: "bold",
                            fontSize: 20,
                          )
                        ])),
                  ));
                }))));
  }
}
