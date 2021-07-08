import 'package:zocontact/blocs/blocs.dart';
import 'package:zocontact/repositories/repositories.dart';
import 'package:zocontact/shared/phone_pad.dart';
import 'package:zocontact/shared/shared.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

FirebaseAnalytics _analytics = FirebaseAnalytics();

class MakeCallScreen extends StatelessWidget {
  Future<void> _makePhoneCallAndSendSms(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    _analytics.setCurrentScreen(screenName: "MakeCallScreen");
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => PhonePadBloc(8)),
          BlocProvider(
              create: (context) =>
                  PhoneConverterBloc(repository: ContactListRepository())),
        ],
        child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 10),
            child: Center(
                child: Column(children: [
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    BlocConsumer<PhonePadBloc, PhonePadState>(
                        listener: (context, phonePadState) {
                      if (phonePadState is PhonePadInputSuccess) {
                        BlocProvider.of<PhoneConverterBloc>(context).add(
                            PhoneNumberConvertionAsked(
                                phonePadState.phoneNumber));
                      }
                    }, builder: (context, phonePadState) {
                      if (phonePadState is PhonePadInitial) {
                        BlocProvider.of<PhonePadBloc>(context)
                            .add(PhonePadCleared());
                      }
                      if (phonePadState is PhonePadInputSuccess) {
                        return BlouText(
                            text: phonePadState.phoneNumber,
                            fontSize: 30,
                            color: Colors.black);
                      }
                      return Container();
                    }),
                    BlocBuilder<PhoneConverterBloc, PhoneConverterState>(
                        builder: (context, phoneConverterState) {
                      if (phoneConverterState is PhoneConverterSuccess) {
                        return Column(children: [
                          BlouText(
                              text: phoneConverterState.phoneNumber,
                              fontSize: 20,
                              color: Colors.black38),
                          BlouText(
                              text: phoneConverterState.carrierName,
                              fontSize: 20,
                              color: Colors.black38),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 30),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                        child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            width: 80,
                                            height: 80,
                                            decoration: new BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                                color: Colors.black12),
                                            child: IconButton(
                                                icon: Icon(Icons.sms,
                                                    size: 40,
                                                    color:
                                                        BlouColors.GreenColor),
                                                onPressed: () {
                                                  _makePhoneCallAndSendSms(
                                                          "sms://${phoneConverterState.phoneNumber}")
                                                      .catchError((e) {
                                                    final snackBar = SnackBar(
                                                      content: BlouText(
                                                        text:
                                                            "Impossible d'envoyer un sms pour le moment.",
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                    Scaffold.of(context)
                                                        .showSnackBar(snackBar);
                                                  });
                                                  _analytics.logSelectContent(
                                                      contentType: "button",
                                                      itemId:
                                                          "dialup_send_sms");
                                                }))),
                                    Flexible(
                                        child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            width: 80,
                                            height: 80,
                                            decoration: new BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                                color: Colors.black12),
                                            child: IconButton(
                                                icon: Icon(Icons.call,
                                                    size: 40,
                                                    color:
                                                        BlouColors.GreenColor),
                                                onPressed: () {
                                                  _makePhoneCallAndSendSms(
                                                          "tel://${phoneConverterState.phoneNumber}")
                                                      .catchError((e) {
                                                    final snackBar = SnackBar(
                                                      content: BlouText(
                                                        text:
                                                            "Impossible de lancer l'appel pour le moment.",
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                    Scaffold.of(context)
                                                        .showSnackBar(snackBar);
                                                  });
                                                  _analytics.logSelectContent(
                                                      contentType: "button",
                                                      itemId:
                                                          "dialup_make_call");
                                                }))),
                                  ]))
                        ]);
                      }
                      return Container();
                    })
                  ])),
              Container(
                  padding: EdgeInsets.only(bottom: 50),
                  child: PhonePadWidget())
            ]))));
  }
}
