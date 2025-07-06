import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/favorite_product_bloc.dart';
import 'package:smart/bloc_files/shopping_lists_bloc.dart';
import 'package:smart/bloc_files/smart_contacts_bloc.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/custom_widgets/contacts_widgets.dart';
import 'package:smart/custom_widgets/recomendation_list_widget.dart';
import 'package:smart/custom_widgets/redesigned_widgets/Stories_list_widget.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_event.dart';
import 'package:smart/features/home/banners/banners.dart';
import 'package:smart/features/home/widgets/home_diverse_food_card_button.dart';
import 'package:smart/features/fav_product/widgets/fav_product_card_button.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_home_page_top_menu_item.dart';
import 'package:smart/custom_widgets/redesigned_widgets/update_app_bottom_sheet.dart';
import 'package:smart/features/catalog/bloc/catalogs_bloc.dart';
import 'package:smart/features/home/home_choose_store_screen.dart';
import 'package:smart/features/home/widgets/home_icon_promo.dart';
import 'package:smart/features/home/widgets/home_popup_beta_version.dart';
import 'package:smart/features/recipes/blocs/receipts_bloc/receipts_bloc.dart';
import 'package:smart/features/recipes/recipes_favorites_screen.dart';
import 'package:smart/main.dart';
import 'package:smart/order_process/order_process.dart';
import 'package:smart/pages/secondary_page.dart';
import 'package:smart/pages/shopping_list/shopping_lists_page.dart';
import 'package:smart/theme/app_screen.dart';

import '../../../bloc_files/assortment_recommendations_bloc.dart';
import '../../addresses/addresses_delivery/bloc/addresses_client_bloc.dart';
import '../../../bloc_files/im_in_shop_bloc.dart';
import '../../../bloc_files/stories_list_bloc.dart';
import '../../../order_process/order_process_list_bloc.dart';
import '../../basket/bloc/basket_list_bloc.dart';

class HomeContent extends StatefulWidget {
  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  Future<void> refresh(BuildContext context) async {
    ImInShopBloc _imInShopBloc = BlocProvider.of(context);
    AddressesClientBloc _clientAddressBloc = BlocProvider.of<AddressesClientBloc>(context);
    BasketListBloc _basketListBloc = BlocProvider.of<BasketListBloc>(context);
    StoriesListBloc _storiesListBloc = BlocProvider.of(context);
    OrderProcessListBloc _orderProcessListBloc = BlocProvider.of(context);
    AssortmentRecommendationBloc _assortmentRecommendationBloc = BlocProvider.of<AssortmentRecommendationBloc>(context);
    CatalogsBloc catalogsBloc = BlocProvider.of(context);
    FavoriteProductBloc favoriteProductBloc = BlocProvider.of(context); //

    _clientAddressBloc.add(LoadedAddressesClientEvent());
    _imInShopBloc.add(ImInShopLoadEvent());
    _assortmentRecommendationBloc.add(AssortmentRecommendationsLoadEvent());
    _storiesListBloc.add(StoriesListLoadEvent());
    _orderProcessListBloc.add(OrderPLLoadEvent());
    _basketListBloc.add(BasketLoadEvent());
    catalogsBloc.add(CatalogsLoadEvent());
    favoriteProductBloc.add(FavoriteProductLoadEvent()); //

    ////REFRESH EVENTS
  }

  bool isSocialNetworkFacebook = prefs.getBool(SharedKeys.isSocialNetworkFacebook) ?? false;

  @override
  Widget build(BuildContext context) {
    ShoppingListsBloc _shoppingListsBloc = BlocProvider.of<ShoppingListsBloc>(context);

    AddressesShopBloc _shopsBloc = BlocProvider.of<AddressesShopBloc>(context);
    SmartContactsBloc _smartContactsBloc = BlocProvider.of(context);

    return BlocConsumer<SmartContactsBloc, SmartContactsState>(listener: (BuildContext context, state) {
      if (state is SmartContactsLoadedState) {
        isSocialNetworkFacebook = state.smartContactsModel.data.socialNetworkFacebook == '1' ? true : false;
        if (!versionIsValid(
            minVersion: Platform.isIOS ? state.smartContactsModel.data.iosVersion : state.smartContactsModel.data.androidVersion,
            currentVersion: state.appVersion)) {
          showModalBottomSheet(
              clipBehavior: Clip.hardEdge,
              useRootNavigator: true,
              useSafeArea: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(heightRatio(size: 25, context: context)),
                  topRight: Radius.circular(heightRatio(size: 25, context: context)),
                ),
              ),
              builder: (context) {
                return Wrap(
                  children: [UpdateAppBottomSheet()],
                );
              },
              isScrollControlled: true,
              context: context);
        }
      }
    }, builder: (context, state) {
      if (state is SmartContactsInitState) {
        _smartContactsBloc.add(SmartContactsLoadEvent());
      }
      BlocProvider.of<ReceiptsBloc>(context).add(LoadReceiptsEvent('1'));
      log('HomeContent isSocialNetworkFacebook:::::::::: $isSocialNetworkFacebook');
      return Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: Colors.red,
              onRefresh: () => refresh(context),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: heightRatio(size: 16, context: context)),
                    StoriesListWidget(),
                    if (isSocialNetworkFacebook) SizedBox(height: heightRatio(size: 15, context: context)),
                    if (isSocialNetworkFacebook) HomePopupBetaVersion(),
                    OrderProcess(), //Ваш заказ в процессе
                    SizedBox(height: heightRatio(size: 16, context: context)),
                    Banners(),
                    Container(
                      padding: EdgeInsets.only(bottom: heightRatio(size: 15, context: context)),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(heightRatio(size: 25, context: context)),
                            bottomRight: Radius.circular(heightRatio(size: 25, context: context))),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: heightRatio(size: 24, context: context)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: widthRatio(size: 5, context: context),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: widthRatio(size: 50, context: context),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AppScreen(
                                            title: "promoText".tr(),
                                            titleCenter: true,
                                            content: HomeIconPromo(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: homePageTopMenuItem(
                                      text: "promoText".tr(),
                                      imagePath: "assets/images/newPercent.svg",
                                      context: context,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: widthRatio(size: 53, context: context),
                                  child: InkWell(
                                    onTap: () {
                                      _shoppingListsBloc.add(ShoppingListsLoadEvent());
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppinglistsPage()));
                                    },
                                    child: homePageTopMenuItem(text: "ListsText".tr(), imagePath: "assets/images/newList.svg", context: context),
                                  ),
                                ),
                                SizedBox(
                                  width: widthRatio(size: 57, context: context),
                                  child: InkWell(
                                    onTap: () {
                                      _shopsBloc.add(MapAddressesShopEvent());
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeChooseStoreScreen()));
                                    },
                                    child: homePageTopMenuItem(text: "storesText".tr(), imagePath: "assets/images/newStorBold2.svg", context: context),
                                  ),
                                ),
                                SizedBox(
                                  width: widthRatio(size: 55.5, context: context),
                                  child: InkWell(
                                    onTap: () {
                                      // _smartContactsBloc
                                      //     .add(SmartContactsLoadEvent());

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SecondaryPage(upText: "contactsText".tr(), contentWidget: Center(child: ContactsWidget()))));
                                    },
                                    child: homePageTopMenuItem(text: "contactsText".tr(), imagePath: "assets/images/newContacts.svg", context: context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: heightRatio(size: 10, context: context)),
                    FavProductCardButton(), //любимые продукты
                    SizedBox(height: heightRatio(size: 20, context: context)),
                    HomeDiverseFoodCardButton(), // разнообраное питание
                    SizedBox(height: heightRatio(size: 20, context: context)),
                    BlocBuilder<ReceiptsBloc, ReceiptsState>(
                      builder: (context, state) {
                        // if (state is ReceiptsLoadingState) {
                        //   return Container(
                        //     height: heightRatio(size: 120, context: context),
                        //     alignment: Alignment.center,
                        //     child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(newRedDark)),
                        //   );
                        // }
                        if (state is ReceiptsLoadedState) {
                          int recipeCount = state.receiptsList.data.where((recipe) => recipe.isFavorite == true).toList().length;
                          String recipeCountText = '';
                          if (recipeCount == 1) {
                            recipeCountText = 'рецепт';
                          } else if (recipeCount > 1 && recipeCount < 5) {
                            recipeCountText = 'рецепта';
                          } else {
                            recipeCountText = 'рецептов';
                          }
                          return recipeCount > 0
                              ? InkWell(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecipesFavoritesScreen())),
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: heightRatio(size: 20, context: context)),
                                    height: heightRatio(size: 120, context: context),
                                    width: double.maxFinite,
                                    padding: EdgeInsets.only(
                                      left: widthRatio(size: 16, context: context),
                                      right: widthRatio(size: 10, context: context),
                                      top: heightRatio(size: heightRatio(size: 19, context: context), context: context),
                                      bottom: heightRatio(size: heightRatio(size: 19, context: context), context: context),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(image: AssetImage('assets/images/newFavoriteRecipes.png'), fit: BoxFit.cover),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Сохраненные рецепты',
                                              style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                                            ),
                                            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: heightRatio(size: 23, context: context)),
                                          ],
                                        ),
                                        SizedBox(height: heightRatio(size: 2, context: context)),
                                        Text(
                                          'Рецепты, которые вы сохранили',
                                          style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 14, context: context)),
                                        ),
                                        Spacer(),
                                        Text(
                                          '$recipeCount $recipeCountText',
                                          style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox.shrink();
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    // RedesImInShopCArdButton(), //я в магазине
                    // SizedBox(height: heightRatio(size: 8, context: context)),
                    // RedesBonusesCardButton(),
                    SizedBox(height: heightRatio(size: 20, context: context)),
                    RecommendationListWidget(isHomePage: true),
                    SizedBox(height: heightRatio(size: 33, context: context)),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  bool versionIsValid({String minVersion, String currentVersion}) {
    if (minVersion == null) return true;
    minVersion = minVersion.replaceAll(new RegExp(r'[^0-9]+'), '');
    currentVersion = currentVersion.replaceAll(new RegExp(r'[^0-9]+'), '');

    while (currentVersion.length != minVersion.length) {
      if (currentVersion.length < minVersion.length) {
        currentVersion += "0";
      } else {
        minVersion += "0";
      }
    }

    var _minVersion = int.parse(minVersion);
    var _currentversion = int.parse(currentVersion);
    return _currentversion >= _minVersion;
  }
}
