import 'package:zocontact/blocs/blocs.dart';
import 'package:zocontact/screens/screens.dart';
import 'package:zocontact/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc, ConfigState>(
        builder: (context, configState) {
      if (configState is ConfigInitial) {
        BlocProvider.of<ConfigBloc>(context).add(ConfigLocalAsked());
      }
      if (configState is ConfigReadSuccess) {
        return SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
                child: Column(children: [
              Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListTile(
                      onTap: () => Get.to(AboutScreen()),
                      leading: Container(
                          child: SvgPicture.asset("assets/icons/books.svg",
                              width: 30)),
                      title: BlouText(text: "A propos", fontSize: 15),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: BlouColors.GreenColor,
                      ))),
              Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListTile(
                      onTap: () => Get.to(CguScreen()),
                      leading: Container(
                          child: SvgPicture.asset("assets/icons/pages.svg",
                              width: 30)),
                      title: BlouText(
                          text: "Conditions d'utilisations", fontSize: 15),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: BlouColors.GreenColor,
                      ))),
              Visibility(
                  visible: configState.config.enabledDonation != null &&
                      configState.config.enabledDonation == true,
                  child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListTile(
                          onTap: () => Get.to(DonateScreen()),
                          leading: Container(
                              child: SvgPicture.asset(
                                  "assets/icons/shopping.svg",
                                  width: 30)),
                          title: BlouText(text: "Faire un don", fontSize: 15),
                          trailing: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: BlouColors.GreenColor,
                          )))),
              Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListTile(
                      onTap: () => {
                            Share.share(
                              "Partager ZoContact\nCette application m'a permis de convertir mes contacts à 10 chiffres facilement, clique sur le lien l'avoir :\nLien :https://bloucontact.page.link/Go1D",
                              subject:
                                  "Partager ZoContact:Cette application m'a permis de convertir mes contacts à 10 chiffres facilement, clique sur le lien l'avoir :\nLien :https://bloucontact.page.link/Go1D",
                            )
                          },
                      leading: Container(
                          child: SvgPicture.asset("assets/icons/like.svg",
                              width: 30)),
                      title: BlouText(text: "Partager", fontSize: 15),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: BlouColors.GreenColor,
                      ))),
              BlouText(
                text: "Version 1.0",
                color: Colors.black,
                textAlign: TextAlign.center,
                fontSize: 10,
              )
            ])));
      }
      return Container();
    });
  }
}
