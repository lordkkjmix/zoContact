import 'package:zocontact/models/models.dart';
import 'package:zocontact/screens/screens.dart';

class HomeTabRepository {
  List<HomeTab> getTabs() {
    final tabs = [
      HomeTab(
        id: "contacts_conversion",
        appBarTitle: "",
        tabTitle: "Convertir",
        icon: "assets/icons/convert_icon.png",
        screen: ContactsConvertionScreen(),
      ),
      HomeTab(
        id: "about_app",
        appBarTitle: "",
        tabTitle: "A propos",
        icon: "assets/icons/about_icon.png",
        screen: ContactsConvertionScreen(),
      ),
      HomeTab(
        id: "rate_app",
        appBarTitle: "",
        tabTitle: "Noter l'app",
        icon: "assets/icons/rate_icon.png",
        screen: ContactsConvertionScreen(),
      ),
      HomeTab(
        id: "help",
        appBarTitle: "AIDE",
        tabTitle: "Aide",
        icon: "assets/icons/help_icon.png",
        screen: HelpScreen(),
      ),
    ];
    return tabs;
  }
}
