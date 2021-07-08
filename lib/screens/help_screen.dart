import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zocontact/models/models.dart';
import 'package:zocontact/screens/help_content_screen.dart';
import 'package:zocontact/shared/shared.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final helpContents = [
      HelpContent(
          id: "why_convert",
          title: "Pourquoi convertir ?",
          img: "assets/img/illustration_jeune_asssis.png",
          content:
              "Bla bla bla Bla bla bla Bla bla bla Bla bla bla Bla bla bla Bla bla bla Bla bla bla ",
          heightRatio: 1.2),
      HelpContent(
          id: "howto_convert",
          title: "Comment convertir ?",
          img: "assets/img/illustration_yoga.png",
          content: "",
          heightRatio: 1.7),
      HelpContent(
          id: "about_whatsapp",
          title: "Et mon Whatsapp?",
          img: "assets/img/illustration_fille_fachee.png",
          content: "",
          heightRatio: 2),
      HelpContent(
          id: "howto_receive_code",
          title: "Comment recevoir un code?",
          img: "assets/img/illustration_telephone_fleche.png",
          content: "",
          heightRatio: 1),
      HelpContent(
          id: "contactus",
          title: "Nous contacter",
          img: "assets/img/illustration_enveloppe.png",
          content: "",
          heightRatio: 2)
    ].toList();
    return SafeArea(
        minimum: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: BlouColors.LightBlueColor),
            // padding: EdgeInsets.symmetric(vertical: 10),
            width: width,
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemCount: helpContents.length,
              itemBuilder: (BuildContext context, int index) {
                final helpcontent = helpContents.elementAt(index);
                return InkWell(
                    onTap: () => {Get.to(HelpContentScreen(helpcontent))},
                    child: Container(
                        child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                          child: Image.asset(
                                        helpcontent.img,
                                        width: width / 3,
                                        height: width / 3,
                                        fit: BoxFit.cover,
                                      )),
                                      Container(
                                          child: BlouText(
                                        text: helpcontent.title,
                                        type: "bold",
                                        fontSize: 20,
                                      ))
                                    ])))));
              },
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(1, index.isEven ? 2 : 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            )));
  }
}
