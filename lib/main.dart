import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/bloc_files/assortment_comments_bloc.dart';
import 'package:smart/bloc_files/assortment_filter_bloc.dart';
import 'package:smart/bloc_files/basic_page_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/bloc_files/brands_bloc.dart';
import 'package:smart/features/addresses/addresses_delivery/bloc/addresses_client_bloc.dart';
import 'package:smart/bloc_files/credit_cards_bloc.dart';
import 'package:smart/bloc_files/diverse_food_bloc.dart';
import 'package:smart/bloc_files/favorite_product_bloc.dart';
import 'package:smart/bloc_files/history_check_details_bloc.dart';
import 'package:smart/bloc_files/im_in_shop_bloc.dart';
import 'package:smart/bloc_files/loyalty_cards_list_bloc.dart';
import 'package:smart/bloc_files/onboarding_bloc.dart';
import 'package:smart/bloc_files/order_type_bloc.dart';
import 'package:smart/bloc_files/product_details_middle_content_bloc.dart';
import 'package:smart/features/home/banners/bloc/banners_bloc.dart';
import 'package:smart/features/home/banners/bloc/banners_event.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/bloc_files/selected_pay_card_and_address_for_order_bloc.dart';
import 'package:smart/bloc_files/shop_details_bloc.dart';
import 'package:smart/bloc_files/shopping_history_bloc.dart';
import 'package:smart/bloc_files/shopping_list_details_bloc.dart';
import 'package:smart/bloc_files/shopping_lists_bloc.dart';
import 'package:smart/bloc_files/shops_list_filters_bloc.dart';
import 'package:smart/bloc_files/smart_contacts_bloc.dart';
import 'package:smart/bloc_files/stories_list_bloc.dart';
import 'package:smart/bloc_files/tags_bloc.dart';
import 'package:smart/bloc_files/yellow_promo_assortments_bloc.dart';
import 'package:smart/features/catalog/cubit/catalog_rebuild_cubit.dart';
import 'package:smart/features/main/main_page.dart';
import 'package:smart/features/recipes/blocs/receipts_bloc/receipts_bloc.dart';
import 'package:smart/features/recipes/blocs/receipts_favorite_bloc/receipts_favorite_bloc.dart';
import 'package:smart/pages/reg_and_login_page.dart';
import 'package:smart/pages/splash_screen_with_animation.dart';
import 'package:smart/services/services.dart';
import 'package:smart/order_process/order_process_list_bloc.dart';
import 'package:smart/core/constants/shared_keys.dart';

import 'bloc_files/add_or_subtract_bonuses_bloc.dart';
import 'bloc_files/assortment_recommendations_bloc.dart';
import 'features/catalog/bloc/catalogs_bloc.dart';
import 'bloc_files/geocoding_bloc.dart';
import 'bloc_files/hisory_oder_details_bloc.dart';
import 'bloc_files/order_calculate_bloc.dart';
import 'bloc_files/order_created_bloc.dart';
import 'bloc_files/product_in_shop_bloc.dart';
import 'bloc_files/url_for_credit_card_bloc.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // Для инициализации Firebase в фоновом режиме
  log("message.notification.title 👉: ${message.notification.title}");
  log("message.notification.body 👉: ${message.notification.body}");
  // Логирование события в Firebase Analytics
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  analytics.logEvent(
    name: "push_received_in_background",
    parameters: {
      "title": message.notification?.title ?? "No title",
      "body": message.notification?.body ?? "No body",
      "data": message.data.toString(),
    },
  );
}

SharedPreferences prefs;
final addressProvider = AddressesClientProvider();

void main() async {
  //это было нужно для модифициорванного браущера оплаты
  // if (Platform.isAndroid) {
  //   // await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  // }
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));
  // WidgetsFlutterBinding();
  await Firebase.initializeApp();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  String token = await loadToken();

  prefs = await SharedPreferences.getInstance();
  await prefs.setString(SharedKeys.isChoosenAddressesForThisSession, 'no');
  await prefs.setString(SharedKeys.isChoosenAddressesForThisSessionIamInShop, 'no');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      log("----------------**************----------------: ${message.notification.title} - ${message.notification.body}");
      // Логирование события в Firebase Analytics
      analytics.logEvent(
        name: "push_received",
        parameters: {
          "title": message.notification?.title ?? "No title",
          "body": message.notification?.body ?? "No body",
          "data": message.data.toString(),
        },
      );
    }
  });

  runApp(EasyLocalization(
    supportedLocales: [Locale('ru', 'RU')],
    path: 'assets/translations',
    saveLocale: true,
    fallbackLocale: Locale('ru', 'RU'),
    child: MyApp(token: token),
  ));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Future<String> _loadToken() async {
//   SharedPreferences _shared = await SharedPreferences.getInstance();
//   return _shared.getString('token');
// }

class MyApp extends StatelessWidget {
  final String token;

  MyApp({this.token});

  @override
  Widget build(BuildContext context) {
    print(token);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CatalogRebuildCubit()),
        BlocProvider(create: (context) => StoriesListBloc()),
        BlocProvider(create: (context) => OrderProcessListBloc()),
        BlocProvider(create: (context) => SelectedPayCardAndAddressForOrderBloc()),
        BlocProvider(create: (context) => AddOrSubtractBonusesBloc()),
        BlocProvider(
            create: (context) => AddressesClientBloc(
                  prefs: prefs,
                  addressProvider: addressProvider,
                )),
        BlocProvider(create: (context) => YellowPromoAssortmentsBloc()),
        BlocProvider(create: (context) => OnboardingBloc()),
        BlocProvider(create: (context) => BrandBloc()),
        BlocProvider(create: (context) => ImInShopBloc()),
        BlocProvider(create: (context) => CreditCardsListBloc()),
        BlocProvider(create: (context) => UrlForCreditCardLinkBloc()),
        BlocProvider(create: (context) => SmartContactsBloc()),
        BlocProvider(create: (context) => AssortmentRecommendationBloc()),
        BlocProvider(create: (context) => DiverseFoodBloc()),
        BlocProvider(create: (context) => Geocodingbloc()),
        BlocProvider(create: (context) => FavoriteProductBloc()),
        BlocProvider(create: (context) => HistoryOrdertDetailsBloc()),
        BlocProvider(create: (context) => OrderCreatedBloc()),
        BlocProvider(create: (context) => OrderCalculateBloc()),
        BlocProvider(create: (context) => OrderTypeBloc()),
        BlocProvider(create: (context) => BasketListBloc()),
        BlocProvider(create: (context) => AssortmentCommentsBloc()),
        BlocProvider(create: (context) => HistoryCheckDetailsBloc()),
        BlocProvider(create: (context) => ProductInShopBloc()),
        BlocProvider(create: (context) => AssortmentFiltersBloc()),
        BlocProvider(create: (context) => ShopsListFiltersBloc()),
        BlocProvider(create: (context) => LoyaltyCardsListBloc()),
        BlocProvider(create: (context) => ShoppingHistoryBloc()),
        BlocProvider(create: (context) => ShoppingListDetailsBloc()),
        BlocProvider(create: (context) => ShoppingListsBloc()),
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(create: (context) => ProductDetMiddleContentBloc()),
        BlocProvider(create: (context) => TagsBloc()),
        BlocProvider(create: (context) => ShopDetailsBloc()),
        BlocProvider(create: (context) => AddressesShopBloc(prefs: prefs)),
        BlocProvider(create: (context) => AuthPageBloc()),
        BlocProvider(create: (context) => CatalogsBloc()),
        BlocProvider(create: (context) => ReceiptsBloc()),
        BlocProvider(create: (context) => ReceiptsFavoriteBloc()),
        BlocProvider(
            create: (context) => SecondaryPageBloc(
                token != null && token == "guest" ? SecondaryCatalogPageState() : SecondaryHomePageState())),
        BlocProvider(
            create: (context) =>
                BasicPageBloc(token == null || token.isEmpty ? RegAndLoginPAge() : MainPage(token: token))),
        BlocProvider(create: (context) => BannersBloc()..add(LoadBannersEvent())),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData(appBarTheme: AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light)),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        builder: (context, child) =>
            MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: child),
        debugShowCheckedModeBanner: false,
        home: SplashScreenWithAniamtion(),
      ),
    );
  }
}
