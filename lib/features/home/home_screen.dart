import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/loyalty_cards_list_bloc.dart';
import 'package:smart/bloc_files/stories_list_bloc.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/custom_widgets/up_profile_data_home_page.dart';
import 'package:smart/features/home/widgets/home_content.dart';
import 'package:smart/features/home/widgets/home_popup_beta_version_dialog.dart';
import 'package:smart/main.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> homePageNavKey;

  const HomeScreen({@required this.homePageNavKey});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool popupBetaVersion = prefs.getBool(SharedKeys.popupBetaVersion);
  bool isSocialNetworkFacebook = prefs.getBool(SharedKeys.isSocialNetworkFacebook);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    showPopupBetaVersionDialog();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    StoriesListBloc storiesListBloc = BlocProvider.of(context);
    switch (state) {
      case AppLifecycleState.resumed:
        storiesListBloc.add(StoriesListLoadEvent());
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  void showPopupBetaVersionDialog() async {
    if (isSocialNetworkFacebook != null && isSocialNetworkFacebook) {
      if (popupBetaVersion == false || popupBetaVersion == null) {
        await Future.delayed(Duration(seconds: 1));
        await popupBetaVersionDialog(context);
      }
    }
  }

  Future<void> popupBetaVersionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: HomePopupBetaVersionDialog(),
      ),
    );
  }

  Widget build(BuildContext context) {
    // ignore: close_sinks
    LoyaltyCardsListBloc _loyaltyCardsListBloc = BlocProvider.of<LoyaltyCardsListBloc>(context);
    if (_loyaltyCardsListBloc.state is LoyaltyCardsListLoadedState) {
    } else {
      _loyaltyCardsListBloc.add(LoyaltyCardsListLoadEvent());
    }
    return WillPopScope(
      onWillPop: () async {
        widget.homePageNavKey.currentState.maybePop();
        return false;
      },
      child: Navigator(
        key: widget.homePageNavKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => Scaffold(
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerFloat,
            // floatingActionButton: LoyaltyCardButtonWidget(),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(color: newRedDark),
              child: Column(
                children: [
                  SizedBox(height: heightRatio(size: 3, context: context)),
                  UpProfileDataHome(), //шапка где заполнить профиль и уведомления
                  SizedBox(height: heightRatio(size: 8, context: context)),
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                        topRight: Radius.circular(heightRatio(size: 15, context: context)),
                      ),
                      child: Container(
                        color: Colors.white,
                        child: HomeContent(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
