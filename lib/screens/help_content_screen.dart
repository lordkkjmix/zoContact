import 'package:flutter/material.dart';
import 'package:zocontact/models/models.dart';
import 'package:zocontact/shared/button.dart';
import 'package:zocontact/shared/shared.dart';

class HelpContentScreen extends StatelessWidget {
  final HelpContent helpContent;
  const HelpContentScreen(this.helpContent);
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: BlouColors.DarkBlueColor),
          toolbarHeight: 50,
        ),
        backgroundColor: BlouColors.GreyBgColor,
        body: SafeArea(
            child: Column(children: [
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(15, 0, 0, 15),
              color: Colors.white,
              //height: 40,
              child: BlouText(
                  text: this.helpContent.title,
                  type: "bold",
                  color: BlouColors.DarkBlueColor,
                  fontSize: 30)),
          Container(
              width: width,
              height: 150,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.white),
              child: Image.asset(this.helpContent.img, width: 50)),
          this.helpContent.id == "contactus"
              ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BlouButton(label: "Via Telegram", onPressed: (){}),
                  BlouButton(label: "Via Messenger", onPressed: (){}),
                  BlouButton(label: "Via Email", onPressed: (){})
                ])
              :this.helpContent.id =="rate_app"?Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal:20, vertical: 10),
                    child:BlouText(
                      text: "Nous sommes ravis que Zo Contact vous plaise.\nAidez-nous ?? obtenir 5 ??toiles sur le store.",
                      type: "bold",
                      color: BlouColors.DarkBlueColor,
                      textAlign: TextAlign.justify)),
                  BlouButton(label: "Noter 5 ??toiles", onPressed: (){}),
                ]): Container(
                  width: width,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: BlouText(
                      text: this.helpContent.content,
                      type: "medium",
                      color: BlouColors.DarkBlueColor,
                      textAlign: TextAlign.justify))
        ])));
  }
}
