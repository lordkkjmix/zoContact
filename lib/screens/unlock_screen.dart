import 'package:zocontact/blocs/blocs.dart';
import 'package:zocontact/repositories/config_repository.dart';
import 'package:zocontact/screens/screens.dart';
import 'package:zocontact/shared/button.dart';
import 'package:zocontact/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class UnlockScreen extends StatelessWidget {
  final String userKey;
  const UnlockScreen(this.userKey);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: BlouColors.GreyBgColor,
          elevation: 0,
          title: BlouText(text: "Détails contact"),
        ),
        backgroundColor: BlouColors.GreyBgColor,
        body: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) =>
                      UnlockBloc(repository: ConfigRepository())),
              BlocProvider(
                  create: (context) =>
                      ConfigBloc(repository: ConfigRepository()))
            ],
            child: SafeArea(
                minimum: EdgeInsets.all(10),
                child: Center(
                    child: BlocListener<ConfigBloc, ConfigState>(
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
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
                                ])),
                                Visibility(
                                    visible: unlockState is ActivationFailure,
                                    child: BlouText(
                                        color: Colors.red,
                                        text:
                                            "Echec d'activation, vérifiez le code entrer.")),
                                Visibility(
                                    visible: unlockState is ActivationSuccess,
                                    child: BlouText(
                                        color: Colors.green,
                                        text:
                                            "L'activation de BlouContact a réussi")),
                                BlouButton(
                                    label: "Activer",
                                    onPressed: unlockState
                                            is ActivationCodeEnteredSuccess
                                        ? () {
                                            BlocProvider.of<UnlockBloc>(context)
                                                .add(ActivationCodeRequested(
                                                    this.userKey,
                                                    unlockState
                                                            is ActivationCodeEnteredSuccess
                                                        ? unlockState.code
                                                        : null));
                                          }
                                        : null)
                              ]);
                        }))))));
  }
}
