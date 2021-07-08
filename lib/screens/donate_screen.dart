import 'package:zocontact/shared/button.dart';
import 'package:zocontact/shared/shared.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

FirebaseAnalytics _analytics = FirebaseAnalytics();

class DonateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getProviderName(String provider) {
      switch (provider) {
        case "orange":
          return "Orange Money";
        case "mtn":
          return "MTN MoMo";
        case "djamo":
          return "Transfert Djamo";
      }
    }

    getProviderInstruction(String provider) {
      switch (provider) {
        case "orange":
          return "Vous aurez à faire un dépot ou transfert du montant de votre choix au ${DateTime.now().isAfter(DateTime(2021, 1, 31, 0, 0, 0)) ? "0768474115" : "68474115"}";
        case "mtn":
          return "Vous aurez à faire un dépot ou transfert du montant de votre choix au ${DateTime.now().isAfter(DateTime(2021, 1, 31, 0, 0, 0)) ? "0554189332" : "54189332"}";
        case "djamo":
          return "Vous aurez à faire un Transfert Djamo du montant de votre choix au ${DateTime.now().isAfter(DateTime(2021, 1, 31, 0, 0, 0)) ? "0768474115" : "68474115"}";
      }
    }

    void getProviderAction(String provider) async {
      switch (provider) {
        case "orange":
          final String url =
              "tel://%23144*1*1*${DateTime.now().isAfter(DateTime(2021, 1, 31, 0, 0, 0)) ? "0768474115" : "68474115"}#";
          if (await canLaunch(url)) {
            _analytics.logSelectContent(
                contentType: "button", itemId: "donate_with_orange_money");
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
          break;
        case "mtn":
          final String url = "tel://*133#";
          if (await canLaunch(url)) {
            _analytics.logSelectContent(
                contentType: "button", itemId: "donate_with_mtnmomo");
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
          break;
        case "djamo":
          final String url = "com.djamo.app://";
          if (await canLaunch(url)) {
            _analytics.logSelectContent(
                contentType: "button", itemId: "donate_with_djamo");
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
          break;
      }
    }

    void displayDialog(String provider) {
      Get.dialog<bool>(
        AlertDialog(
          title: BlouText(
              text: "Don via ${getProviderName(provider)}",
              fontSize: 25,
              textAlign: TextAlign.left),
          content: Container(
              height: 150,
              child: Column(children: [
                BlouText(text: getProviderInstruction(provider))
              ])),
          actions: <Widget>[
            InkWell(
              child: Container(
                  child: BlouText(text: "Annuler"),
                  padding: EdgeInsets.all(10)),
              onTap: () {
                Get.back();
              },
            ),
            InkWell(
              child: Container(
                  child: BlouText(text: "OK"), padding: EdgeInsets.all(10)),
              onTap: () => getProviderAction(provider),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: BlouColors.GreyBgColor,
          elevation: 0,
          title: BlouText(text: "Faire un don"),
        ),
        backgroundColor: BlouColors.GreyBgColor,
        body: SafeArea(
            minimum: EdgeInsets.all(10),
            child: Center(
                child: SingleChildScrollView(
                    child: Column(children: [
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 3,
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: SvgPicture.asset("assets/icons/like.svg",
                                  width: 100)),
                          BlouText(
                              fontSize: 15,
                              text:
                                  "Vous aimer cette application et vous voulez nous encourager :",
                              textAlign: TextAlign.center,
                              type: "bold"),
                          Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                          BlouButton(
                              label: "Djamo",
                              onPressed: () => displayDialog("djamo")),
                          BlouButton(
                              label: "Orange Money",
                              bgColor: Colors.orange,
                              onPressed: () => displayDialog("orange")),
                          BlouButton(
                              label: "MTN MoMo",
                              bgColor: Colors.yellow,
                              labelColor: Colors.black,
                              onPressed: () => displayDialog("mtn")),
                        ],
                      )))
            ])))));
  }
}
