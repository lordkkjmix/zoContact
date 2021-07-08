import 'dart:typed_data';

import 'package:zocontact/blocs/blocs.dart';
import 'package:zocontact/models/blou_contact.dart';
import 'package:zocontact/screens/screens.dart';
import 'package:zocontact/shared/button.dart';
import 'package:zocontact/shared/colors.dart';
import 'package:zocontact/shared/loader.dart';
import 'package:zocontact/shared/shared.dart';
import 'package:zocontact/shared/text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

FirebaseAnalytics _analytics = FirebaseAnalytics();

class ContactListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _analytics.setCurrentScreen(screenName: "ContactListScreen");
    final double width = MediaQuery.of(context).size.width;

    return SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 10),
            child:
                /* SingleChildScrollView(
                child: Column(children: [
              SearchContactInputWdget(), */
                BlocConsumer<ContactPermissionBloc, ContactPermissionState>(
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
                    return Center(child:Container(
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
                    return _ContactListWidget(contactListState.contacts);
                  }
                  if (contactListState is ContactListFailure) {
                    return Center(
                        child: BlouText(text: "Aucun contact disponible"));
                  }
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Loader(width: 50)]);
                });
              }

              if (contactPermissionState is ContactPermissionFailure) {
                return Center(child:_FailureContactPermissionWidget());
              }
              return Center(child: Loader(width: 50));
            })
            /* ])) */);
  }
}

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
            onPressed: () {
              BlocProvider.of<ContactPermissionBloc>(context)
                  .add(ContactPermissionRequested());
              _analytics.logSelectContent(
                  contentType: "button", itemId: "allow_contacts");
            })
      ]);
    });
  }
}

class _ContactListWidget extends StatefulWidget {
  final List<BlouContact> contacts;
  const _ContactListWidget(this.contacts);
  @override
  __ContactListWidgetState createState() => __ContactListWidgetState();
}

class __ContactListWidgetState extends State<_ContactListWidget> {
  ScrollController controller;
  List<BlouContact> loadedContacts;
  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    if (widget.contacts.isNotEmpty) {
      setState(() {
        loadedContacts = widget.contacts.take(10).toList();
      });
    }
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 500) {
      List<BlouContact> c = widget.contacts
          .skip(loadedContacts.length - 1)
          .take(
              (loadedContacts.length - 1) + 10 >= (widget.contacts.length - 1)
                  ? (widget.contacts.length - 1) - (loadedContacts.length - 1)
                  : (loadedContacts.length - 1) + 10)
          .toList();
      loadedContacts.addAll(c);
      setState(() {
        loadedContacts = loadedContacts.toList();
      });
      //new contacts = [...currentContacts, ...c].toSet().toList();
      /* BlocProvider.of<ContactListBloc>(context).add(ContactListReadedMore(
          refreshed: true, currentContacts: widget.contacts)); */
    }
  }

  Color getCarrierColor(String carrierName) {
    switch (carrierName.toUpperCase()) {
      case "ORANGE":
        return Color(0xFFf16f02);
      case "MTN":
        return Color(0xFFffcc00);
      case "MOOV":
        return Color(0xFFc4d600);
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        //shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 100),
        controller: controller,
        itemCount: loadedContacts.length,
        itemBuilder: (BuildContext context, int index) {
          final blouContact = loadedContacts.elementAt(index);
          return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: ListTile(
                      onTap: () {
                        Get.to(ContactDetailScreen(blouContact));
                        _analytics.logSelectContent(
                            contentType: "button",
                            itemId: "view_contact_details");
                      },
                      leading: Container(
                          child: blouContact.avatar != null &&
                                  blouContact.avatar.isNotEmpty
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(
                                      new Uint8List.fromList(
                                          blouContact.avatar.codeUnits)),
                                  radius: 10,
                                )
                              : Container(
                                  width: 50,
                                  height: 50,
                                  decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      color: Colors.black12),
                                  child: Icon(Icons.person))),
                      title: BlouText(
                          text: "${blouContact?.displayName}", fontSize: 15),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                                visible: blouContact.carrierName != null &&
                                    blouContact.carrierName.isNotEmpty,
                                child: BlouText(
                                  text: blouContact?.carrierName,
                                  fontSize: 12,
                                  color:
                                      getCarrierColor(blouContact.carrierName),
                                )),
                            blouContact.phone != blouContact.convertedPhone
                                ? Row(children: [
                                    BlouText(
                                      text: "${blouContact?.phone}",
                                      fontSize: 12,
                                      textScaleFactor: 0.8,
                                    ),
                                    Icon(Icons.keyboard_arrow_right,
                                        color: getCarrierColor(
                                            blouContact.carrierName)),
                                    Flexible(
                                        child: BlouText(
                                      text: "${blouContact?.convertedPhone}",
                                      fontSize: 12,
                                      textScaleFactor: 0.8,
                                    )),
                                  ])
                                : BlouText(
                                    //textAlign: TextAlign.left,
                                    text: "${blouContact?.phone}",
                                    fontSize: 12,
                                  )
                          ]),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: BlouColors.GreenColor,
                      ))));
        });
  }
}
