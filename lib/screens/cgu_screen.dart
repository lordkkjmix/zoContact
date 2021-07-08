import 'package:zocontact/shared/shared.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

FirebaseAnalytics _analytics = FirebaseAnalytics();

class CguScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    _analytics.setCurrentScreen(screenName: "CguScreen");

    return Scaffold(
        appBar: AppBar(
          backgroundColor: BlouColors.GreyBgColor,
          elevation: 0,
          title: BlouText(text: "Conditions d'utilisations"),
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
                          BlouText(
                              fontSize: 15,
                              text:
                                  "Veuillez lire attentivement le présent document",
                              color: Colors.lightBlue,
                              type: "bold"),
                          BlouText(
                              fontSize: 15,
                              text:
                                  "Ce document définit les conditions générales de la relation électronique qui vous lie a cette application. Les présentes conditions générales s’appliquent à chaque fonctionnalité de la présente application.\n Elles s’appliquent, en outre, à  d’autres documents, y compris les conditions générales."),
                        ],
                      ))),
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
                          BlouText(
                              fontSize: 15,
                              text: "Comment nous contacter",
                              color: Colors.lightBlue,
                              type: "bold"),
                          BlouText(
                              fontSize: 15,
                              text:
                                  "Si vous souhaitez discuter d’un quelconque aspect de nos relations, veuillez nous contacter via Whatsapp au 54189332.\nVeuillez noter que vous ne serez pas en mesure de nous contacter par téléphone."),
                        ],
                      ))),
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
                          BlouText(
                              fontSize: 15,
                              text: "Article 1 - Autorisation",
                              color: Colors.lightBlue,
                              type: "bold"),
                          BlouText(
                              fontSize: 15,
                              text:
                                  "En donnant accès à BlouContact à vos contacts, vous acceptez nos termes et conditions concernant les responsabilités et préjudices que pourrait causer cette application.\nBlouContact n'est lié à aucun serveur et donc ne collecte aucune information pour une entité tierce.  "),
                        ],
                      ))),
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
                          BlouText(
                              fontSize: 15,
                              text: "Article 2 - Responsabilité",
                              color: Colors.lightBlue,
                              type: "bold"),
                          BlouText(
                              fontSize: 15,
                              text:
                                  "Vous garantissez que toute information et autre contenu, tels que les informations concernant les contacts contenus dans le répertoire téléphonique de votre appareil, que vous pouvez partager avec BlouContact en tant qu'Utilisateur des Services, au mieux de votre connaissance, est correcte, n'est pas en violation de la loi ivoirienne, ne corrompra pas ou ne perturbera pas les Services, et que vous avez le droit de partager le Contenu avec BlouContact afin que BlouContact puisse repondre a vos exigences.\nBlouContact et son équipe de développement ne sont en aucun cas responsable de dommage, perturbation ou autre incident que cette application pourrait causer à votre téléphone."),
                        ],
                      ))),
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
                          BlouText(
                              fontSize: 15,
                              text: "Article 3 - Données personnelle",
                              color: Colors.lightBlue,
                              type: "bold"),
                          BlouText(
                              fontSize: 15,
                              text:
                                  "Vos données à caractère personnel sont protégées par la loi No 2013-450 du 19 juin 2013 relative à la protection des données à caractère personnel en République de Côte d’Ivoire. BlouContact se conforme a cette loi et ne collecte aucune données a caractère personnelle."),
                        ],
                      ))),
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
                          BlouText(
                              fontSize: 15,
                              text: "Article 4 - Statistique",
                              color: Colors.lightBlue,
                              type: "bold"),
                          BlouText(
                              fontSize: 15,
                              text:
                                  "L'application BlouContact collecte des informations concernant l'interaction (fonctionnalité la plus utilisée, version de l'application, boutons les plus cliqués...) et nous envoie ces informations pour des analyses statistiques afin d'améliorer le service qui vous est proposé. La collecte de ces informations nous permet également d'améliorer la pertinence des messages de notification envoyés par le service. Toutes les informations collectées sont entièrement anonymes et ne sont en aucun cas associées à l'utilisateur. Ces informations sont collectées et traitées en conformité avec les lois et règlements en vigueur. Elles ne sont pas utilisées pour d'autres finalités que celle d'améliorer le service et la pertinence des messages de notification envoyés. Aucune donnée personnelle n'est collectée."),
                        ],
                      ))),
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
                          BlouText(
                              fontSize: 15,
                              text: "Article 5 - Publicité",
                              color: Colors.lightBlue,
                              type: "bold"),
                          BlouText(
                              fontSize: 15,
                              text:
                                  "BlouContact peut contenir des bannières ou annonces publicitaire mais ne vous demandera pas d'effectuer un paiement, un achat en dehors de la proposition de Don et d'activation."),
                        ],
                      ))),
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
                          BlouText(
                              fontSize: 15,
                              text: "Article 6 - Droit & Copyright",
                              color: Colors.lightBlue,
                              type: "bold"),
                          BlouText(
                              fontSize: 15,
                              text:
                                  "BlouContact est une propriété de DigitApp CI, ainsi DigitApp CI se réserve le droit d'utilisation, de reproduction ou de commercialisation de cette application.\nToutes reproduction ou commercialisation de BlouContact en tout ou partie est passible de poursuite judiciaire conformément à la loi en vigueur de la protection de la propriété intellectuelle."),
                        ],
                      ))),
            ])))));
  }
}
