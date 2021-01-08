import 'dart:io';

import 'package:zocontact/blocs/blocs.dart';
import 'package:zocontact/models/models.dart';
import 'package:zocontact/screens/screens.dart';
import 'package:zocontact/shared/button.dart';
import 'package:zocontact/shared/shared.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

FirebaseAnalytics _analytics = FirebaseAnalytics();

class ContactsConvertionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _analytics.setCurrentScreen(screenName: "ContactsConvertionScreen");
    final double width = MediaQuery.of(context).size.width;
    final DateTime migrationDate = DateTime(2021, 1, 31, 0, 0, 0);
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ContactPermissionBloc(),
          ),
        ],
        child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
                child: Column(children: [
              BlocBuilder<ConfigBloc, ConfigState>(
                  builder: (context, configState) {
                if (configState is ConfigReadSuccess) {
                  return BlocConsumer<ContactPermissionBloc,
                          ContactPermissionState>(
                      listener: (context, contactPermissionState) {
                    if (contactPermissionState is ContactPermissionSuccess) {
                      BlocProvider.of<ContactListBloc>(context)
                          .add(ContactListReaded(refreshed: true));
                    }
                  }, builder: (context, contactPermissionState) {
                    if (contactPermissionState is ContactPermissionInitial) {
                      BlocProvider.of<ContactPermissionBloc>(context)
                          .add(ContactPermissionStatusAsked());
                    }
                    if (contactPermissionState is ContactPermissionSuccess) {
                      return BlocConsumer<ContactListBloc, ContactListState>(
                          listener: (context, contactListState) {
                        if (contactListState is ContactListSuccess) {
                          _analytics.logSelectContent(
                              contentType: "load",
                              itemId:
                                  "loaded_contacts_${contactListState.contacts.length}");
                        }
                      }, builder: (context, contactListState) {
                        if (contactListState is ContactListInitial) {
                          BlocProvider.of<ContactListBloc>(context)
                              .add(ContactListReaded(refreshed: false));
                        }
                        if (contactListState is ContactListInProgress) {
                          return Center(
                              child: Container(
                            margin: EdgeInsets.only(
                                top: width / 1.5, left: 10, right: 10),
                            child: Column(children: [
                              Loader(width: 50),
                              BlouText(
                                  text:
                                      "Chargement de vos contacts, veuillez patienter.\n Ceci n'aura lieu qu'une seule fois.",
                                  textAlign: TextAlign.center),
                              BlouText(
                                  text:
                                      "Si le chargement prend trop de temps, verifiez l'autorisation et redémarrer l'application.",
                                  textAlign: TextAlign.center,
                                  fontSize: 12)
                            ]),
                          ));
                        }
                        if (contactListState is ContactListSuccess) {
                          final contacts = contactListState.contacts;
                          List<BlouContact> unConvertedContacts = contacts
                              .where((element) =>
                                  element.phone != element.convertedPhone)
                              .toList();
                          List<BlouContact> unConvertedOrangeContacts =
                              unConvertedContacts.isNotEmpty
                                  ? unConvertedContacts
                                      .where((element) =>
                                          element.carrierName.toUpperCase() ==
                                          "ORANGE")
                                      .toList()
                                  : [];
                          List<BlouContact> unConvertedMTNContacts =
                              unConvertedContacts.isNotEmpty
                                  ? unConvertedContacts
                                      .where((element) =>
                                          element.carrierName.toUpperCase() ==
                                          "MTN")
                                      .toList()
                                  : [];
                          List<BlouContact> unConvertedMoovContacts =
                              unConvertedContacts.isNotEmpty
                                  ? unConvertedContacts
                                      .where((element) =>
                                          element.carrierName.toUpperCase() ==
                                          "MOOV")
                                      .toList()
                                  : [];
                          return Container(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Visibility(
                                    visible: unConvertedContacts.isNotEmpty,
                                    child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 5),
                                                  child: BlouText(
                                                    text:
                                                        "${unConvertedContacts.length} CONTACTS",
                                                    type: "bold",
                                                    color: BlouColors
                                                        .DarkBlueColor,
                                                    fontSize: 30,
                                                  )),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    unConvertedOrangeContacts
                                                            .isEmpty
                                                        ? Container()
                                                        : CarrierCard(
                                                            BlouColors
                                                                .LightOrangeColor,
                                                            BlouColors
                                                                .OrangeColor,
                                                            child: Container(
                                                                child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                  Container(
                                                                      child: BlouText(
                                                                          type:
                                                                              "bold",
                                                                          fontSize:
                                                                              20,
                                                                          color: BlouColors
                                                                              .DarkBlueColor,
                                                                          text: unConvertedOrangeContacts.isNotEmpty
                                                                              ? "${unConvertedOrangeContacts.length}"
                                                                              : "0")),
                                                                  Container(
                                                                      margin: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              10),
                                                                      child: BlouText(
                                                                          type:
                                                                              "light",
                                                                          fontSize:
                                                                              12,
                                                                          color: BlouColors
                                                                              .DarkBlueColor,
                                                                          text:
                                                                              "Numéro${unConvertedOrangeContacts.length == 1 ? "" : "s"} \nOrange"))
                                                                ]))),
                                                    CarrierCard(
                                                        BlouColors
                                                            .LightYellowColor,
                                                        BlouColors.YellowColor,
                                                        child: Container(
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                              Container(
                                                                  child: BlouText(
                                                                      type:
                                                                          "bold",
                                                                      fontSize:
                                                                          20,
                                                                      color: BlouColors
                                                                          .DarkBlueColor,
                                                                      text: unConvertedMTNContacts
                                                                              .isNotEmpty
                                                                          ? "${unConvertedMTNContacts.length}"
                                                                          : "0")),
                                                              Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              10),
                                                                  child: BlouText(
                                                                      type:
                                                                          "light",
                                                                      fontSize:
                                                                          12,
                                                                      color: BlouColors
                                                                          .DarkBlueColor,
                                                                      text:
                                                                          "Numéro${unConvertedMTNContacts.length == 1 ? "" : "s"} \nMTN"))
                                                            ]))),
                                                    CarrierCard(
                                                        BlouColors
                                                            .LightGreenColor,
                                                        BlouColors.GreenColor,
                                                        child: Container(
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                              Container(
                                                                  child: BlouText(
                                                                      type:
                                                                          "bold",
                                                                      fontSize:
                                                                          20,
                                                                      color: BlouColors
                                                                          .DarkBlueColor,
                                                                      text: unConvertedMoovContacts
                                                                              .isNotEmpty
                                                                          ? "${unConvertedMoovContacts.length}"
                                                                          : "0")),
                                                              Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              10),
                                                                  child: BlouText(
                                                                      type:
                                                                          "light",
                                                                      fontSize:
                                                                          12,
                                                                      color: BlouColors
                                                                          .DarkBlueColor,
                                                                      text:
                                                                          "Numéro${unConvertedMoovContacts.length == 1 ? "" : "s"} \nMTN"))
                                                            ])))
                                                  ])
                                            ]))),
                                _ConversionStartedWidget(
                                    unConvertedContacts, configState.config),
                                Container(
                                    width: width,
                                    height: width / 4,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        color: BlouColors.LightBlueColor),
                                    child: Container(
                                        margin: EdgeInsets.all(5),
                                        /*  padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5), */
                                        /*  width: width,
                          // height: width / 4,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.white) */
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Container(
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                          child: BlouText(
                                                        text:
                                                            "Nouvelle numérotation",
                                                        type: "medium",
                                                        fontSize: 15,
                                                        textAlign:
                                                            TextAlign.left,
                                                        color: BlouColors
                                                            .DarkBlueColor,
                                                      )),
                                                      Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5),
                                                          child: BlouText(
                                                            text: DateTime.now()
                                                                    .isAfter(
                                                                        migrationDate)
                                                                ? "La nouvelle numérotation est en vigueur, veuillez migrer vos contacts pour continuer à les appelés"
                                                                : "Il vous reste ${migrationDate.day - DateTime.now().day} jours avant le passage à la nouvelle numérotation",
                                                            type: "medium",
                                                            fontSize: 10,
                                                            textAlign:
                                                                TextAlign.left,
                                                            color: BlouColors
                                                                .DarkBlueColor,
                                                          ))
                                                    ])))))
                              ]));
                        }
                        if (contactListState is ContactListFailure) {
                          return Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                BlouText(
                                    text:
                                        "Aucun contact à convertir disponible"),
                                BlouButton(
                                    label: "Actualiser",
                                    onPressed: () {
                                      BlocProvider.of<ContactListBloc>(context)
                                          .add(ContactListReaded(
                                              refreshed: true));
                                      _analytics.logSelectContent(
                                          contentType: "button",
                                          itemId: "refresh_contacts");
                                    })
                              ]));
                        }
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Loader(width: 50),
                              BlouButton(
                                  label: "Actualiser",
                                  onPressed: () {
                                    BlocProvider.of<ContactListBloc>(context)
                                        .add(
                                            ContactListReaded(refreshed: true));
                                    _analytics.logSelectContent(
                                        contentType: "button",
                                        itemId: "refresh_contacts");
                                  })
                            ]);
                      });
                    }

                    if (contactPermissionState is ContactPermissionFailure) {
                      return Center(child: _FailureContactPermissionWidget());
                    }
                    return Center(child: Loader(width: 50));
                  });
                } else {
                  return Center(child: Loader());
                }
              })

              /*   BlouText(
                           text: "Cette fonctionnalité est uniquement réservée au premium.",
                           color: Colors.black,
                           textAlign: TextAlign.center,
                         ) */
            ]))));
  }
}

class _ConversionStartedWidget extends StatelessWidget {
  final List<BlouContact> unConvertedContacts;
  final Config config;
  const _ConversionStartedWidget(this.unConvertedContacts, this.config);
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return BlocConsumer<PhoneBookConversionBloc, PhoneBookConversionState>(
        listener: (context, phoneBookConversionState) {
      if (phoneBookConversionState is PhoneBookConversionDone) {
        Future.delayed(Duration(seconds: 3), () {
          BlocProvider.of<ContactListBloc>(context)
              .add(ContactListReaded(refreshed: true));
        });
      } else if (phoneBookConversionState is PhoneBookConversionSuccess) {}
    }, builder: (context, phoneBookConversionState) {
      return Column(children: [
        phoneBookConversionState is PhoneBookConversionDone
            ? BlouText(
                text: "La migration de vos contacts est terminée.",
                textAlign: TextAlign.center,
                fontSize: 15,
              )
            : Container(),
        Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(children: [
              Container(
                  width: width,
                  height: width / 3.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: BlouColors.LightBlueColor),
                  child: Container(
                      margin: EdgeInsets.all(5),
                      width: width,
                      height: width / 3.5,
                      /*  alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: BlouColors.DarkBlueColor), */
                      child: FlatButton(
                          padding: EdgeInsets.all(0),
                          onLongPress: unConvertedContacts.isEmpty
                              ? () {
                                  BlocProvider.of<PhoneBookConversionBloc>(
                                          context)
                                      .add(PhoneBookConversionHardRestored());
                                }
                              : null,
                          onPressed: phoneBookConversionState
                                  is PhoneBookConversionSuccess
                              ? null
                              : unConvertedContacts.isEmpty
                                  ? () {
                                      BlocProvider.of<PhoneBookConversionBloc>(
                                              context)
                                          .add(PhoneBookConversionRestored());
                                    }
                                  : config.unlocked
                                      ? () {
                                          Get.dialog<bool>(
                                            AlertDialog(
                                              title: BlouText(
                                                  text:
                                                      "Convertir mon répertoire",
                                                  fontSize: 25,
                                                  textAlign: TextAlign.left),
                                              content: Container(
                                                  height: 150,
                                                  child: Column(children: [
                                                    BlouText(
                                                        text:
                                                            "Êtes vous sûr de vouloir convertir votre répertoire maintenant? Cette action peut prendre plusieurs minutes."),
                                                    BlouText(
                                                        text:
                                                            "Si vous avez des doûtes, Faites une sauvegarde de votre répertoire avant de continuer.",
                                                        type: "bold",
                                                        fontSize: 12)
                                                  ])),
                                              actions: <Widget>[
                                                InkWell(
                                                  child: Container(
                                                      child:
                                                          BlouText(text: "Non"),
                                                      padding:
                                                          EdgeInsets.all(10)),
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    _analytics.logSelectContent(
                                                        contentType: "button",
                                                        itemId:
                                                            "convert_phone_book_cancelled");
                                                  },
                                                ),
                                                InkWell(
                                                  child: Container(
                                                      child:
                                                          BlouText(text: "Oui"),
                                                      padding:
                                                          EdgeInsets.all(10)),
                                                  onTap: () {
                                                    BlocProvider.of<
                                                                PhoneBookConversionBloc>(
                                                            context)
                                                        .add(PhoneBookConversionAsked(
                                                            this.unConvertedContacts));
                                                    Navigator.of(context).pop();
                                                    _analytics.logSelectContent(
                                                        contentType: "button",
                                                        itemId:
                                                            "convert_phone_book_started");
                                                  },
                                                ),
                                              ],
                                            ),
                                            barrierDismissible: false,
                                          );
                                        }
                                      : () async {
                                          final data = await Get.to(
                                              UnlockScreen(config.userKey
                                                  .toUpperCase()));
                                          if (data == true) {
                                            BlocProvider.of<ConfigBloc>(context)
                                                .add(ConfigLocalAsked());
                                          }
                                        },
                          child: Card(
                              elevation: 3,
                              color: BlouColors.DarkBlueColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: phoneBookConversionState
                                      is PhoneBookConversionSuccess
                                  ? Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                          Container(
                                              height: 80,
                                              alignment: Alignment.topLeft,
                                              child: BlouText(
                                                text:
                                                    unConvertedContacts.isEmpty
                                                        ? "8"
                                                        : "10",
                                                type: "bold",
                                                fontSize: 100,
                                                color: Colors.black,
                                              )),
                                          Container(
                                              alignment: Alignment.center,
                                              child: Loader())
                                        ])
                                  : Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                          Container(
                                              height: 80,
                                              alignment: Alignment.topLeft,
                                              child: BlouText(
                                                text:
                                                    unConvertedContacts.isEmpty
                                                        ? "8"
                                                        : "10",
                                                type: "bold",
                                                fontSize: 100,
                                                color: Colors.black,
                                              )),
                                          Container(
                                              alignment: Alignment.center,
                                              child: BlouText(
                                                text:
                                                    unConvertedContacts.isEmpty
                                                        ? "Passer à 8"
                                                        : "Passer à 10",
                                                type: "bold",
                                                fontSize: 35,
                                                color: Colors.white,
                                                textAlign: TextAlign.center,
                                              ))
                                        ])))))
              /* BlouText(
                      text:
                          phoneBookConversionState is PhoneBookConversionSuccess
                              ? "Migration en cours."
                              : "Démarrer",
                      fontSize: 20) */
            ])),
        phoneBookConversionState is PhoneBookConversionFailure
            ? Column(children: [
                BlouText(
                  text:
                      "Un problème est survenu lors de la migration de vos contacts, veuillez actualiser la liste de vos contacts et réessayer.",
                  color: Colors.red,
                  textAlign: TextAlign.center,
                  fontSize: 15,
                ),
                BlouButton(
                  label: "Actualiser",
                  type: "flat",
                  labelColor: BlouColors.DarkBlueColor,
                  onPressed: () {
                    BlocProvider.of<ContactListBloc>(context)
                        .add(ContactListReaded(refreshed: true));
                    BlocProvider.of<PhoneBookConversionBloc>(context)
                        .add(PhoneBookConversionCleared());
                  },
                )
              ])
            : Container(),
      ]);
    });
  }
}
/* class _SearchContactInputWdget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactPermissionBloc, ContactPermissionState>(
        builder: (context, contactPermissionState) {
      if (contactPermissionState is ContactPermissionSuccess) {
        return BlocBuilder<ContactListBloc, ContactListState>(
            builder: (context, contactListState) {
          if (contactListState is ContactListSuccess) {
            return Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: BlouTextField(
                    hintText: "Rechercher un contact",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    onChanged: (text) {
                      BlocProvider.of<ContactListBloc>(context).add(
                          ContactListSearchedSelected(contactListState.contacts,
                              contactListState.contacts, text));
                    },
                    suffixIcon: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          BlocProvider.of<ContactListBloc>(context).add(
                              ContactListRestored(contactListState.contacts));
                        })));
          }
          return Container();
        });
      }
      return Container();
    });
  }
} */

class _FailureContactPermissionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactPermissionBloc, ContactPermissionState>(
        builder: (context, contactPermissionState) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        BlouText(
            text: "Veuillez autoriser l'accès à vos contacts pour continuer",
            textAlign: TextAlign.center),
        BlouButton(
            label: "Autoriser",
            onPressed: () => BlocProvider.of<ContactPermissionBloc>(context)
                .add(ContactPermissionRequested()))
      ]);
    });
  }
}

class _PremiumActivationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc, ConfigState>(
        builder: (context, configState) {
      if (configState is ConfigReadSuccess) {
        return Center(
            child: Column(children: [
          BlouText(
              text:
                  "Vous devez débloquer la convertion automatique du répertoire.",
              type: "medium",
              textAlign: TextAlign.center),
          Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: BlouText(
                  text:
                      "Identifiant: ${configState.config.userKey.toUpperCase()}",
                  type: "bold",
                  textAlign: TextAlign.center)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlouButton(
                onPressed: () {
                  Get.dialog<bool>(AlertDialog(
                    title: BlouText(
                        text: "Demander un code",
                        fontSize: 25,
                        textAlign: TextAlign.left),
                    content: Container(
                        height: 250,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              BlouText(
                                  text:
                                      "Choisissez un moyen pour obtenir votre code d'activation",
                                  fontSize: 15),
                              Container(
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  child: Wrap(children: [
                                    FlatButton(
                                        onPressed: () async {
                                          final String url =
                                              "tg://msg?url=https://t.me/bloucontact_bot&text=/start";
                                          if (await canLaunch(url)) {
                                            _analytics.logSelectContent(
                                                contentType: "button",
                                                itemId:
                                                    "activate_with_telegram");
                                            await launch(
                                                "https://t.me/bloucontact_bot?text=/start");
                                          } else {
                                            await launch(url);
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        child: Column(children: [
                                          Image.asset("assets/img/telegram.png",
                                              width: 50),
                                          Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: BlouText(
                                                  text: "Telegram",
                                                  fontSize: 12))
                                        ])),
                                    FlatButton(
                                        onPressed: () async {
                                          final String body = Uri.encodeComponent(
                                                  "Bonjour,je voudrais activé mon BlouContact, mon identifiant est:${configState.config.userKey.toUpperCase()}.Merci")
                                              .toString();

                                          String url() {
                                            if (Platform.isIOS) {
                                              return "whatsapp://wa.me/${DateTime.now().isAfter(DateTime(2021, 1, 31, 0, 0, 0)) ? Platform.isAndroid ? "+2250554189332" : "002250554189332" : Platform.isAndroid ? "+22554189332" : "0022554189332"}/?text=$body";
                                            } else {
                                              return "whatsapp://send?phone=${DateTime.now().isAfter(DateTime(2021, 1, 31, 0, 0, 0)) ? Platform.isAndroid ? "+2250554189332" : "002250554189332" : Platform.isAndroid ? "+22554189332" : "0022554189332"}&text=$body";
                                            }
                                          }

                                          if (await canLaunch(url())) {
                                            _analytics.logSelectContent(
                                                contentType: "button",
                                                itemId:
                                                    "activate_with_whatsapp");
                                            await launch(url());
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        child: Column(children: [
                                          Image.asset("assets/img/whatsapp.png",
                                              width: 50),
                                          Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: BlouText(
                                                  text: "Whatsapp",
                                                  fontSize: 12))
                                        ])),
                                    FlatButton(
                                        onPressed: () async {
                                          final String url =
                                              "https://www.facebook.com/bloucontact/";
                                          if (await canLaunch(url)) {
                                            _analytics.logSelectContent(
                                                contentType: "button",
                                                itemId:
                                                    "activate_with_fbmessenger");
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        child: Column(children: [
                                          Image.asset(
                                              "assets/img/messenger.png",
                                              width: 50),
                                          Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: BlouText(
                                                  text: "Messenger",
                                                  fontSize: 12))
                                        ])),
                                    FlatButton(
                                        onPressed: () async {
                                          final String body = Uri.encodeComponent(
                                                  "Bonjour,je voudrais activé mon BlouContact, mon identifiant est:${configState.config.userKey.toUpperCase()}. Merci")
                                              .toString();
                                          if (Platform.isAndroid) {
                                            final String url =
                                                "sms:${DateTime.now().isAfter(DateTime(2021, 1, 31, 0, 0, 0)) ? "+2250554189332" : "+22554189332"}?body=$body";
                                            if (await canLaunch(url)) {
                                              _analytics.logSelectContent(
                                                  contentType: "button",
                                                  itemId: "activate_with_sms");
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          } else {
                                            final String url =
                                                "sms:${DateTime.now().isAfter(DateTime(2021, 1, 31, 0, 0, 0)) ? "002250554189332" : "+22554189332"}&body=$body";
                                            if (await canLaunch(url)) {
                                              _analytics.logSelectContent(
                                                  contentType: "button",
                                                  itemId: "activate_with_sms");
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          }
                                        },
                                        child: Column(children: [
                                          Icon(Icons.message, size: 50),
                                          Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: BlouText(
                                                  text: "Sms", fontSize: 12))
                                        ])),
                                  ]))
                            ])),
                    actions: <Widget>[
                      InkWell(
                        child: Container(
                            child: BlouText(text: "Annuler"),
                            padding: EdgeInsets.all(10)),
                        onTap: () {
                          Navigator.of(context).pop();
                          _analytics.logSelectContent(
                              contentType: "button",
                              itemId: "activation_code_popup_cancelled");
                        },
                      )
                    ],
                  ));
                },
                label: "Demander un code",
                width: 100,
                bgColor: BlouColors.BlueColor,
              ),
              BlouButton(
                  onPressed: () async {
                    final data = await Get.to(
                        UnlockScreen(configState.config.userKey.toUpperCase()));
                    if (data == true) {
                      BlocProvider.of<ConfigBloc>(context)
                          .add(ConfigLocalAsked());
                    }
                  },
                  label: "Débloquer",
                  width: 100,
                  bgColor: BlouColors.GreenColor)
            ],
          )
        ]));
      }
      return Container();
    });
  }
}
