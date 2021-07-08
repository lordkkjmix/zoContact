import 'dart:typed_data';

import 'package:zocontact/blocs/blocs.dart';
import 'package:zocontact/models/blou_contact.dart';
import 'package:zocontact/shared/shared.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

FirebaseAnalytics _analytics = FirebaseAnalytics();

class ContactDetailScreen extends StatelessWidget {
  final BlouContact blouContact;
  const ContactDetailScreen(this.blouContact);
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    Color getCarrierColor(String carrierName) {
      switch (carrierName.toUpperCase()) {
        case "ORANGE":
          return Color(0xFFf16f02);
        case "MTN":
          return Color(0xFFffcc00);
        case "MOOV":
          return Color(0xFFc4d600);
        default:
          return Colors.black38;
      }
    }

    Future<void> _makePhoneCallAndSendSms(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: BlouColors.GreyBgColor,
          elevation: 0,
          title: BlouText(text: "Détails contact"),
        ),
        backgroundColor: BlouColors.GreyBgColor,
        body: MultiBlocProvider(
            providers: [BlocProvider(create: (context) => PhonePadBloc(8))],
            child: SafeArea(
                minimum: EdgeInsets.all(10),
                child: Center(
                    child: Column(children: [
                  Container(
                      child: Stack(children: [
                    Container(
                        padding: EdgeInsets.only(top: 40),
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 3,
                            child: Container(
                                width: width,
                                height: height / 2,
                                padding: EdgeInsets.only(top: height / 8),
                                child: Column(children: [
                                  BlouText(
                                      text: blouContact.displayName,
                                      type: "medium"),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: BlouText(
                                          text: blouContact.phone !=
                                                  blouContact.convertedPhone
                                              ? blouContact.convertedPhone
                                              : blouContact.phone,
                                          color: Colors.black38,
                                          fontSize: 15)),
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                //crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  BlouText(
                                                      text: "Opérateur " +
                                                          blouContact
                                                              .phoneType),
                                                  BlouText(
                                                      text: blouContact
                                                                      .carrierName !=
                                                                  null &&
                                                              blouContact
                                                                  .carrierName
                                                                  .isNotEmpty
                                                          ? blouContact
                                                              .carrierName
                                                          : "Inconnu",
                                                      color: getCarrierColor(
                                                        blouContact.carrierName,
                                                      ),
                                                      fontSize: 15)
                                                ]),
                                            Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                                alignment: Alignment.center,
                                                height: 60,
                                                child: VerticalDivider(
                                                  color: Colors.grey,
                                                )),
                                            Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    10, 0, 0, 0),
                                                child: Column(children: [
                                                  BlouText(text: "Origine"),
                                                  BlouText(
                                                      text: blouContact.phone,
                                                      color: Colors.black38,
                                                      fontSize: 15)
                                                ])),
                                          ])),
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                                child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    width: 50,
                                                    height: 50,
                                                    decoration: new BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        color: Colors.black12),
                                                    child: IconButton(
                                                        icon: Icon(Icons.sms,
                                                            color: BlouColors
                                                                .GreenColor),
                                                        onPressed: () {
                                                          _makePhoneCallAndSendSms(
                                                              "sms://${blouContact.convertedPhone}");
                                                          _analytics
                                                              .logSelectContent(
                                                                  contentType:
                                                                      "button",
                                                                  itemId:
                                                                      "contact_details_send_sms");
                                                        }))),
                                            Flexible(
                                                child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    width: 50,
                                                    height: 50,
                                                    decoration: new BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        color: Colors.black12),
                                                    child: IconButton(
                                                        icon: Icon(Icons.call,
                                                            color: BlouColors
                                                                .GreenColor),
                                                        onPressed: () {
                                                          _makePhoneCallAndSendSms(
                                                              "tel://${blouContact.convertedPhone}");
                                                          _analytics
                                                              .logSelectContent(
                                                                  contentType:
                                                                      "button",
                                                                  itemId:
                                                                      "contact_details_make_call");
                                                        }))),
                                          ]))
                                ])))),
                    Container(
                        alignment: Alignment.center,
                        child: blouContact.avatar != null &&
                                blouContact.avatar.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(
                                    new Uint8List.fromList(
                                        blouContact.avatar.codeUnits)),
                                radius: 10,
                              )
                            : Container(
                                width: 100,
                                height: 100,
                                decoration: new BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    color: Colors.black12),
                                child: Icon(Icons.person, size: 80)))
                  ]))
                ])))));
  }
}
