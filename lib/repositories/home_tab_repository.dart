import 'package:zocontact/models/models.dart';
import 'package:zocontact/screens/screens.dart';

class HomeTabRepository {
  List<HomeTab> getTabs() {
    final tabs = [
      HomeTab(
        id: "contacts_conversion",
        appBarTitle: "",
        tabTitle: "Convertir",
        icon: "assets/icons/convert.svg",
        screen: ContactsConvertionScreen(),
      ),
      HomeTab(
        id: "about_app",
        appBarTitle: "",
        tabTitle: "A propos",
        icon: "assets/icons/convert.svg",
        screen: ContactsConvertionScreen(),
      ),
      HomeTab(
        id: "rate_app",
        appBarTitle: "",
        tabTitle: "Noter l'app",
        icon: "assets/icons/convert.svg",
        screen: ContactsConvertionScreen(),
      ),
      HomeTab(
        id: "help",
        appBarTitle: "",
        tabTitle: "Aide",
        icon: "assets/icons/convert.svg",
        screen: ContactsConvertionScreen(),
      ),
    ];
    return tabs;
  }
}
