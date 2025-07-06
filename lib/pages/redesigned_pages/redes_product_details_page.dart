import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_will_pop_scope/custom_will_pop_scope.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart/bloc_files/assortment_comments_bloc.dart';
import 'package:smart/bloc_files/assortment_recommendations_bloc.dart';
import 'package:smart/bloc_files/basic_page_bloc.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/bloc_files/product_details_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/bloc_files/shopping_lists_bloc.dart';
import 'package:smart/custom_widgets/add_product_to_Shopping_list_bottom_sheet.dart';
import 'package:smart/custom_widgets/assortment_filter_button.dart';
import 'package:smart/custom_widgets/product_details_tegs_widget.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_product_details_middle_content_widget.dart';
import 'package:smart/models/favorite_product_variant_uuid_model.dart';
import 'package:smart/models/product_details_data_model.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/pages/redesigned_pages/redes_product_details_button.dart';
import 'package:smart/services/services.dart';
import 'package:smart/services/ui_services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/utils/custom_cache_manager.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

import '../../bloc_files/product_details_middle_content_bloc.dart';
import '../../custom_widgets/redesigned_widgets/discount_text_in_product_det.dart';

class RedesProductDetailsPage extends StatefulWidget {
  final bool isFavoritePage;
  final bool isFromBasket;
  final String productUuid;

  // final String productsQuantity;

  RedesProductDetailsPage({this.isFavoritePage, this.isFromBasket, @required this.productUuid});

  @override
  _RedesProductDetailsPageState createState() => _RedesProductDetailsPageState();
}

double countInBasket;

class _RedesProductDetailsPageState extends State<RedesProductDetailsPage> {
  bool isInBasket = false;
  double quantityInCartToBack;
  double priceWithDiscountInCartToBack;
  String currentPriceInCartToBack;
  String discountTypeColorInCartToBack;
  bool isFavorite;
  double kgToAddToBasket = 0;
  final ValueNotifier<int> _currentIndexSliderNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    AssortmentRecommendationBloc _assortmentRecommendationBloc = BlocProvider.of<AssortmentRecommendationBloc>(context);
    _assortmentRecommendationBloc.add(AssortmentRecommendationsLoadEvent());
    super.initState();
  }

  @override
  void dispose() {
    _currentIndexSliderNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AssortmentCommentsBloc _assortmentCommentsBloc = BlocProvider.of<AssortmentCommentsBloc>(context);

    SecondaryPageBloc _secondaryPageBloc = BlocProvider.of(context);

    BasketListBloc _basketListBloc = BlocProvider.of<BasketListBloc>(context);
    ProductDetMiddleContentBloc _productDetMiddleContentBloc = BlocProvider.of<ProductDetMiddleContentBloc>(context);
    ShoppingListsBloc _shoppingListsBloc = BlocProvider.of<ShoppingListsBloc>(context);

    void _openaddingProductToShoppingListBottomSheet(
        {BuildContext context,
        String assortmentUuid,
        String price,
        ProductDetailsBloc productDetailsBloc,
        double priceWithDiscount,
        List<ProductDetailsUserShoppingList> addedShoppingList}) {
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
            return Wrap(
              children: [
                AddProductToShoppingListBottomSheetwidget(
                  productDetailsBloc: productDetailsBloc,
                  priceWithDiscount: priceWithDiscount,
                  assortmentPrice: price,
                  addedShoppingList: addedShoppingList,
                  assortmentUuid: assortmentUuid,
                ),
              ],
            );
          }).then((value) {});
    }

    return CustomWillPopScope(
      onWillPop: null,
      onPopAction: () async {
        _productDetMiddleContentBloc.add(ProductDetMiddleContentDisableEvent());
        Navigator.pop(context, [
          quantityInCartToBack,
          priceWithDiscountInCartToBack,
          currentPriceInCartToBack,
          discountTypeColorInCartToBack,
          isFavorite,
        ]);
        return true;
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, profileState) {
        return BlocProvider(
          create: (context) => ProductDetailsBloc(),
          child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(builder: (context, state) {
            ProductDetailsBloc _productDetailsBloc = BlocProvider.of(context);

            if (state is ProductDetailsEmptyState) {
              _productDetailsBloc.add(ProductDetailsLoadEvent(uuid: widget.productUuid));
              return Container(alignment: Alignment.center, color: Colors.white);
            }
            if (state is ProductDetailsLoadingState) {
              return Container(
                alignment: Alignment.center,
                color: Colors.white,
                child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor)),
              );
            }
            if (state is ProductDetailsErrorState) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: widthRatio(size: 20, context: context), right: widthRatio(size: 20, context: context)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                    topRight: Radius.circular(heightRatio(size: 15, context: context)),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
                        decoration: BoxDecoration(color: colorBlack03, shape: BoxShape.circle),
                        child: SvgPicture.asset(
                          'assets/images/netErrorIcon.svg',
                          color: Colors.white,
                          height: heightRatio(size: 30, context: context),
                        ),
                      ),
                      SizedBox(height: heightRatio(size: 15, context: context)),
                      Text("errorText".tr(),
                          style: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500)),
                      SizedBox(height: heightRatio(size: 10, context: context)),
                      InkWell(
                        onTap: () {
                          _productDetailsBloc.add(ProductDetailsLoadEvent(uuid: state.uuid));
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Text(
                            "tryAgainText".tr(),
                            style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Basic State
            if (state is ProductDetailsLoadedState) {
              _assortmentCommentsBloc.add(AssortmentCommentsLoadEvent(assortmentUuid: state.productDetailsModel.data.uuid));
              currentPriceInCartToBack = state.productDetailsModel.data.currentPrice;
              priceWithDiscountInCartToBack = state.productDetailsModel.data.priceWithDiscount;
              quantityInCartToBack = state.productDetailsModel.data.quantityInClientCart;
              discountTypeColorInCartToBack = state.productDetailsModel.data.discountTypeColor;

              if (state.productDetailsModel.data.quantityInClientCart != null && state.productDetailsModel.data.quantityInClientCart > 0) {
                isInBasket = true;
              }
              return BlocBuilder<BasketListBloc, BasketState>(builder: (context, basketState) {
                if (basketState is BasketLoadedState && _secondaryPageBloc.state is SecondaryBasketPageState) {
                  if (widget.isFromBasket == null || widget.isFromBasket == false) {
                    for (var i = 0; i < basketState.basketListModel.data.length; i++) {
                      if (state.productDetailsModel.data.uuid == basketState.basketListModel.data[i].assortment.uuid) {
                        state.productDetailsModel.data.quantityInClientCart = basketState.basketListModel.data[i].quantity;
                        isInBasket = true;
                        break;
                      } else {
                        state.productDetailsModel.data.quantityInClientCart = 0;
                        isInBasket = false;
                      }
                    }
                  }
                } else {
                  if (basketState is BasketEmptyState && _secondaryPageBloc.state is SecondaryBasketPageState) {
                    state.productDetailsModel.data.quantityInClientCart = 0;
                    isInBasket = false;
                  }
                }
                return Scaffold(
                  body: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      // 1 товар - детализация
                      CustomScrollView(
                        scrollBehavior: MyBehavior(),
                        slivers: [
                          SliverAppBar(
                            floating: true,
                            backgroundColor: Colors.white,
                            expandedHeight: 360,
                            automaticallyImplyLeading: false,
                            flexibleSpace: Stack(
                              children: [
                                if (state.productDetailsModel.data.images.isEmpty)
                                  Container(
                                    height: screenWidth(context),
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.asset("assets/images/notImage.png", fit: BoxFit.contain),
                                  ),
                                if (state.productDetailsModel.data.images.length == 1)
                                  Container(
                                    height: screenWidth(context),
                                    width: MediaQuery.of(context).size.width,
                                    child: CachedNetworkImage(
                                      imageUrl: state.productDetailsModel.data.images[0].path,
                                      cacheManager: CustomCacheManager(),
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) => Image.asset("assets/images/notImage.png", fit: BoxFit.contain),
                                      useOldImageOnUrlChange: true,
                                    ),
                                  ),
                                if (state.productDetailsModel.data.images.length > 1)
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      autoPlay: false,
                                      height: screenWidth(context),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      autoPlayAnimationDuration: const Duration(milliseconds: 500),
                                      autoPlayInterval: const Duration(seconds: 5),
                                      viewportFraction: 1,
                                      onPageChanged: (index, reason) {
                                        _currentIndexSliderNotifier.value = index;
                                      },
                                    ),
                                    items: state.productDetailsModel.data.images.map(
                                      (i) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: screenWidth(context),
                                              width: MediaQuery.of(context).size.width,
                                              child: CachedNetworkImage(
                                                imageUrl: i.path,
                                                cacheManager: CustomCacheManager(),
                                                fit: BoxFit.cover,
                                                errorWidget: (context, url, error) => Image.asset("assets/images/notImage.png", fit: BoxFit.contain),
                                                useOldImageOnUrlChange: true,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ).toList(),
                                  ),
                                if (state.productDetailsModel.data.images.length > 1)
                                  Positioned(
                                    bottom: 30,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: ValueListenableBuilder<int>(
                                        valueListenable: _currentIndexSliderNotifier,
                                        builder: (context, currentIndex, child) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: List.generate(
                                              state.productDetailsModel.data.images.length,
                                              (index) => Container(
                                                margin: EdgeInsets.symmetric(horizontal: 4),
                                                width: 12,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: currentIndex == index ? Colors.red : Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  bottom: -2,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: heightRatio(size: 25, context: context),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                                        topRight: Radius.circular(heightRatio(size: 15, context: context)),
                                      ),
                                    ),
                                  ),
                                ),

                                //Bonuses
                                if (state.productDetailsModel.data.totalBonus != null && state.productDetailsModel.data.totalBonus != 0)
                                  Positioned(
                                    top: (screenWidth(context) - widthRatio(size: 70, context: context)),
                                    left: widthRatio(size: 20, context: context),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.circular(widthRatio(size: 4, context: context)),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: widthRatio(size: 4, context: context), vertical: heightRatio(size: 2, context: context)),
                                      child: Row(children: [
                                        Container(
                                          width: widthRatio(size: 20, context: context),
                                          height: heightRatio(size: 20, context: context),
                                          child: SvgPicture.asset('assets/images/bonus_vector.svg',
                                              width: widthRatio(size: 20, context: context), height: heightRatio(size: 20, context: context)),
                                        ),
                                        SizedBox(
                                          width: widthRatio(size: 3, context: context),
                                        ),
                                        Text(
                                          state.productDetailsModel.data.totalBonus.toStringAsFixed(0),
                                          style:
                                              appTextStyle(fontSize: heightRatio(size: 16, context: context), fontWeight: FontWeight.w700, color: colorBlack06),
                                        )
                                      ]),
                                    ),
                                  ),
                                // назад
                                InkWell(
                                  onTap: () async {
                                    _productDetMiddleContentBloc.add(ProductDetMiddleContentDisableEvent());
                                    // _bottomNavBloc.add(CatalogEvent());
                                    Navigator.pop(context, [
                                      quantityInCartToBack,
                                      state.productDetailsModel.data.priceWithDiscount,
                                      state.productDetailsModel.data.currentPrice,
                                      state.productDetailsModel.data.discountTypeColor,
                                      state.productDetailsModel.data.isFavorite,
                                    ]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(color: newBlack, borderRadius: BorderRadius.circular(18)),
                                    width: 36,
                                    height: 36,
                                    margin: EdgeInsets.only(top: 43, left: 15),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 2,
                                          left: 1,
                                          child: Icon(Icons.chevron_left_rounded, color: Colors.white, size: 32),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width - widthRatio(size: 88, context: context),
                                            child: Text(
                                              state.productDetailsModel.data.name,
                                              style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context)),
                                            ),
                                          ),
                                          //rating
                                          if (state.productDetailsModel.data.rating != null)
                                            Row(
                                              children: [
                                                SvgPicture.asset("assets/images/newStar.svg", height: heightRatio(size: 15, context: context)),
                                                SizedBox(width: widthRatio(size: 5, context: context)),
                                                Text(
                                                  state.productDetailsModel.data.rating == null ? '' : state.productDetailsModel.data.rating.toString(),
                                                  style: appHeadersTextStyle(fontSize: 12, color: newGrey),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: heightRatio(size: 18, context: context)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox.shrink(),
                                          //Price
                                          Container(
                                            height: heightRatio(size: 32, context: context),
                                            width: widthRatio(size: 160, context: context),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: state.productDetailsModel.data.discountTypeColor == null
                                                  ? newRedDark
                                                  : Color(int.parse("0xff${state.productDetailsModel.data.discountTypeColor}")),
                                              borderRadius: BorderRadius.circular(heightRatio(size: 4, context: context)),
                                            ),
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: state.productDetailsModel.data.priceWithDiscount == null
                                                          ? state.productDetailsModel.data.currentPrice != null
                                                              ? state.productDetailsModel.data.productsQuantity != null &&
                                                                      state.productDetailsModel.data.productsQuantity != 0
                                                                  ? state.productDetailsModel.data.currentPrice
                                                                  : "notAvailableText".tr()
                                                              : "notAvailableText".tr()
                                                          : state.productDetailsModel.data.priceWithDiscount.toString(),
                                                      style: appHeadersTextStyle(fontSize: heightRatio(size: 17, context: context), color: Colors.white)),
                                                  TextSpan(
                                                      text: state.productDetailsModel.data.priceWithDiscount == null
                                                          ? state.productDetailsModel.data.currentPrice != null
                                                              ? state.productDetailsModel.data.productsQuantity != null &&
                                                                      state.productDetailsModel.data.productsQuantity != 0
                                                                  ? " ₽"
                                                                  : ""
                                                              : ""
                                                          : " ₽",
                                                      style: appTextStyle(
                                                          fontWeight: FontWeight.bold, color: Colors.white, fontSize: heightRatio(size: 17, context: context))),
                                                  state.productDetailsModel.data.assortmentUnitId != "package"
                                                      ? TextSpan(
                                                          text: state.productDetailsModel.data.priceWithDiscount == null
                                                              ? state.productDetailsModel.data.currentPrice != null
                                                                  ? state.productDetailsModel.data.productsQuantity != null &&
                                                                          state.productDetailsModel.data.productsQuantity != 0
                                                                      ? "/ ${getAssortmentUnitId(assortmentUnitId: state.productDetailsModel.data.assortmentUnitId)[1]}"
                                                                      : ""
                                                                  : ""
                                                              : "/${getAssortmentUnitId(assortmentUnitId: state.productDetailsModel.data.assortmentUnitId)[1]}",
                                                          style: appHeadersTextStyle(fontSize: heightRatio(size: 17, context: context), color: Colors.white))
                                                      : TextSpan(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: heightRatio(size: 15, context: context)),
                                      state.productDetailsModel.data.discountTypeName != null
                                          ? Row(
                                              children: [
                                                if (state.productDetailsModel.data.discountType.contains("diverse"))
                                                  Padding(
                                                    padding: EdgeInsets.only(right: widthRatio(size: 5, context: context)),
                                                    child: Image.asset(
                                                      "assets/images/diverse_food_image.png",
                                                      height: heightRatio(size: 20, context: context),
                                                    ),
                                                  ),
                                                if (state.productDetailsModel.data.discountType.contains("FavoriteAssortment"))
                                                  Padding(
                                                    padding: EdgeInsets.only(right: widthRatio(size: 5, context: context)),
                                                    child: Icon(
                                                      Icons.favorite,
                                                      color: colorRed,
                                                      size: heightRatio(size: 15, context: context),
                                                    ),
                                                  ),
                                                DiscountTitleText(
                                                  pDState: state,
                                                ),
                                              ],
                                            )
                                          : SizedBox(),
                                      SizedBox(height: heightRatio(size: 15, context: context)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Выбрать любимым
                                          RedesProductDetailsButton(
                                            isActive: state.productDetailsModel.data.isPromoFavorite ? true : false,
                                            icon: state.productDetailsModel.data.isPromoFavorite
                                                ? "assets/images/newChooseLovely.svg"
                                                : "assets/images/newChooseLovely.svg",
                                            text: state.productDetailsModel.data.isPromoFavorite ? "Добавлен\nв любимые" : "Выбрать\nлюбимым",
                                            onTapCallback: () async {
                                              if (await AssortmentFilterButton().loadToken() != "guest") {
                                                String _isSettedFavoriteProduct;
                                                FavoriteProductVariantUuidModel _favoriteProductVariantUuidModel =
                                                    await FavoriteProductProvider().getFavoriteProductVariantUuidResponse();

                                                if (_favoriteProductVariantUuidModel.data.isEmpty) {
                                                  showSnackBar(context, "Ошибка. Условия акции не выполнены!");
                                                } else {
                                                  _isSettedFavoriteProduct = await FavoriteProductProvider().setFavoriteProductResponse(
                                                    assortmentUuid: state.productDetailsModel.data.uuid,
                                                    variantUuid: _favoriteProductVariantUuidModel.data.first.uuid,
                                                  );

                                                  if (_isSettedFavoriteProduct == "old token") {
                                                    AuthPageBloc authPageBloc = BlocProvider.of(context);
                                                    BasicPageBloc basicPageBloc = BlocProvider.of(context);
                                                    ProfilePage.logout(regBloc: authPageBloc, basicPageBloc: basicPageBloc);
                                                  }
                                                  if (_isSettedFavoriteProduct == "ok") {
                                                    Timer(Duration(seconds: 1), () {
                                                      _productDetailsBloc.add(ProductDetailsLoadEvent(uuid: state.productDetailsModel.data.uuid));
                                                    });
                                                  } else if (_isSettedFavoriteProduct == "alreadyActivated") {
                                                    showSnackBar(context, "Вы уже изменили Любимый Продукт, снова поменять его можно будет завтра");
                                                  } else {
                                                    showSnackBar(context, "Ошибка. Условия акции не выполнены!");
                                                  }
                                                }
                                              } else {
                                                AssortmentFilterButton().loginOrRegWarning(context);
                                              }
                                            },
                                          ),

                                          // В список покупок
                                          RedesProductDetailsButton(
                                            isActive: state.productDetailsModel.data.userShoppingLists == null ||
                                                    state.productDetailsModel.data.userShoppingLists.isEmpty
                                                ? false
                                                : true,
                                            icon: "assets/images/newAddToCart.svg",
                                            text: 'inShopListText'.tr(),
                                            onTapCallback: () async {
                                              if (await AssortmentFilterButton().loadToken() != "guest") {
                                                _shoppingListsBloc.add(ShoppingListsLoadEvent());
                                                _openaddingProductToShoppingListBottomSheet(
                                                    productDetailsBloc: _productDetailsBloc,
                                                    priceWithDiscount: state.productDetailsModel.data.priceWithDiscount,
                                                    context: context,
                                                    assortmentUuid: state.productDetailsModel.data.uuid,
                                                    price: state.productDetailsModel.data.currentPrice,
                                                    addedShoppingList: state.productDetailsModel.data.userShoppingLists);
                                              } else {
                                                AssortmentFilterButton().loginOrRegWarning(context);
                                              }
                                            },
                                          ),

                                          // Добавить в избранное (внутри)
                                          RedesProductDetailsButton(
                                            isActive: state.productDetailsModel.data.isFavorite ? true : false,
                                            icon: 'assets/images/newHeartContur.svg',
                                            text: 'addTofavoriteText'.tr(),
                                            onTapCallback: () async {
                                              if (await AssortmentFilterButton().loadToken() != 'guest') {
                                                if (state.productDetailsModel.data.isFavorite) {
                                                  setState(() {
                                                    state.productDetailsModel.data.isFavorite = false;
                                                    isFavorite = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    state.productDetailsModel.data.isFavorite = true;
                                                    isFavorite = true;
                                                  });
                                                }
                                                var _likeResponse = await AddDeleteProductToFavoriteProvider(
                                                        isLiked: !state.productDetailsModel.data.isFavorite, productUuid: state.productDetailsModel.data.uuid)
                                                    .getisAddProductTofavoriteResponse();
                                                if (_likeResponse == 'old token') {
                                                  AuthPageBloc authPageBloc = BlocProvider.of(context);
                                                  BasicPageBloc basicPageBloc = BlocProvider.of(context);
                                                  ProfilePage.logout(regBloc: authPageBloc, basicPageBloc: basicPageBloc);
                                                }
                                              } else {
                                                AssortmentFilterButton().loginOrRegWarning(context);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 30),
                                      RedesProductDetailsMiddleContent(productDetailsModel: state.productDetailsModel),
                                      ProductDetailsTegsWidget(tagsList: state.productDetailsModel.data.tags),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      state.productDetailsModel.data.productsQuantity != null &&
                              state.productDetailsModel.data.productsQuantity != 0 &&
                              state.productDetailsModel.data.currentPrice != null
                          ? Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: !isInBasket
                                  ? InkWell(
                                      onTap: () async {
                                        if (profileState is ProfileAsGuestState) {
                                          AssortmentFilterButton().loginOrRegWarning(context);
                                        } else if (!isInBasket) {
                                          if (state.productDetailsModel.data.productsQuantity > state.productDetailsModel.data.quantityInClientCart) {
                                            if (state.productDetailsModel.data.assortmentUnitId != "kilogram") {
                                              setState(() {
                                                isInBasket = true;
                                              });
                                              if (state.productDetailsModel.data.quantityInClientCart < state.productDetailsModel.data.productsQuantity) {
                                                state.productDetailsModel.data.quantityInClientCart++;

                                                if (await BasketProvider().addProductInBasket(state.productDetailsModel.data.uuid, 1)) {
                                                  _basketListBloc.add(BasketLoadEvent());
                                                }
                                              }
                                            } else {
                                              setState(() {
                                                isInBasket = true;
                                              });
                                              double weight = double.tryParse(state.productDetailsModel.data.weight) ?? 0.0;
                                              double weightInKg = weight / 1000;
                                              if (state.productDetailsModel.data.quantityInClientCart < state.productDetailsModel.data.productsQuantity) {
                                                state.productDetailsModel.data.quantityInClientCart += weightInKg; // Добавляем 100 грамм

                                                if (await BasketProvider().addProductInBasket(
                                                    state.productDetailsModel.data.uuid, state.productDetailsModel.data.quantityInClientCart)) {
                                                  _basketListBloc.add(BasketLoadEvent());
                                                }
                                              }
                                            }
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                                        alignment: Alignment.center,
                                        child: Text("toBasketText".tr(),
                                            style: GoogleFonts.raleway(fontSize: heightRatio(size: 18, context: context), color: Colors.white)),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                                          gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [firstColorButtonsOrangeGradient, secondColorButtonsOrangeGradient]),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.only(bottom: heightRatio(size: 15, context: context), top: heightRatio(size: 12, context: context)),
                                      alignment: Alignment.center,
                                      child: SafeArea(
                                        bottom: true,
                                        top: false,
                                        left: false,
                                        right: false,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    //Убавить из детального экрана
                                                    onTap: () async {
                                                      if (state.productDetailsModel.data.assortmentUnitId != 'kilogram') {
                                                        if (state.productDetailsModel.data.quantityInClientCart > 0) {
                                                          setState(() {
                                                            state.productDetailsModel.data.quantityInClientCart--;
                                                          });
                                                          if (state.productDetailsModel.data.quantityInClientCart <= 0) {
                                                            setState(() {
                                                              isInBasket = false;
                                                            });
                                                            if (await BasketProvider().reomoveProductFromBasket(state.productDetailsModel.data.uuid)) {
                                                              _basketListBloc.add(BasketLoadEvent());
                                                            }
                                                          } else {
                                                            if (await BasketProvider().updateProductInBasket(
                                                              productUuid: state.productDetailsModel.data.uuid,
                                                              quantity: state.productDetailsModel.data.quantityInClientCart,
                                                            )) {
                                                              _basketListBloc.add(BasketLoadEvent());
                                                            }
                                                          }
                                                        }
                                                      } else {
                                                        double weight = double.tryParse(state.productDetailsModel.data.weight) ?? 0.0;
                                                        double weightInKg = weight / 1000;
                                                        if (state.productDetailsModel.data.quantityInClientCart > 0) {
                                                          setState(() {
                                                            state.productDetailsModel.data.quantityInClientCart -= weightInKg; // Уменьшаем на 100 грамм
                                                          });
                                                          if (state.productDetailsModel.data.quantityInClientCart <= 0) {
                                                            setState(() {
                                                              isInBasket = false;
                                                            });
                                                            if (await BasketProvider().reomoveProductFromBasket(state.productDetailsModel.data.uuid)) {
                                                              _basketListBloc.add(BasketLoadEvent());
                                                            }
                                                          } else {
                                                            if (await BasketProvider().updateProductInBasket(
                                                              productUuid: state.productDetailsModel.data.uuid,
                                                              quantity: state.productDetailsModel.data.quantityInClientCart,
                                                            )) {
                                                              _basketListBloc.add(BasketLoadEvent());
                                                            }
                                                          }
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
                                                        child: Icon(Icons.remove, color: Colors.white)),
                                                  ),
                                                  SizedBox(width: widthRatio(size: 10, context: context)),
                                                  Text(
                                                    state.productDetailsModel.data.assortmentUnitId == 'kilogram'
                                                        ? state.productDetailsModel.data.quantityInClientCart > 0.5
                                                            ? "${state.productDetailsModel.data.quantityInClientCart.toStringAsFixed(1)}${"kgText".tr()}"
                                                            : "${(state.productDetailsModel.data.quantityInClientCart * 1000).toStringAsFixed(0)}${"grText".tr()}"
                                                        : "${state.productDetailsModel.data.quantityInClientCart.toInt()}${getAssortmentUnitId(assortmentUnitId: state.productDetailsModel.data.assortmentUnitId)[1]}",
                                                    style: TextStyle(
                                                        color: Colors.white, fontWeight: FontWeight.w600, fontSize: heightRatio(size: 18, context: context)),
                                                  ),
                                                  SizedBox(width: widthRatio(size: 10, context: context)),
                                                  InkWell(
                                                    //добавить из детального экрана
                                                    onTap: () async {
                                                      if (state.productDetailsModel.data.assortmentUnitId == 'kilogram') {
                                                        double weight = double.tryParse(state.productDetailsModel.data.weight) ?? 0.0;
                                                        double weightInKg = weight / 1000;
                                                        setState(() {
                                                          if (state.productDetailsModel.data.quantityInClientCart <
                                                              state.productDetailsModel.data.productsQuantity) {
                                                            state.productDetailsModel.data.quantityInClientCart += weightInKg; // Увеличиваем на 100 грамм
                                                          }
                                                        });
                                                        if (state.productDetailsModel.data.quantityInClientCart <=
                                                            state.productDetailsModel.data.productsQuantity) {
                                                          if (await BasketProvider().updateProductInBasket(
                                                            productUuid: state.productDetailsModel.data.uuid,
                                                            quantity: state.productDetailsModel.data.quantityInClientCart,
                                                          )) {
                                                            _basketListBloc.add(BasketLoadEvent());
                                                          }
                                                        }
                                                      } else {
                                                        setState(() {
                                                          if (state.productDetailsModel.data.quantityInClientCart !=
                                                              state.productDetailsModel.data.productsQuantity) {
                                                            state.productDetailsModel.data.quantityInClientCart++;
                                                          }
                                                        });
                                                        if (state.productDetailsModel.data.quantityInClientCart <=
                                                            state.productDetailsModel.data.productsQuantity) {
                                                          if (await BasketProvider().updateProductInBasket(
                                                            productUuid: state.productDetailsModel.data.uuid,
                                                            quantity: state.productDetailsModel.data.quantityInClientCart,
                                                          )) {
                                                            _basketListBloc.add(BasketLoadEvent());
                                                          }
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            // color: colorBlack03,
                                                            borderRadius: BorderRadius.circular(50)),
                                                        child: Icon(Icons.add, color: Colors.white)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              color: Colors.white,
                                              width: 0.5,
                                              height: 20,
                                            ),
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  state.productDetailsModel.data.priceWithDiscount != null
                                                      ? "sumText".tr() +
                                                          ": "
                                                              "${(state.productDetailsModel.data.priceWithDiscount * state.productDetailsModel.data.quantityInClientCart).toStringAsFixed(2)} ${"rubleSignText".tr()}"
                                                      : "sumText".tr() +
                                                          ": "
                                                              "${(double.parse(state.productDetailsModel.data.currentPrice) * state.productDetailsModel.data.quantityInClientCart).toStringAsFixed(2)} ${"rubleSignText".tr()}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white, fontWeight: FontWeight.w600, fontSize: heightRatio(size: 18, context: context)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [firstColorButtonsOrangeGradient, secondColorButtonsOrangeGradient]),
                                      ),
                                    ),
                            )
                          : SizedBox(),
                    ],
                  ),
                );
              });
            }
            return Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Text('errorText'.tr()),
            );
          }),
        );
      }),
    );
  }
}
