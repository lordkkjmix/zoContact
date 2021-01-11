import 'dart:convert';

import 'package:share/share.dart';
import 'package:zocontact/blocs/blocs.dart';
import 'package:zocontact/blocs/push_notification/push_notification.dart';
import 'package:zocontact/models/models.dart';
import 'package:zocontact/repositories/repositories.dart';
import 'package:zocontact/shared/shared.dart';
import 'package:zocontact/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseAnalytics _analytics = FirebaseAnalytics();

class HomeScreen extends StatelessWidget {
  List<Widget> getActions(int tabIndex, BuildContext context) {
    switch (tabIndex) {
      case 0:
        return [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                  child: Column(children: [
                    Container(
                        child: Icon(
                      Icons.share,
                      color: Colors.white,
                    )),
                    BlouText(
                      text: "Partager",
                      fontSize: 12,
                      color: Colors.white,
                    )
                  ]),
                  onTap: () {
                    Share.share(
                      "Partager ZoContact\nCette application m'a permis de convertir mes contacts à 10 chiffres facilement, clique sur le lien l'avoir :\nLien :https://bloucontact.page.link/Go1D",
                      subject:
                          "Partager ZoContact:Cette application m'a permis de convertir mes contacts à 10 chiffres facilement, clique sur le lien l'avoir :\nLien :https://bloucontact.page.link/Go1D",
                    );
                  }))
        ];
      case 2:
        return [];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeTabBloc(HomeTabRepository()),
          ),
          BlocProvider(
              create: (context) =>
                  ContactListBloc(repository: ContactListRepository())),
          BlocProvider(
            create: (context) =>
                PhoneBookConversionBloc(repository: ContactListRepository()),
          ),
          BlocProvider(
              create: (context) => ConfigBloc(repository: ConfigRepository())),
          BlocProvider(
              create: (context) => PushNotificationBloc(
                  repository: PushNotificationRepository())),
          BlocProvider(
            create: (context) => ContactPermissionBloc(),
          ),
        ],
        child: Scaffold(
            body: BlocConsumer<ConfigBloc, ConfigState>(
                listener: (context, configState) {
          if (configState is ConfigReadSuccess) {
            BlocProvider.of<ContactListBloc>(context)
                .add(ContactListReaded(refreshed: false));
          }
        }, builder: (context, configState) {
          if (configState is ConfigInitial) {
            BlocProvider.of<ConfigBloc>(context).add(ConfigLocalAsked());
          }
          return BlocConsumer<PushNotificationBloc, PushNotificationState>(
              listener: (context, pushNotificationState) {
            if (pushNotificationState is PushNotificationSuccess) {
              BlocProvider.of<PushNotificationBloc>(context)
                  .add(PushNotificationRead());
            }
          }, builder: (context, pushNotificationState) {
            if (pushNotificationState is PushNotificationInitial) {
              BlocProvider.of<PushNotificationBloc>(context)
                  .add(PushNotificationPermissionRequested());
            }
            return BlocBuilder<HomeTabBloc, HomeTabState>(
                builder: (context, homeTabState) {
              if (homeTabState is HomeTabInitial) {
                BlocProvider.of<HomeTabBloc>(context).add(HomeTabListed());
              }
              if (homeTabState is HomeTabListSuccess) {
                final tabs = homeTabState.tabs;
                final tab = tabs[homeTabState.selectedIndex];
                return Scaffold(
                    backgroundColor: BlouColors.GreyBgColor,
                    appBar: AppBar(
                      backgroundColor: BlouColors.DarkBlueColor,
                      title: BlouText(
                          text: tab.appBarTitle, type: "bold", fontSize: 25, color:Colors.white),
                      elevation: 0,
                      //isLogo: tabs.indexOf(tab) == 0,
                      centerTitle: false,
                      actions: getActions(tabs.indexOf(tab), context),
                    ),
                    body: Stack(children: [
                      Container(
                          padding: EdgeInsets.only(
                              top: tab.id == "contact_list" ? 80 : 0,
                              bottom: 0),
                          child: tab.screen),
                      Padding(padding: EdgeInsets.only(bottom: 100)),
                      Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          height: 80,
                          child: Visibility(
                              visible: tab.id == "contact_list",
                              child: SearchContactInputWdget())),

                      ///_AdLoaderWidget()
                    ]),
                    bottomNavigationBar: BottomNavigationBar(
                        backgroundColor: BlouColors.DarkBlueColor,
                        currentIndex: tabs.indexOf(tab),
                        items: <BottomNavigationBarItem>[
                          for (var index = 0; index < tabs.length; index++)
                            BottomNavigationBarItem(
                              activeIcon: Image.asset(tabs[index].icon,
                                  //color: Theme.of(context).primaryColor,
                                  width: 30),
                              icon: Image.asset(
                                tabs[index].icon,
                                width: 30,
                                //color: Colors.black38
                              ),
                              label: tabs[index].tabTitle,
                            ),
                        ],
                        selectedItemColor: Colors.white,
                        unselectedItemColor: Colors.white,
                        unselectedIconTheme:
                            IconThemeData(color: Colors.grey[500]),
                        //unselectedLabelStyle: DjamoStyles.unselectedHomeTabLabel,
                        /*  selectedLabelStyle:
                        BlouStyles.selectedHomeTablabel(context), */
                        showUnselectedLabels: true,
                        type: BottomNavigationBarType.fixed,
                        onTap: (int index) {
                          _analytics.logSelectContent(
                              contentType: "tab",
                              itemId: "${tabs.elementAt(index).id}_opened");
                          BlocProvider.of<HomeTabBloc>(context)
                              .add(HomeTabSelected(index));
                        }));
              }
              return Center(
                  child: Loader(
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ));
            });
          });
        })));
  }
}

class _AdLoaderWidget extends StatefulWidget {
  @override
  __AdLoaderWidgetState createState() => __AdLoaderWidgetState();
}

class __AdLoaderWidgetState extends State<_AdLoaderWidget> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<AdItem>> fetchAd() async {
    List<AdItem> adItems = [];
    final response = await http.get('https://bloucontact.page.link/oN6u');
    if (response.statusCode == 200) {
      /*  final String testString =
          '[{"id": "1","order": 0,"img": "https://via.placeholder.com/600/92c952","isActive": true}]'; */
      List list = json.decode(response.body);
      adItems = list
          .map((item) {
            return AdItem(
              id: item["id"],
              order: item["order"],
              img: item["img"],
              link: item["link"],
              isActive: item["isActive"],
            );
          })
          .toList()
          .cast<AdItem>();
      return adItems;
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
        alignment: Alignment.bottomCenter,
        child: FutureBuilder<List<AdItem>>(
            future: fetchAd(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<AdItem> ads = snapshot.data;
                ads.removeWhere((element) => element.isActive == false);
                if (ads.isNotEmpty) {
                  ads.sort((a, b) => b.order.compareTo(a.order));
                  return CarouselSlider.builder(
                      itemCount: ads.length,
                      options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: false,
                          viewportFraction: 1.0,
                          aspectRatio: 5.0,
                          autoPlayInterval: Duration(seconds: 10)),
                      itemBuilder: (BuildContext context, int itemIndex) {
                        final AdItem item = snapshot.data.elementAt(itemIndex);
                        _analytics.setCurrentScreen(
                            screenName: "${item.id}_${item.img}");
                        return InkWell(
                            onTap: () async {
                              final String url = item.link;
                              if (await canLaunch(url)) {
                                _analytics.logSelectContent(
                                    contentType: "button",
                                    itemId: "${item.id}_${item.link}");
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Container(
                                width: width,
                                height: 30,
                                child: CachedNetworkImage(
                                  imageUrl: item.img,
                                  fit: BoxFit.contain,
                                  /*  placeholder: (context, url) =>
                                    Container(width: 20,height: 20, child:CircularProgressIndicator()), */
                                  errorWidget: (context, url, error) =>
                                      Container(),
                                )));
                      });
                }
                return Container();
              }
              return Container();
            }));
  }
}

class SearchContactInputWdget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController inputController = TextEditingController();
    return BlocBuilder<ContactPermissionBloc, ContactPermissionState>(
        builder: (context, contactPermissionState) {
      if (contactPermissionState is ContactPermissionSuccess) {
        return BlocBuilder<ContactListBloc, ContactListState>(
            builder: (context, contactListState) {
          return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: BlouTextField(
                  hintText: "Rechercher un contact",
                  keyboardType: TextInputType.text,
                  controller: inputController,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  prefixIcon: Container(
                      child: SvgPicture.asset("assets/icons/search.svg",
                          width: 20)),
                  onChanged: (text) {
                    BlocProvider.of<ContactListBloc>(context)
                        .add(ContactListSearched(text));
                    _analytics.logSearch(searchTerm: text);
                  },
                  suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        inputController.clear();
                        BlocProvider.of<ContactListBloc>(context)
                            .add(ContactListReaded(refreshed: false));
                      })));
        });
      } else {
        return Container();
      }
    });
  }
}
