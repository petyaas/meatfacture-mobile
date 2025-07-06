import 'dart:developer';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:smart/bloc_files/assortment_recommendations_bloc.dart';
import 'package:smart/bloc_files/basic_page_bloc.dart';
import 'package:smart/features/addresses/addresses_delivery/bloc/addresses_client_bloc.dart';
import 'package:smart/bloc_files/credit_cards_bloc.dart';
import 'package:smart/bloc_files/diverse_food_bloc.dart';
import 'package:smart/bloc_files/favorite_product_bloc.dart';
import 'package:smart/bloc_files/im_in_shop_bloc.dart';
import 'package:smart/bloc_files/loyalty_cards_list_bloc.dart';
import 'package:smart/bloc_files/order_calculate_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/bloc_files/shopping_history_bloc.dart';
import 'package:smart/bloc_files/stories_list_bloc.dart';
import 'package:smart/bloc_files/tags_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/custom_widgets/assortment_filter_button.dart';
import 'package:smart/custom_widgets/loyalty_card_button_widget.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_event.dart';
import 'package:smart/features/basket/basket_screen.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/features/catalog/catalog_screen.dart';
import 'package:smart/features/home/home_screen.dart';
// import 'package:smart/features/main/widgets/main_upgrade_dialog.dart';
// import 'package:smart/features/main/widgets/main_upgrade_must_dialog.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/order_process/order_process_list_bloc.dart';
import 'package:smart/pages/init_add_user_address.dart';
import 'package:smart/pages/splash_screen_page.dart';
import 'package:smart/services/services.dart';
// import 'package:upgrader/upgrader.dart';

bool isToFreeFirst = true;

class MainPage extends StatefulWidget {
  final String token;
  const MainPage({this.token});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> _mainScreens;
  PageController _pageController;

  Map<String, GlobalKey<NavigatorState>> _naviagtorKeys = {
    "homePageKey": GlobalKey<NavigatorState>(),
    "catalogPageKey": GlobalKey<NavigatorState>(),
    "basketPageKey": GlobalKey<NavigatorState>(),
    "profilePageKey": GlobalKey<NavigatorState>(),
  };
  bool _isSplashing = true;
  int _currentIndex = 0;
  bool _isInit = true;

////////////////////////////////////////////////////////////////////

  // static bool upgradeCheckedForSession = false;

  // void checkForUpgrade() async {
  //   log('🔄 Проверяем обновки 🔄 checkForUpgrade 🔄');
  //   if (upgradeCheckedForSession) return;

  //   try {
  //     final info = await PackageInfo.fromPlatform();
  //     log('📦 package_info: version=${info.version}, build=${info.buildNumber}');

  //     final upgrader = Upgrader(
  //       debugLogging: true,
  //       showIgnore: false,
  //       showLater: true,
  //       showReleaseNotes: false,
  //       dialogStyle: UpgradeDialogStyle.material,
  //     );

  //     try {
  //       await upgrader.initialize();
  //     } catch (e, s) {
  //       log('❌ Ошибка инициализации Upgrader: $e');
  //       return;
  //     }

  //     final currentVersion = upgrader.currentInstalledVersion() ?? '';
  //     final newVersion = upgrader.currentAppStoreVersion() ?? '';

  //     if (currentVersion.isEmpty || newVersion.isEmpty) {
  //       log('⚠️ Версии не найдены');
  //       return;
  //     }

  //     log('🧪 Установлена: $currentVersion');
  //     log('🧪 В Store: $newVersion');

  //     final isUpdateAvailable = await upgrader.isUpdateAvailable();
  //     if (isUpdateAvailable != true) {
  //       log('✅ Обновление не требуется');
  //       return;
  //     }

  //     upgradeCheckedForSession = true;
  //     final differenceLevel = versionDiff(currentVersion, newVersion);

  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (_) {
  //           if (differenceLevel >= 2) {
  //             return MainUpgradeMustDialog();
  //           }
  //           return MainUpgradeDialog(
  //             newVersion: newVersion,
  //             currentVersion: currentVersion,
  //           );
  //         },
  //       );
  //     });
  //   } catch (e, s) {
  //     log('❌ Ошибка при инициализации upgrader: $e');
  //     log('$s'); //TODO sentry
  //   }
  // }

  // int versionDiff(String current, String store) {
  //   final cur = current.split('.').map(int.tryParse).toList();
  //   final sto = store.split('.').map(int.tryParse).toList();

  //   for (int i = 0; i < 3; i++) {
  //     final storeVal = sto.length > i ? sto[i] ?? 0 : 0;
  //     final currentVal = cur.length > i ? cur[i] ?? 0 : 0;
  //     final diff = storeVal - currentVal;

  //     if (diff >= 2) return 2; // критическое отставание
  //     if (diff >= 1) return 1; // обычное обновление
  //     if (diff < 0) return 0; // вдруг тестовая версия
  //   }

  //   return 0; // версии равны
  // }

////////////////////////////////////////////////////////////////////
  // bool _isSplashScreenTime = true;

  @override
  void initState() {
    log('MainPage initState start');
    super.initState();
    // checkForUpgrade();
    ImInShopBloc _imInShopBloc = BlocProvider.of(context);
    AddressesClientBloc _clientAddressBloc = BlocProvider.of<AddressesClientBloc>(context);
    _clientAddressBloc.add(LoadedAddressesClientEvent());
    _imInShopBloc.add(ImInShopLoadEvent());
    StoriesListBloc _storiesListBloc = BlocProvider.of(context);
    OrderProcessListBloc _orderProcessListBloc = BlocProvider.of(context);
    AssortmentRecommendationBloc _assortmentRecommendationBloc = BlocProvider.of<AssortmentRecommendationBloc>(context);
    _assortmentRecommendationBloc.add(AssortmentRecommendationsLoadEvent());
    _storiesListBloc.add(StoriesListLoadEvent());
    _orderProcessListBloc.add(OrderPLLoadEvent());
    _mainScreens = [
      HomeScreen(homePageNavKey: _naviagtorKeys["homePageKey"]),
      CatalogScreen(paginationViewkey: paginationViewkey, catalogNavKey: _naviagtorKeys["catalogPageKey"]),
      BasketScreen(basketNavKey: _naviagtorKeys["basketPageKey"]),
      // BsScreen(basketNavKey: _naviagtorKeys["basketPageKey"]),
      // ShoppingHistoryPage(historyNavKey: _naviagtorKeys["shoppingHistoryPageKey"])
      ProfilePage(profileNavKey: _naviagtorKeys["profilePageKey"])
    ];
    _pageController = PageController(initialPage: widget.token != "guest" ? _currentIndex : 1);
    log('MainPage initState end');
  }

  GlobalKey<PaginationViewState> paginationViewkey = GlobalKey<PaginationViewState>();

  @override
  Widget build(BuildContext context) {
    BasicPageBloc _basicPageBloc = BlocProvider.of<BasicPageBloc>(context);
    AuthPageBloc _regBloc = BlocProvider.of<AuthPageBloc>(context);
    ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
    if (_profileBloc.state is ProfileEmptyState) {
      if (widget.token == "guest") {
        _profileBloc.add(ProfileAsGuestEvent());
      } else {
        _profileBloc.add(ProfileLoadEvent());
      }
    }
    LoyaltyCardsListBloc _loyaltyCardsListBloc = BlocProvider.of<LoyaltyCardsListBloc>(context);
    CreditCardsListBloc _cardsListBloc = BlocProvider.of<CreditCardsListBloc>(context);
    ShoppingHistoryBloc _shoppingHistoryBloc = BlocProvider.of<ShoppingHistoryBloc>(context);
    SecondaryPageBloc _bottomNavBloc = BlocProvider.of<SecondaryPageBloc>(context);
    TagsBloc _tagsBloc = BlocProvider.of<TagsBloc>(context);
    AssortmentRecommendationBloc _assortmentRecommendationBloc = BlocProvider.of<AssortmentRecommendationBloc>(context);
    BasketListBloc _basketListBloc = BlocProvider.of<BasketListBloc>(context);
    FavoriteProductBloc _favoriteProductbloc = BlocProvider.of<FavoriteProductBloc>(context);
    DiverseFoodBloc _diverseFoodBloc = BlocProvider.of<DiverseFoodBloc>(context);

    if (widget.token != "guest") {
      log('MainPage build widget.token != guest 0');
      _diverseFoodBloc.add(DiverseFoodLoadEvent());
      _tagsBloc.add(TagsloadEvent());
      _basketListBloc.add(BasketLoadEvent());
      _favoriteProductbloc.add(FavoriteProductLoadEvent());
      log('MainPage build widget.token != guest 1');
    }

    return BlocBuilder<AddressesClientBloc, ClientAddressState>(
      builder: (context, clientAddressState) {
        if (clientAddressState is LoadedClientAddressState && _isInit) {
          if (clientAddressState.clientAddressModelList.isEmpty) {
            _isInit = false;
            SchedulerBinding.instance.addPostFrameCallback(
              (_) => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => InitAddUserAddress(heightOfBottomNavBar: null))),
            );
          } else {
            // isInit = false;
          }
        }

        return BlocBuilder<SecondaryPageBloc, SecondaryPageState>(
          builder: (BuildContext context, currentNavState) {
            // SchedulerBinding.instance.addPostFrameCallback((_) {
            if (currentNavState is SecondaryHomePageState) {
              _currentIndex = 0;
              // _pageController.jumpToPage(currentIndex);
            } else if (currentNavState is SecondaryCatalogPageState) {
              if (paginationViewkey.currentState != null) {
                paginationViewkey.currentState.refresh();
              }
              _currentIndex = 1;
              // _pageController.jumpToPage(currentIndex);
            } else if (currentNavState is SecondaryBasketPageState) {
              _currentIndex = 3;
              // _pageController.jumpToPage(currentIndex);
            } else if (currentNavState is SecondaryProfilePageState) {
              _currentIndex = 4;
              // _pageController.jumpToPage(currentIndex);
            }
            // });

            if (_pageController.hasClients) {
              if (currentNavState is SecondaryHomePageState) {
                // currentIndex = 0;
                _pageController.jumpToPage(_currentIndex);
              } else if (currentNavState is SecondaryCatalogPageState) {
                // currentIndex = 1;
                _pageController.jumpToPage(_currentIndex);
              } else if (currentNavState is SecondaryBasketPageState) {
                // currentIndex = 2;
                _pageController.jumpToPage(2);
              } else if (currentNavState is SecondaryProfilePageState) {
                // currentIndex = 3;
                _pageController.jumpToPage(3);
              }
            }

            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                if (profileState is ProfileLoadedState ||
                    profileState is ProfileErrorState ||
                    profileState is ProfileAsGuestState ||
                    profileState is ProfileBadTokenState) {
                  if (profileState is ProfileBadTokenState) {
                    ProfilePage.destroySharedPref();
                    _regBloc.add(LoginEvent());
                    _basicPageBloc.add(BasicPagesEvent.regPageEvent);
                  }
                  _isSplashing = false;
                }
                // ignore: unrelated_type_equality_checks
                if (_isSplashing == false || loadToken() == "guest") {
                  print('!!! _isSplashing == false || loadToken() == "guest" !!!');
                  context.read<AddressesShopBloc>().add(ListAddressesShopEvent(notNeedToAskLocationAgain: true));
                  return BlocListener<BasketListBloc, BasketState>(
                    listener: (context, state) {
                      if (state is BasketLoadedState) {
                        log('Main page');
                        if (isToFreeFirst) {
                          context.read<OrderCalculateBloc>().add(OrderCalculateLoadEvent(
                              orderDeliveryTypeId: "delivery",
                              orderPaymentTypeId: "online",
                              productModelForOrderRequestList: state.productModelForOrderRequestList));
                        }
                        isToFreeFirst = true;
                      }
                    },
                    child: WillPopScope(
                      onWillPop: () async {
                        if (currentNavState is SecondaryHomePageState) {
                          if (await _naviagtorKeys["homePageKey"].currentState.maybePop()) {
                          } else {
                            _pageController.jumpToPage(0);
                            _bottomNavBloc.add(HomeEvent());
                          }
                        }
                        if (currentNavState is SecondaryBasketPageState) {
                          if (await _naviagtorKeys["basketPageKey"].currentState.maybePop()) {
                          } else {
                            _pageController.jumpToPage(0);
                            _bottomNavBloc.add(HomeEvent());
                          }
                        }
                        if (currentNavState is SecondaryProfilePageState) {
                          if (await _naviagtorKeys["profilePageKey"].currentState.maybePop()) {
                          } else {
                            _pageController.jumpToPage(0);
                            _bottomNavBloc.add(HomeEvent());
                          }
                        }

                        if (currentNavState is SecondaryCatalogPageState) {
                          if (profileState is ProfileLoadedState &&
                              profileState.profileModel.data.selectedStoreUserUuid != null &&
                              await _naviagtorKeys["catalogPageKey"].currentState.maybePop()) {
                          } else {
                            _assortmentRecommendationBloc.add(AssortmentRecommendationsLoadEvent());
                            if (await AssortmentFilterButton().loadToken() != "guest") {
                              _pageController.jumpToPage(0);
                              _bottomNavBloc.add(HomeEvent());
                            } else {
                              AssortmentFilterButton().loginOrRegWarning(context);
                            }
                          }
                        }
                        return false;
                      },
                      child: Scaffold(
                          extendBodyBehindAppBar: true,
                          resizeToAvoidBottomInset: false,
                          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                          floatingActionButton: LoyaltyCardButtonWidget(),
                          bottomNavigationBar: Theme(
                            data: ThemeData(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: BottomNavigationBar(
                              type: BottomNavigationBarType.fixed,
                              backgroundColor: Colors.white,
                              elevation: 9.0,
                              onTap: (index) async {
                                if (await AssortmentFilterButton().loadToken() != "guest") {
                                  _currentIndex = index;
                                  if (index == 0) {
                                    if (_bottomNavBloc.state is SecondaryHomePageState &&
                                        _naviagtorKeys["homePageKey"].currentState != null &&
                                        _naviagtorKeys["homePageKey"].currentState.canPop()) {
                                      _naviagtorKeys["homePageKey"]
                                          .currentState
                                          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                                    }
                                    _bottomNavBloc.add(HomeEvent());
                                  }
                                  if (index == 1) {
                                    if (_bottomNavBloc.state is SecondaryCatalogPageState) {
                                    } else {
                                      _assortmentRecommendationBloc.add(AssortmentRecommendationsLoadEvent());
                                    }
                                    _bottomNavBloc.add(CatalogEvent());
                                  }
                                  if (index == 3) {
                                    _assortmentRecommendationBloc.add(AssortmentRecommendationsLoadEvent());
                                    _basketListBloc.add(BasketLoadEvent());
                                    _bottomNavBloc.add(BasketPageLoadEvent());
                                  }
                                  if (index == 4) {
                                    if (_bottomNavBloc.state is SecondaryProfilePageState &&
                                        _naviagtorKeys["profilePageKey"].currentState != null &&
                                        _naviagtorKeys["profilePageKey"].currentState.canPop()) {
                                      _naviagtorKeys["profilePageKey"]
                                          .currentState
                                          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                                    } else {
                                      _loyaltyCardsListBloc.add(LoyaltyCardsListLoadEvent());
                                      _cardsListBloc.add(CreditCardsListLoadEvent());
                                      _shoppingHistoryBloc.add(ShoppingHistoryCheckListEvent());
                                      _bottomNavBloc.add(ProfilePageEvent());
                                    }
                                  }
                                } else if (index == 1) {
                                  _bottomNavBloc.add(CatalogEvent());
                                  _pageController.jumpToPage(index);
                                } else {
                                  AssortmentFilterButton().loginOrRegWarning(context);
                                }
                              },
                              currentIndex: _currentIndex,
                              selectedItemColor: newRedDark,
                              items: [
                                BottomNavigationBarItem(
                                  icon: Padding(
                                    padding: EdgeInsets.only(bottom: heightRatio(size: 3, context: context)),
                                    child: SvgPicture.asset(
                                      'assets/images/homeIcon.svg',
                                      color: _currentIndex == 0 ? newRedDark : colorBlack04,
                                      width: widthRatio(size: 20, context: context),
                                      height: heightRatio(size: 20, context: context),
                                    ),
                                  ),
                                  label: 'mainText'.tr(),
                                ),
                                BottomNavigationBarItem(
                                    icon: Padding(
                                      padding: EdgeInsets.only(bottom: heightRatio(size: 3, context: context)),
                                      child: SvgPicture.asset(
                                        'assets/images/catalogIcon.svg',
                                        color: _currentIndex == 1 ? newRedDark : colorBlack04,
                                        width: widthRatio(size: 20, context: context),
                                        height: heightRatio(size: 20, context: context),
                                      ),
                                    ),
                                    label: 'catalogText'.tr()),
                                BottomNavigationBarItem(
                                  icon: SizedBox(),
                                  label: '',
                                ),
                                BottomNavigationBarItem(
                                    icon: BlocBuilder<BasketListBloc, BasketState>(builder: (context, state) {
                                      if (state is BasketLoadedState) {
                                        int totalQuantity = 0;
                                        // for (var i = 0;
                                        //     i < state.basketListModel.data.length;
                                        //     i++) {
                                        //   totalQuantity +=
                                        //       state.basketListModel.data[i].quantity;
                                        totalQuantity = state.basketListModel.data.length;

                                        return Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(bottom: heightRatio(size: 3, context: context)),
                                              child: SvgPicture.asset(
                                                'assets/images/busketIcon.svg',
                                                color: _currentIndex == 3 ? mainColor : colorBlack04,
                                                width: widthRatio(size: 20, context: context),
                                                height: heightRatio(size: 20, context: context),
                                              ),
                                            ),
                                            Positioned(
                                              width: widthRatio(size: 16, context: context),
                                              height: heightRatio(size: 16, context: context),
                                              right: widthRatio(size: -10, context: context),
                                              top: heightRatio(size: -5, context: context),
                                              child: CircleAvatar(
                                                  backgroundColor: Colors.green,
                                                  child: Text(totalQuantity.toString(),
                                                      style: appTextStyle(
                                                          fontSize: heightRatio(size: 11, context: context),
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.white))),
                                            ),
                                          ],
                                        );
                                      }
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: heightRatio(size: 3, context: context)),
                                        child: SvgPicture.asset(
                                          'assets/images/busketIcon.svg',
                                          color: _currentIndex == 3 ? newRedDark : colorBlack04,
                                        ),
                                      );
                                    }),
                                    label: 'basketText'.tr()),
                                BottomNavigationBarItem(
                                    icon: Padding(
                                      padding: EdgeInsets.only(bottom: heightRatio(size: 3, context: context)),
                                      child: SvgPicture.asset(
                                        'assets/images/newProfileIcon.svg',
                                        color: _currentIndex == 4 ? newRedDark : colorBlack04,
                                        width: widthRatio(size: 21, context: context),
                                        height: heightRatio(size: 20, context: context),
                                      ),
                                    ),
                                    label: 'Профиль'),
                              ],
                              selectedLabelStyle: appLabelTextStyle(fontSize: 10),
                              unselectedLabelStyle: appLabelTextStyle(fontSize: 10),
                              unselectedItemColor: Color(0xFF6B6F7A).withOpacity(0.68),
                            ),
                          ),
                          body: PageView(
                            controller: _pageController,
                            physics: NeverScrollableScrollPhysics(),
                            children: _mainScreens,
                          )),
                    ),
                  );
                } else {
                  return SplashScreen();
                }
              },
            );
          },
        );
      },
    );
  }
}
