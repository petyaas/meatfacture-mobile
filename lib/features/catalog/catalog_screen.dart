import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:smart/bloc_files/assortment_filter_bloc.dart';
import 'package:smart/features/addresses/addresses_change_selected_shop_bottom_sheet.dart';
import 'package:smart/features/addresses/addresses_delivery_and_shops.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_state.dart';
import 'package:smart/features/catalog/bloc/catalogs_bloc.dart';
import 'package:smart/bloc_files/order_type_bloc.dart';
import 'package:smart/features/catalog/subcatalog_screen.dart';
import 'package:smart/features/catalog/widgets/catalog_address_confirmation_dialog.dart';
import 'package:smart/custom_widgets/assortment_filter_button.dart';
import 'package:smart/custom_widgets/assortment_search_button.dart';
import 'package:smart/custom_widgets/redesigned_widgets/to_free_delivery_widget.dart';
import 'package:smart/features/catalog/cubit/catalog_rebuild_cubit.dart';
import 'package:smart/features/catalog/widgets/catalog_levels_widget.dart';
import 'package:smart/features/recipes/blocs/receipts_bloc/receipts_bloc.dart';
import 'package:smart/features/recipes/widgets/recipes_carousel_widget.dart';
import 'package:smart/features/recipes/recipes_screen.dart';
import 'package:smart/main.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/order_process/order_process.dart';

class CatalogScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> catalogNavKey;
  final GlobalKey<PaginationViewState> paginationViewkey;

  const CatalogScreen({@required this.catalogNavKey, @required this.paginationViewkey});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> with AutomaticKeepAliveClientMixin {
  CatalogsBloc catalogsBloc;
  bool _isWantKeepAlive = true;

  @override
  void initState() {
    super.initState();
    _checkIsChoosenAddressesForThisSession();
  }

  Future<void> _checkIsChoosenAddressesForThisSession() async {
    String isChoosenAddressesForThisSession = prefs.getString(SharedKeys.isChoosenAddressesForThisSession);
    if (isChoosenAddressesForThisSession == 'no') {
      print(isChoosenAddressesForThisSession + '**************isChoosenAddressesForThisSession********************');
      await Future.delayed(Duration(seconds: 1));
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CatalogAddressConfirmationDialog(
          // при клике на изменить адрес доставки:
          onChangeAddressDelivery: () => _checkIsChoosenAddressesForThisSession(),
        ),
      );
    }
  }

  // Для смены адреса магазина:
  void openChangeSelectedAddressBottomSheet(BuildContext context) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(heightRatio(size: 25, context: context)),
          topRight: Radius.circular(heightRatio(size: 25, context: context)),
        ),
      ),
      builder: (BuildContext bc) {
        return Wrap(children: [AddressesChangeSelectedShopBottomSheet()]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) {
        final bloc = CatalogsBloc();
        bloc.add(CatalogsLoadEvent());
        return bloc;
      },
      child: BlocBuilder<CatalogRebuildCubit, CatalogRebuildState>(
        builder: (context, state) {
          AssortmentFiltersBloc _assortmentFiltersBloc = BlocProvider.of<AssortmentFiltersBloc>(context);
          _assortmentFiltersBloc.add(AssortmentFiltersLoadEvent(isFavorite: false));
          return Navigator(
            key: widget.catalogNavKey,
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: newRedDark,
                body: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            bottom: heightRatio(size: 3, context: context),
                            right: widthRatio(size: 15, context: context),
                            left: widthRatio(size: 15, context: context)),
                        child: Column(
                          children: [
                            SizedBox(height: heightRatio(size: 5, context: context)),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Общий каталог",
                                    style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                                  ),
                                ),
                                AssortmentSearchButton(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return SubcatalogScreen(isSearchPage: true);
                                  })),
                                ),
                                SizedBox(width: widthRatio(size: 6, context: context)),
                                AssortmentFilterButton(), //фильтры
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddressesDeliveryAndShops()),
                                );
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/images/newStor.svg',
                                      color: Colors.white, height: heightRatio(size: 14, context: context), width: widthRatio(size: 16, context: context)),
                                  SizedBox(width: widthRatio(size: 12, context: context)),
                                  BlocBuilder<AddressesShopBloc, AddressesShopState>(
                                    builder: (context, shopState) {
                                      String shopAddress = "";
                                      if (shopState is LoadedAddressesShopState && shopState.selectedShop != null) {
                                        shopAddress = shopState.selectedShop.address;
                                      }
                                      return Text(
                                        shopAddress,
                                        textAlign: TextAlign.center,
                                        style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: Colors.white),
                                      );
                                    },
                                  ),
                                  SizedBox(width: widthRatio(size: 15, context: context)),
                                  SvgPicture.asset(
                                    'assets/images/newEdit2.svg',
                                    height: heightRatio(size: 26, context: context),
                                    width: widthRatio(size: 26, context: context),
                                    fit: BoxFit.scaleDown,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: heightRatio(size: 4, context: context)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(heightRatio(size: 15, context: context)),
                              topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                            ),
                          ),
                          child: Stack(
                            children: [
                              ListView(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: widthRatio(size: 16, context: context),
                                      vertical: heightRatio(size: 8, context: context),
                                    ),
                                    child: OrderProcess(),
                                  ), //Ваш заказ в процессе
                                  BlocBuilder<ReceiptsBloc, ReceiptsState>(
                                    builder: (context, state) {
                                      if (state is ReceiptsLoadingState) {
                                        return Container(
                                          height: heightRatio(size: 200, context: context),
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(newRedDark)),
                                        );
                                      }
                                      if (state is ReceiptsLoadedState) {
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: widthRatio(size: 16, context: context)),
                                                Text("Рецепты", style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack)),
                                                Spacer(),
                                                InkWell(
                                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecipesScreen())),
                                                  child: Container(
                                                    decoration: BoxDecoration(color: lightGreyColor, borderRadius: BorderRadius.circular(14)),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: widthRatio(size: 12, context: context),
                                                        right: widthRatio(size: 10, context: context),
                                                        top: heightRatio(size: 4, context: context),
                                                        bottom: heightRatio(size: 4, context: context),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text("Все",
                                                              style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newBlack)),
                                                          SizedBox(width: widthRatio(size: 7.54, context: context)),
                                                          RotationTransition(
                                                            turns: AlwaysStoppedAnimation(180 / 360),
                                                            child: SvgPicture.asset(
                                                              'assets/images/arrow_back.svg',
                                                              width: widthRatio(size: 4.31, context: context),
                                                              height: heightRatio(size: 7.54, context: context),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: widthRatio(size: 16, context: context)),
                                              ],
                                            ),
                                            SizedBox(height: heightRatio(size: 20, context: context)),
                                            RecipesCarousel(receiptsList: state.receiptsList),
                                          ],
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    },
                                  ),
                                  SizedBox(height: heightRatio(size: 24, context: context)),
                                  BlocBuilder<CatalogsBloc, CatalogsState>(
                                    builder: (context, state) {
                                      if (state.catalogsList.isNotEmpty) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 150),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: state.catalogsList.map<Widget>((catalog) {
                                              return CatalogLevelsWidget(
                                                catalogListModel: catalog,
                                                isFromFavCatalogsList: false,
                                              );
                                            }).toList(),
                                          ),
                                        );
                                      } else if (state is CatalogsLoadedState) {
                                        return SizedBox(
                                          height: heightRatio(size: 250, context: context),
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 30, context: context)),
                                              child: Text(
                                                'У данного магазина нет каталогов, пожалуйста выберите другой магазин',
                                                textAlign: TextAlign.center,
                                                style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    },
                                  ),
                                ],
                              ),
                              BlocBuilder<CatalogsBloc, CatalogsState>(
                                builder: (context, state) {
                                  if (state.catalogsList.isNotEmpty) {
                                    return BlocBuilder<OrderTypeBloc, OrderTypeState>(
                                      builder: (context, state) {
                                        if (state is OrderTypeDeliveryState) {
                                          return Positioned(bottom: 0, left: 0, right: 0, child: ToFreeDeliveryWidget());
                                        } else {
                                          return SizedBox();
                                        }
                                      },
                                    );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => _isWantKeepAlive;
}
