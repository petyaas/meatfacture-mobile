import 'dart:convert';
import 'dart:developer';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/assortment_recommendations_bloc.dart';
import 'package:smart/bloc_files/basic_page_bloc.dart';
import 'package:smart/bloc_files/hisory_oder_details_bloc.dart';
import 'package:smart/bloc_files/history_check_details_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/bloc_files/shopping_history_bloc.dart';
import 'package:smart/features/catalog/subcatalog_screen.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/pages/redesigned_pages/redes_product_details_page.dart';
import 'package:smart/services/local_notification_service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'history_check_details_page.dart';
import 'history_order_details_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    AssortmentRecommendationBloc _assortmentRecommendationBloc = BlocProvider.of<AssortmentRecommendationBloc>(context);
    HistoryOrdertDetailsBloc _historyOrdertDetailsBloc = BlocProvider.of<HistoryOrdertDetailsBloc>(context);
    SecondaryPageBloc _secondaryPageBloc = BlocProvider.of(context);
    ShoppingHistoryBloc _shoppingHistoryBloc = BlocProvider.of<ShoppingHistoryBloc>(context);
    // ProfileBloc _profileBloc = BlocProvider(create: create)
    HistoryCheckDetailsBloc _historyCheckDetailsBloc = BlocProvider.of<HistoryCheckDetailsBloc>(context);

    //событие при нажатии на пуш

    void notificationOnTapEvent({RemoteMessage event, Map<String, dynamic> mapDataFromLocalNotif}) {
      if (event != null || mapDataFromLocalNotif != null) {
        Map<String, dynamic> _data = event != null ? event.data : mapDataFromLocalNotif;

        log('при нажатии на пуш 🟧 : $_data');
        print("Push opened 🌘: ${_data["url"]}");
        FirebaseAnalytics.instance.logEvent(
          name: "push_opened",
          parameters: {
            "push_type": _data["type"],
            "push_title": _data["title"] ?? "Unknown",
            "push_url": _data["url"] ?? "None",
            "timestamp": DateTime.now().toIso8601String(),
          },
        ).catchError((error) {
          log('Ошибка логирования Firebase Analytics: $error');
        });

        switch (_data["type"]) {
          case "url":
            {
              launchUrl(Uri.parse(_data["url"]));
            }
            break;

          case "profile":
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            }
            break;
          case "orders":
            {
              _secondaryPageBloc.add(ProfilePageEvent());
              _shoppingHistoryBloc.add(ShoppingHistoryOrdersListEvent());
              if (_data["id"] != null && _data["id"] != "") {
                _secondaryPageBloc.add(HistoryOrderDetailsPageLoadEvent(orderNumber: ""));
                _historyOrdertDetailsBloc.add(HistoryOrderDetailsLoadEvent(orderId: _data["id"]));
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryOrderDetailsPage(orderDate: "")));
              }
            }
            break;
          case "receipts":
            {
              _secondaryPageBloc.add(ProfilePageEvent());
              _shoppingHistoryBloc.add(ShoppingHistoryCheckListEvent());
              if (_data["id"] != null && _data["id"] != "") {
                _historyCheckDetailsBloc.add(HistoryCheckDetailsLoadEvent(receiptUuid: _data["id"]));
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryCheckDetailsPage(checkDate: "checkText".tr())));
              }
            }
            break;
          case "assortments":
            {
              if (_data["id"] != null && _data["id"] != "") {
                Navigator.push(
                  context,
                  new CupertinoPageRoute(
                    builder: (context) => RedesProductDetailsPage(
                      productUuid: _data["id"],
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubcatalogScreen(isSearchPage: false, preCataloName: "Все товары")),
                );
              }
            }
            break;
          case "catalogs":
            {
              if (_data["id"] != null && _data["id"] != "") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubcatalogScreen(
                      isSearchPage: false,
                      preCataloName: _data["name"],
                      preCataloUuid: _data["id"],
                    ),
                  ),
                );
              } else {
                _secondaryPageBloc.add(CatalogEvent());
                _assortmentRecommendationBloc.add(AssortmentRecommendationsLoadEvent());
              }
            }
            break;
          default:
            log('🟧 пуш: ${_data["type"]}');
        }
      }
    }

    //notification things
    LocalNotificationService.initialize();

    FirebaseMessaging.onMessage.listen((message) {
      log('🟧 Новое пуш-уведомление: ${message.data}');
      if (message.notification != null) {
        log('🟧 Уведомление: ${message.notification.title}');
      }
      LocalNotificationService.display(message);
    });

    LocalNotificationService.onNotification.listen((value) {
      Map<String, dynamic> mapData = json.decode(value);
      log('🟧 пуш mapData: $mapData');
      notificationOnTapEvent(mapDataFromLocalNotif: mapData);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      log('🟧 Открыто пуш-уведомление из фона: ${event.data}');
      notificationOnTapEvent(event: event);
    });

    FirebaseMessaging.instance.getInitialMessage().then((event) {
      if (event != null) {
        log('🟧 Пуш из закрытого состояния: ${event.data}');
        notificationOnTapEvent(event: event);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasicPageBloc, Widget>(
      builder: (BuildContext context, currentPage) => GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: currentPage,
      ),
    );
  }
}
