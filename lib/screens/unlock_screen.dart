import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zocontact/blocs/blocs.dart';
import 'package:zocontact/repositories/config_repository.dart';
import 'package:zocontact/screens/screens.dart';
import 'package:zocontact/shared/button.dart';
import 'package:zocontact/shared/code_text_field.dart';
import 'package:zocontact/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

FirebaseAnalytics _analytics = FirebaseAnalytics();

class UnlockScreen extends StatelessWidget {
  final String userKey;
  const UnlockScreen(this.userKey);
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    TextEditingController controller = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: BlouColors.DarkBlueColor),
          toolbarHeight: 50,
        ),
        backgroundColor: Colors.white,
        body: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) =>
                      UnlockBloc(repository: ConfigRepository())),
              BlocProvider(
                  create: (context) =>
                      ConfigBloc(repository: ConfigRepository())),
              BlocProvider(create: (context) => CodeInputBloc(5))
            ],
            child: SafeArea(
                child: Column(children: [
              Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.fromLTRB(15, 0, 0, 15),
                  color: Colors.white,
                  height: 30,
                  child: BlouText(
                      text: "Code d'activation",
                      type: "bold",
                      color: BlouColors.DarkBlueColor,
                      fontSize: 30)),
              Flexible(
                  child: Container(
                      width: width,
                      height: height,
                      color: BlouColors.GreyBgColor,
                      child: SingleChildScrollView(
                          child: Column(children: [
                        BlocListener<ConfigBloc, ConfigState>(
                            listener: (context, configState) {
                              if (configState is ConfigUnlockWrittenSuccess) {
                                BlocProvider.of<ConfigBloc>(context)
                                    .add(ConfigLocalAsked());
                              } else if (configState is ConfigReadSuccess) {
                                Future.delayed(Duration(milliseconds: 500),
                                    () => Get.back(result: true));
                              }
                            },
                            child: BlocConsumer<UnlockBloc, UnlockState>(
                                listener: (context, unlockState) {
                              if (unlockState is ActivationSuccess) {
                                BlocProvider.of<ConfigBloc>(context)
                                    .add(ConfigUnlockWritten());
                              }
                            }, builder: (context, unlockState) {
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 30),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            color: BlouColors.LightBlueColor),
                                        child: Container(
                                            margin: EdgeInsets.all(10),
                                            width: width,
                                            child: Column(children: [
                                              BlouText(
                                                  text: "Votre identifiant",
                                                  type: "bold",
                                                  color:
                                                      BlouColors.DarkBlueColor,
                                                  fontSize: 20),
                                              BlouText(
                                                  text: this.userKey,
                                                  type: "bold",
                                                  color:
                                                      BlouColors.DarkBlueColor,
                                                  fontSize: 20),
                                              Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: BlouText(
                                                      text:
                                                          "Veuillez entrer votre code d'activation",
                                                      type: "medium",
                                                      color: BlouColors
                                                          .DarkBlueColor,
                                                      fontSize: 15)),
                                              Container(
                                                  width: width,
                                                  height: width / 4,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      color: BlouColors
                                                          .LightBlueColor),
                                                  child: Container(
                                                      margin: EdgeInsets.all(5),
                                                      child: Card(
                                                          shadowColor: BlouColors
                                                              .DarkBlueColor,
                                                          elevation: 4,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          child: Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          40,
                                                                      vertical:
                                                                          10),
                                                              child:
                                                                  CodeTextFieldWidget(
                                                                controller:
                                                                    controller,
                                                                obscureText:
                                                                    false,
                                                              )))))
                                            ]))),
                                    /* Expanded(
                                    child: Column(children: [
                                  BlouText(
                                      text:
                                          "Entrez votre code d'activation $userKey",
                                      type: "medium",
                                      textAlign: TextAlign.center),
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: BlouTextField(
                                          autofocus: true,
                                          hintText: "Code d'activation",
                                          keyboardType: TextInputType.text,
                                          maxLength: 5,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          prefixIcon: Container(
                                              width: 10,
                                              child: SvgPicture.asset(
                                                  "assets/icons/edition.svg",
                                                  width: 10)),
                                          onChanged: (text) {
                                            BlocProvider.of<UnlockBloc>(context)
                                                .add(ActivationCodeEntered(
                                                    text));
                                          }))
                                ])), */
                                    Visibility(
                                        visible:
                                            unlockState is ActivationFailure,
                                        child: BlouText(
                                            color: Colors.red,
                                            text:
                                                "Echec d'activation, vérifiez le code entrer.",
                                            fontSize: 15)),
                                    Visibility(
                                        visible:
                                            unlockState is ActivationSuccess,
                                        child: BlouText(
                                            color: Colors.green,
                                            text:
                                                "L'activation de BlouContact a réussi")),
                                    BlocConsumer<CodeInputBloc, CodeInputState>(
                                        listener: (context, codeInputState) {
                                      // this.controller.text = state.code;
                                      if (codeInputState is CodeInputSuccess &&
                                          codeInputState.code.length == 5) {
/* BlocProvider.of<UnlockBloc>(
                                                          context)
                                                      .add(ActivationCodeRequested(
                                                          this.userKey,
                                                         codeInputState.code)); */
                                      }
                                    }, builder: (context, codeInputState) {
                                      return BlouButton(
                                          label: "Activer",
                                          labelFontSize: 25,
                                          labelType: "bold",
                                          bgColor: BlouColors.OrangeColor,
                                          onPressed: codeInputState
                                                      is CodeInputSuccess &&
                                                  codeInputState.code.length ==
                                                      5
                                              ? () {
                                                  BlocProvider.of<UnlockBloc>(
                                                          context)
                                                      .add(
                                                          ActivationCodeRequested(
                                                              this.userKey,
                                                              codeInputState
                                                                  .code));
                                                }
                                              : null);
                                    }),
                                    Container(
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            BlouText(
                                                color: BlouColors.DarkBlueColor,
                                                type: "medium",
                                                text:
                                                    "Vous n'avez pas de code ? ",
                                                fontSize: 15),
                                            InkWell(
                                                onTap: () {
                                                  Get.dialog<bool>(AlertDialog(
                                                    title: BlouText(
                                                        text:
                                                            "Demander un code",
                                                        fontSize: 25,
                                                        textAlign:
                                                            TextAlign.left),
                                                    content: Container(
                                                        height: 250,
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              BlouText(
                                                                  text:
                                                                      "Choisissez un moyen pour obtenir votre code d'activation",
                                                                  fontSize: 15),
                                                              Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              20),
                                                                  child: Wrap(
                                                                      children: [
                                                                        FlatButton(
                                                                            onPressed:
                                                                                () async {
                                                                              final String url = "tg://msg?url=https://t.me/bloucontact_bot&text=/start";
                                                                              if (await canLaunch(url)) {
                                                                                _analytics.logSelectContent(contentType: "button", itemId: "activate_with_telegram");
                                                                                await launch("https://t.me/bloucontact_bot?text=/start");
                                                                              } else {
                                                                                await launch(url);
                                                                                throw 'Could not launch $url';
                                                                              }
                                                                            },
                                                                            child:
                                                                                Column(children: [
                                                                              Image.asset("assets/img/telegram.png", width: 50),
                                                                              Container(margin: EdgeInsets.symmetric(vertical: 10), child: BlouText(text: "Telegram", fontSize: 12))
                                                                            ])),
                                                                        FlatButton(
                                                                            onPressed:
                                                                                () async {
                                                                              final String body = Uri.encodeComponent("Bonjour,je voudrais activé mon BlouContact, mon identifiant est:${this.userKey.toUpperCase()}.Merci").toString();

                                                                              String url() {
                                                                                if (Platform.isIOS) {
                                                                                  return "whatsapp://wa.me/${DateTime.now().isAfter(DateTime(2021, 1, 31, 0, 0, 0)) ? Platform.isAndroid ? "+2250554189332" : "002250554189332" : Platform.isAndroid ? "+22554189332" : "0022554189332"}/?text=$body";
                                                                                } else {
                                                                                  return "whatsapp://send?phone=${DateTime.now().isAfter(DateTime(2021, 1, 31, 0, 0, 0)) ? Platform.isAndroid ? "+2250554189332" : "002250554189332" : Platform.isAndroid ? "+22554189332" : "0022554189332"}&text=$body";
                                                                                }
                                                                              }

                                                                              if (await canLaunch(url())) {
                                                                                _analytics.logSelectContent(contentType: "button", itemId: "activate_with_whatsapp");
                                                                                await launch(url());
                                                                              } else {
                                                                                throw 'Could not launch $url';
                                                                              }
                                                                            },
                                                                            child:
                                                                                Column(children: [
                                                                              Image.asset("assets/img/whatsapp.png", width: 50),
                                                                              Container(margin: EdgeInsets.symmetric(vertical: 10), child: BlouText(text: "Whatsapp", fontSize: 12))
                                                                            ])),
                                                                        FlatButton(
                                                                            onPressed:
                                                                                () async {
                                                                              final String url = "https://www.facebook.com/bloucontact/";
                                                                              if (await canLaunch(url)) {
                                                                                _analytics.logSelectContent(contentType: "button", itemId: "activate_with_fbmessenger");
                                                                                await launch(url);
                                                                              } else {
                                                                                throw 'Could not launch $url';
                                                                              }
                                                                            },
                                                                            child:
                                                                                Column(children: [
                                                                              Image.asset("assets/img/messenger.png", width: 50),
                                                                              Container(margin: EdgeInsets.symmetric(vertical: 10), child: BlouText(text: "Messenger", fontSize: 12))
                                                                            ])),
                                                                        FlatButton(
                                                                            onPressed:
                                                                                () async {
                                                                              final String body = Uri.encodeComponent("Bonjour,je voudrais activé mon BlouContact, mon identifiant est:${this.userKey.toUpperCase()}. Merci").toString();
                                                                              if (Platform.isAndroid) {
                                                                                final String url = "sms:${DateTime.now().isAfter(DateTime(2021, 1, 31, 0, 0, 0)) ? "+2250554189332" : "+22554189332"}?body=$body";
                                                                                if (await canLaunch(url)) {
                                                                                  _analytics.logSelectContent(contentType: "button", itemId: "activate_with_sms");
                                                                                  await launch(url);
                                                                                } else {
                                                                                  throw 'Could not launch $url';
                                                                                }
                                                                              } else {
                                                                                final String url = "sms:${DateTime.now().isAfter(DateTime(2021, 1, 31, 0, 0, 0)) ? "002250554189332" : "+22554189332"}&body=$body";
                                                                                if (await canLaunch(url)) {
                                                                                  _analytics.logSelectContent(contentType: "button", itemId: "activate_with_sms");
                                                                                  await launch(url);
                                                                                } else {
                                                                                  throw 'Could not launch $url';
                                                                                }
                                                                              }
                                                                            },
                                                                            child:
                                                                                Column(children: [
                                                                              Icon(Icons.message, size: 50),
                                                                              Container(margin: EdgeInsets.symmetric(vertical: 10), child: BlouText(text: "Sms", fontSize: 12))
                                                                            ])),
                                                                      ]))
                                                            ])),
                                                    actions: <Widget>[
                                                      InkWell(
                                                        child: Container(
                                                            child: BlouText(
                                                                text:
                                                                    "Annuler"),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10)),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          _analytics
                                                              .logSelectContent(
                                                                  contentType:
                                                                      "button",
                                                                  itemId:
                                                                      "activation_code_popup_cancelled");
                                                        },
                                                      )
                                                    ],
                                                  ));
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: BlouColors
                                                                    .OrangeColor,
                                                                width: 2.0))),
                                                    child: BlouText(
                                                        color: BlouColors
                                                            .OrangeColor,
                                                        type: "bold",
                                                        text:
                                                            "Demander un code",
                                                        fontSize: 15)))
                                          ],
                                        ))
                                  ]);
                            }))
                      ]))))
            ]))));
  }
}
