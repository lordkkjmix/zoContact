
import 'package:zocontact/start_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'shared/shared.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  analytics.logAppOpen();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: BlouColors.BlackColor,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(GetMaterialApp(
    title: 'Blou Contact',
    navigatorKey: Get.key,
    theme: ThemeData(
      textTheme:GoogleFonts.workSansTextTheme(),
      primaryColor: BlouColors.BlueColor,
      accentColor: BlouColors.BlackColor,
      errorColor: BlouColors.RedColor,
      appBarTheme: AppBarTheme(
        color: Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: TextTheme(),
        actionsIconTheme: IconThemeData(color: Colors.black),
      ),
      primaryIconTheme: IconThemeData(color: Colors.black),
      fontFamily: GoogleFonts.workSans().fontFamily,
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    ),
    debugShowCheckedModeBanner: false,
    navigatorObservers: [
      FirebaseAnalyticsObserver(analytics: analytics),
    ],
    //supportedLocales: i18n.supportedLocales,
    /* localeResolutionCallback: i18n.resolution(
        fallback: new Locale("fr", "FR"),
      ), */
    getPages: [
      GetPage(name: '/', page: () => StartScreen())
    ],
    /*  localizationsDelegates: [
        i18n,
        RefreshLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ] */
  ));
}
