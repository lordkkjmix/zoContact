import 'package:zocontact/shared/shared.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

FirebaseAnalytics _analytics = FirebaseAnalytics();

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    _analytics.setCurrentScreen(screenName: "AboutScreen");
    return Scaffold(
        appBar: AppBar(
          backgroundColor: BlouColors.GreyBgColor,
          elevation: 0,
          title: BlouText(text: "A propos"),
        ),
        backgroundColor: BlouColors.GreyBgColor,
        body: SafeArea(
            minimum: EdgeInsets.all(10),
            child: Center(
                child: Column(children: [
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 3,
                  child: Container(
                      width: width,
                      height: height / 2,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: "BlouContact ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "est une application simple et rapide à utiliser.",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text:
                                      "Elle vous aide a passer tranquillement la migration vers le nouveau plan de numérotation National(côte d'ivoire).",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text:
                                      "La fonctionnalité principale est de vous permettre de passer vos contacts de 8 chiffres à 10 chiffres et vice-versa.",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text:
                                      "Les fonctionnalités disponibles sont :\n",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text:
                                      "-Un répertoire de numéro déjà converti.\n",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: "-La recherche de contacts\n",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: "-Appeler ou Envoyer un sms.\n",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text:
                                      "-Convertir entièrement et automatiquement son répertoire.\n\n\n",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text:
                                      "BlouContact est une idée pensée et développée par: ",
                                  style: TextStyle(color: Colors.black))
                            ])),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: InkWell(
                                    onTap: () async {
                                      final String url =
                                          "https://bloucontact.page.link/rniX";
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: BlouText(
                                        text: "DigitApp CI",
                                        color: Colors.blue,
                                        fontSize: 18)))
                          ])))
            ]))));
  }
}
