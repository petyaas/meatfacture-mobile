import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/bloc_files/Basic_page_bloc.dart';
import 'package:smart/bloc_files/favorite_product_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/custom_widgets/assortment_filter_button.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/features/main/main_page.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/models/assortments_list_model.dart';
import 'package:smart/models/favorite_product_variant_uuid_model.dart';
import 'package:smart/pages/redesigned_pages/redes_product_details_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/theme/app_alert.dart';
import 'package:smart/utils/custom_cache_manager.dart';

// карточка товара которая отображается внутри категорий и в блоке я в магазине на главной иногда
// ignore: must_be_immutable
class CatalogProductWidget extends StatefulWidget {
  final AssortmentsListModel assortmentsListModel;
  final bool isFavoriteProdiuctPicking;
  final bool isSearchPage;
  final bool isFinalLevel;
  final int index;
  bool isRecomendations = false;
  final String categoryName;
  final bool isFromFavCatalogsList;

  CatalogProductWidget({
    @required this.assortmentsListModel,
    this.isSearchPage = false,
    this.isFinalLevel = false,
    this.isFavoriteProdiuctPicking,
    @required this.isRecomendations,
    this.index,
    this.categoryName = '',
    this.isFromFavCatalogsList = false,
  });

  @override
  State<CatalogProductWidget> createState() => _CatalogProductWidgetState();
}

class _CatalogProductWidgetState extends State<CatalogProductWidget> {
  double kgToAddToBasket = 0;
  double quantityInCartToBack;
  double priceWithDiscountInCartToBack;
  String currentPriceInCartToBack;
  String discountTypeColorInCartToBack;

  @override
  Widget build(BuildContext context) {
    FavoriteProductBloc _favoriteProductbloc = BlocProvider.of(context);
    SecondaryPageBloc _secondaryPageBloc = BlocProvider.of(context);
    BasketListBloc _basketListBloc = BlocProvider.of<BasketListBloc>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    print("Ширина экрана:::::::::::::::::::::::::::::::::::: $screenWidth");

    return widget.assortmentsListModel.isEmpty
        ? SizedBox(height: heightRatio(size: 165, context: context))
        : BlocBuilder<BasketListBloc, BasketState>(
            builder: (context, basketState) {
              if (basketState is BasketLoadedState && _secondaryPageBloc.state is SecondaryBasketPageState) {
                for (var i = 0; i < basketState.basketListModel.data.length; i++) {
                  if (widget.assortmentsListModel.uuid == basketState.basketListModel.data[i].assortment.uuid) {
                    widget.assortmentsListModel.quantityInClientCart = basketState.basketListModel.data[i].quantity;
                    break;
                  } else {
                    widget.assortmentsListModel.quantityInClientCart = 0;
                  }
                }
              } else {
                if (basketState is BasketEmptyState && _secondaryPageBloc.state is SecondaryBasketPageState) {
                  widget.assortmentsListModel.quantityInClientCart = 0;
                }
              }
              return
                  // Stack(
                  //   children: [
                  //   Padding(
                  // padding: EdgeInsets.only(top: heightRatio(size: widget.isSearchPage || widget.isFinalLevel ? 0 : 39, context: context)),
                  // child:
                  InkWell(
                onTap: () async {
                  List resulte = await Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => RedesProductDetailsPage(productUuid: widget.assortmentsListModel.uuid),
                    ),
                  );
                  if (resulte != null) {
                    SchedulerBinding.instance.addPostFrameCallback(
                      (_) {
                        setState(
                          () {
                            widget.assortmentsListModel.quantityInClientCart = resulte[0];
                            widget.assortmentsListModel.priceWithDiscount = resulte[1];
                            widget.assortmentsListModel.currentPrice = resulte[2];
                            widget.assortmentsListModel.discountTypeColor = resulte[3];
                            widget.assortmentsListModel.isFavorite = resulte[4];
                          },
                        );
                      },
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: widthRatio(size: 2.5, context: context),
                    vertical: heightRatio(size: 2.5, context: context),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(heightRatio(size: 14, context: context)),
                  ),
                  child: Column(
                    // карточка товара которая отображается внутри категорий и в блоке я в магазине на главной иногда
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: heightRatio(size: 165, context: context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
                              color: widget.assortmentsListModel.images.isNotEmpty ? Colors.transparent : newGrey2,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
                              child: widget.assortmentsListModel.images.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: widget.assortmentsListModel.images[0].thumbnails.the1000X1000,
                                      cacheManager: CustomCacheManager(),
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) => Image.asset("assets/images/notImage.png", fit: BoxFit.contain),
                                      useOldImageOnUrlChange: true,
                                    )
                                  : Image.asset("assets/images/notImage.png", fit: BoxFit.contain),
                            ),
                          ),

                          //разнообразное питание:
                          widget.assortmentsListModel.discountType == "App\\Models\\PromoDiverseFoodClientDiscount"
                              ? Positioned(
                                  left: widthRatio(size: 7, context: context),
                                  bottom: heightRatio(size: 25, context: context),
                                  child: InkWell(
                                    onTap: () {
                                      AppAlert.show(
                                        context: context,
                                        message:
                                            "Разнообразное питание - это акция, которая позволит получить скидку на все покупки в магазинах в течении месяца.",
                                        sec: 10,
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      "assets/images/newEat.svg",
                                      height: heightRatio(size: 25, context: context),
                                      width: widthRatio(size: 23, context: context),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          //Любимый продукт:
                          widget.assortmentsListModel.discountType == "App\\Models\\ClientActivePromoFavoriteAssortment"
                              ? Positioned(
                                  right: widthRatio(size: 7, context: context),
                                  bottom: heightRatio(size: 25, context: context),
                                  child: InkWell(
                                    onTap: () {
                                      AppAlert.show(
                                        context: context,
                                        message: "Этот товар был отмечен как “Любимый продукт”",
                                        sec: 3,
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      "assets/images/newLovely.svg",
                                      height: heightRatio(size: 24, context: context),
                                      width: widthRatio(size: 24, context: context),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          Positioned(
                            right: widthRatio(size: 8, context: context),
                            top: heightRatio(size: 8, context: context),
                            // Добавить в избранное (снаружи) из каталога и из я в магазине и из избранных
                            child: InkWell(
                              onTap: () async {
                                if (await AssortmentFilterButton().loadToken() != "guest") {
                                  if (widget.assortmentsListModel.isFavorite) {
                                    setState(() => widget.assortmentsListModel.isFavorite = false);
                                  } else {
                                    setState(() => widget.assortmentsListModel.isFavorite = true);
                                  }

                                  var _likeResponse = await AddDeleteProductToFavoriteProvider(
                                          isLiked: !widget.assortmentsListModel.isFavorite, productUuid: widget.assortmentsListModel.uuid)
                                      .getisAddProductTofavoriteResponse();
                                  if (_likeResponse == "old token") {
                                    AuthPageBloc authPageBloc = BlocProvider.of(context);
                                    // BasicPageBloc basicPageBloc = BlocProvider.of(context);
                                    // ProfilePage.logout(regBloc: authPageBloc, basicPageBloc: basicPageBloc);
                                    BlocProvider.of<BasicPageBloc>(context)
                                        ?.add(ProfilePage.logout(regBloc: authPageBloc, basicPageBloc: BlocProvider.of(context)));
                                  }
                                } else {
                                  AssortmentFilterButton().loginOrRegWarning(context);
                                }
                              },
                              child: SvgPicture.asset(
                                  (widget.assortmentsListModel.isFavorite != null && widget.assortmentsListModel.isFavorite)
                                      ? "assets/images/newHeart.svg"
                                      : "assets/images/newHeartContur.svg",
                                  width: 18,
                                  height: 16),
                            ),
                          ),
                          if (widget.assortmentsListModel.rating != null) //рейтинг
                            Positioned(
                              bottom: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(5)),
                                  color: whiteColor,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/newStar.svg",
                                      height: heightRatio(size: 12, context: context),
                                      width: widthRatio(size: 12, context: context),
                                    ),
                                    SizedBox(width: widthRatio(size: 3, context: context)),
                                    Text(
                                      widget.assortmentsListModel.rating != null ? widget.assortmentsListModel.rating.toString() : '',
                                      style: appHeadersTextStyle(fontSize: 11, color: newGrey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          //- скидка %
                          if (widget.assortmentsListModel.priceWithDiscount != null &&
                              widget.assortmentsListModel.currentPrice != null &&
                              widget.assortmentsListModel.priceWithDiscount != widget.assortmentsListModel.currentPrice.toDouble())
                            Positioned(
                              top: heightRatio(size: heightRatio(size: 7, context: context), context: context),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: widthRatio(size: 8, context: context),
                                  vertical: heightRatio(size: 3, context: context),
                                ),
                                decoration: BoxDecoration(color: newYellow, borderRadius: BorderRadius.circular(2)),
                                child: Text(
                                  // ( (Исходная цена − Цена со скидкой) / Исходная цена) * 100
                                  '-' +
                                      (((widget.assortmentsListModel.currentPrice.toDouble() -
                                                      widget.assortmentsListModel.priceWithDiscount) /
                                                  widget.assortmentsListModel.currentPrice.toDouble()) *
                                              100)
                                          .toInt()
                                          .toString() +
                                      '%',
                                  style: appLabelTextStyle(fontSize: 11, color: whiteColor),
                                ),
                              ),
                            ),
                          if (widget.assortmentsListModel.quantityInClientCart != null &&
                              widget.assortmentsListModel.quantityInClientCart > 0 &&
                              (widget.isFavoriteProdiuctPicking == null || !widget.isFavoriteProdiuctPicking))
                            Positioned.fill(
                              //если в корзине уже есть то отображается кол-во
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: colorBlack05,
                                  borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('В корзине', style: appLabelTextStyle(color: whiteColor, fontSize: 15)),
                                    SizedBox(height: heightRatio(size: 6, context: context)),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            style:
                                                appHeadersTextStyle(color: whiteColor, fontSize: heightRatio(size: 16, context: context)),
                                            text: widget.assortmentsListModel.priceWithDiscount == null
                                                ? (double.parse(widget.assortmentsListModel.currentPrice) % 1 == 0
                                                    ? (double.parse(widget.assortmentsListModel.currentPrice) *
                                                            widget.assortmentsListModel.quantityInClientCart)
                                                        .toStringAsFixed(0)
                                                    : (double.parse(widget.assortmentsListModel.currentPrice) *
                                                            widget.assortmentsListModel.quantityInClientCart)
                                                        .toStringAsFixed(2))
                                                : (widget.assortmentsListModel.priceWithDiscount % 1 == 0
                                                    ? (widget.assortmentsListModel.priceWithDiscount *
                                                            widget.assortmentsListModel.quantityInClientCart)
                                                        .toStringAsFixed(0)
                                                    : (widget.assortmentsListModel.priceWithDiscount *
                                                            widget.assortmentsListModel.quantityInClientCart)
                                                        .toStringAsFixed(2)),
                                          ),
                                          TextSpan(
                                            text: " ${"rubleSignText".tr()}",
                                            style: appTextStyle(
                                              color: whiteColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: heightRatio(size: 15, context: context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: heightRatio(size: 4, context: context)),

                      // Наименование товара:
                      SizedBox(
                        height: heightRatio(size: 27, context: context),
                        child: Text(
                          widget.assortmentsListModel.name != null ? '${widget.assortmentsListModel.name}' : "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newBlack),
                        ),
                      ),

                      SizedBox(height: heightRatio(size: 3, context: context)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Квант:
                          widget.assortmentsListModel.assortmentUnitId == "kilogram"
                              ? Text(
                                  '${(widget.assortmentsListModel.weight.toDouble() % 1000 == 0) ? (widget.assortmentsListModel.weight.toDouble() ~/ 1000) : (widget.assortmentsListModel.weight.toDouble() / 1000).toStringAsFixed(1)} кг',
                                  style: appHeadersTextStyle(fontSize: heightRatio(size: 10, context: context), color: grey6D6D6D),
                                )
                              : Text(
                                  '${(widget.assortmentsListModel.weight == "0" ? 1 : widget.assortmentsListModel.weight)} ${getAssortmentUnitId(assortmentUnitId: widget.assortmentsListModel.assortmentUnitId)[1]}',
                                  style: appHeadersTextStyle(fontSize: heightRatio(size: 10, context: context), color: grey6D6D6D),
                                ),

                          // Цена за кг:
                          Text(
                            widget.assortmentsListModel.priceWithDiscount == null
                                ? '${(double.parse(widget.assortmentsListModel.currentPrice) % 1 == 0 ? double.parse(widget.assortmentsListModel.currentPrice).toStringAsFixed(0) : double.parse(widget.assortmentsListModel.currentPrice).toStringAsFixed(2))} руб/кг'
                                : '${(widget.assortmentsListModel.priceWithDiscount % 1 == 0 ? widget.assortmentsListModel.priceWithDiscount.toStringAsFixed(0) : widget.assortmentsListModel.priceWithDiscount.toStringAsFixed(2))} руб/кг',
                            style: appHeadersTextStyle(fontSize: heightRatio(size: 10, context: context), color: grey6D6D6D),
                          ),
                        ],
                      ),

                      SizedBox(height: heightRatio(size: 10, context: context)),

                      if (widget.isFavoriteProdiuctPicking != null && widget.isFavoriteProdiuctPicking)
                        InkWell(
                          onTap: () async {
                            if (!widget.assortmentsListModel.isPromoFavorite) {
                              String _isSettedFavoriteProduct;
                              Fluttertoast.showToast(msg: "Подождите...");
                              FavoriteProductVariantUuidModel _favoriteProductVariantUuidModel =
                                  await FavoriteProductProvider().getFavoriteProductVariantUuidResponse();
                              if (_favoriteProductVariantUuidModel.data.isEmpty) {
                                Fluttertoast.showToast(msg: "Ошибка. Условия акции не выполнены!");
                              } else {
                                _isSettedFavoriteProduct = await FavoriteProductProvider().setFavoriteProductResponse(
                                    assortmentUuid: widget.assortmentsListModel.uuid,
                                    variantUuid: _favoriteProductVariantUuidModel.data.first.uuid);
                                if (_isSettedFavoriteProduct == "ok") {
                                  Timer(Duration(seconds: 1), () {
                                    _favoriteProductbloc.add(FavoriteProductLoadEvent());
                                    setState(() {
                                      widget.assortmentsListModel.isPromoFavorite = true;
                                    });
                                    Navigator.of(context).pushNamedAndRemoveUntil('', (Route<dynamic> route) => false);
                                  });
                                } else if (_isSettedFavoriteProduct == "alreadyActivated") {
                                  Fluttertoast.showToast(
                                    msg: "Вы уже изменили Любимый Продукт, снова поменять его можно будет завтра",
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Ошибка. Условия акции не выполнены!",
                                  );
                                }
                              }
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: widthRatio(size: 5, context: context),
                              vertical: heightRatio(size: 5, context: context),
                            ),
                            decoration: BoxDecoration(
                              color: widget.assortmentsListModel.isPromoFavorite ? colorBlack03 : mainColor,
                              borderRadius: BorderRadius.circular(widthRatio(size: 7, context: context)),
                            ),
                            child: Text(
                              widget.assortmentsListModel.isPromoFavorite ? "selectedText".tr() : "toChooseText".tr(),
                              style: appTextStyle(
                                fontSize: heightRatio(size: 10, context: context),
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        )
                      else
                        widget.isFromFavCatalogsList
                            ? InkWell(
                                onTap: () async {
                                  if (!widget.assortmentsListModel.isPromoFavorite) {
                                    String _isSettedFavoriteProduct;
                                    Fluttertoast.showToast(msg: "Подождите...");
                                    FavoriteProductVariantUuidModel _favoriteProductVariantUuidModel =
                                        await FavoriteProductProvider().getFavoriteProductVariantUuidResponse();
                                    log("assortmentUuid: ${widget.assortmentsListModel.uuid}");
                                    log("variantUuid: ${_favoriteProductVariantUuidModel.data.first.uuid}");
                                    if (_favoriteProductVariantUuidModel.data.isEmpty) {
                                      Fluttertoast.showToast(msg: "Ошибка. Условия акции не выполнены!");
                                    } else {
                                      _isSettedFavoriteProduct = await FavoriteProductProvider().setFavoriteProductResponse(
                                          assortmentUuid: widget.assortmentsListModel.uuid,
                                          variantUuid: _favoriteProductVariantUuidModel.data.first.uuid);
                                      if (_isSettedFavoriteProduct == "ok") {
                                        Timer(Duration(seconds: 1), () {
                                          _favoriteProductbloc.add(FavoriteProductLoadEvent());
                                          setState(() {
                                            widget.assortmentsListModel.isPromoFavorite = true;
                                          });
                                          log("Navigator.of(context).pop()");
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        });
                                      } else if (_isSettedFavoriteProduct == "alreadyActivated") {
                                        Fluttertoast.showToast(
                                          msg: "Вы уже изменили Любимый Продукт, снова поменять его можно будет завтра",
                                        );
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "Ошибка. Условия акции не выполнены!",
                                        );
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: widget.assortmentsListModel.discountTypeColor == null
                                        ? newRedDark
                                        : Color(int.parse("0xff${widget.assortmentsListModel.discountTypeColor}")),
                                    borderRadius: BorderRadius.circular(heightRatio(size: 4, context: context)),
                                  ),
                                  child: Text(
                                    widget.assortmentsListModel.isPromoFavorite ? 'Выбран любимым' : 'Выбрать любимым',
                                    style: appHeadersTextStyle(color: whiteColor, fontSize: heightRatio(size: 12, context: context)),
                                  ),
                                ),
                              )
                            : widget.assortmentsListModel.quantityInClientCart == null ||
                                    widget.assortmentsListModel.quantityInClientCart <= 0
                                ? InkWell(
                                    // Добавить из каталога
                                    onTap: () async {
                                      print('ДОБАВИТЬЬЬЬ');
                                      if (await loadToken() != "guest") {
                                        setState(() => widget.assortmentsListModel.isbasketAdding = true);
                                        if (widget.assortmentsListModel.assortmentUnitId != "kilogram") {
                                          if (widget.assortmentsListModel.quantityInClientCart <
                                              widget.assortmentsListModel.productsQuantity) {
                                            widget.assortmentsListModel.quantityInClientCart++;
                                            if (await BasketProvider().updateProductInBasket(
                                                productUuid: widget.assortmentsListModel.uuid,
                                                quantity: widget.assortmentsListModel.assortmentUnitId != "kilogram"
                                                    ? widget.assortmentsListModel.quantityInClientCart
                                                    : widget.assortmentsListModel.quantityInClientCart)) {
                                              _basketListBloc.add(BasketLoadEvent());
                                            }
                                          }
                                        } else {
                                          double weight = double.tryParse(widget.assortmentsListModel.weight) ?? 0.0;
                                          double weightInKg = weight / 1000;
                                          if (widget.assortmentsListModel.quantityInClientCart <
                                              widget.assortmentsListModel.productsQuantity) {
                                            setState(() {
                                              widget.assortmentsListModel.quantityInClientCart += weightInKg;
                                            });
                                            if (await BasketProvider().updateProductInBasket(
                                                productUuid: widget.assortmentsListModel.uuid,
                                                quantity: widget.assortmentsListModel.quantityInClientCart)) {
                                              isToFreeFirst = false;
                                              _basketListBloc.add(BasketLoadEvent());
                                            }
                                          }

                                          // если потребуется с всплывашкой добавлять весовой товар то возвращаем то что тут закомментила:
                                          // List weightResult = await showModalBottomSheet(
                                          //   isScrollControlled: true, useSafeArea: true,
                                          //   context: context,
                                          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                                          //   builder: (BuildContext bc) {
                                          //     return SetWeigtForProductInBasketBottomSheet(
                                          //       isupdate: false,
                                          //       gr: (widget.assortmentsListModel.quantityInClientCart % 1 * 100).toInt(),
                                          //       kg: widget.assortmentsListModel.quantityInClientCart ~/ 1,
                                          //       productUuid: widget.assortmentsListModel.uuid,
                                          //     );
                                          //   },
                                          // );
                                          // if (weightResult != null && weightResult[2]) {
                                          //   kgToAddToBasket = double.parse(weightResult[0].isEmpty ? "0" : weightResult[0]) + (double.parse(weightResult[1].isEmpty ? "0" : weightResult[1]) / 1000);
                                          //   if (widget.assortmentsListModel.quantityInClientCart < widget.assortmentsListModel.productsQuantity) {
                                          //     widget.assortmentsListModel.quantityInClientCart = kgToAddToBasket;
                                          //   }
                                          //   widget.assortmentsListModel.isbasketAdding = true;
                                          //   quantityInCartToBack = kgToAddToBasket;
                                          // } else {
                                          //   if (weightResult != null) {
                                          //     setState(
                                          //       () {
                                          //         widget.assortmentsListModel.quantityInClientCart = 0;
                                          //         widget.assortmentsListModel.isbasketAdding = false;
                                          //       },
                                          //     );
                                          //   }
                                          // }
                                        }
                                      } else {
                                        AssortmentFilterButton().loginOrRegWarning(context);
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: widget.assortmentsListModel.discountTypeColor == null
                                            ? newRedDark
                                            : Color(int.parse("0xff${widget.assortmentsListModel.discountTypeColor}")),
                                        borderRadius: BorderRadius.circular(heightRatio(size: 4, context: context)),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              style:
                                                  appHeadersTextStyle(color: whiteColor, fontSize: heightRatio(size: 12, context: context)),
                                              text: ((widget.assortmentsListModel.priceWithDiscount ??
                                                                  double.parse(widget.assortmentsListModel.currentPrice)) *
                                                              (widget.assortmentsListModel.assortmentUnitId == "kilogram"
                                                                  ? (double.tryParse(widget.assortmentsListModel.weight.toString()) ?? 0) /
                                                                      1000
                                                                  : (widget.assortmentsListModel.weight == "0"
                                                                      ? 1
                                                                      : int.parse(widget.assortmentsListModel.weight)))) %
                                                          1 ==
                                                      0
                                                  ? ((widget.assortmentsListModel.priceWithDiscount ??
                                                              double.parse(widget.assortmentsListModel.currentPrice)) *
                                                          (widget.assortmentsListModel.assortmentUnitId == "kilogram"
                                                              ? (double.tryParse(widget.assortmentsListModel.weight.toString()) ?? 0) / 1000
                                                              : (widget.assortmentsListModel.weight == "0"
                                                                  ? 1
                                                                  : int.parse(widget.assortmentsListModel.weight))))
                                                      .toStringAsFixed(0)
                                                  : ((widget.assortmentsListModel.priceWithDiscount ??
                                                              double.parse(widget.assortmentsListModel.currentPrice)) *
                                                          (widget.assortmentsListModel.assortmentUnitId == "kilogram"
                                                              ? (double.tryParse(widget.assortmentsListModel.weight.toString()) ?? 0) / 1000
                                                              : (widget.assortmentsListModel.weight == "0"
                                                                  ? 1
                                                                  : int.parse(widget.assortmentsListModel.weight))))
                                                      .toStringAsFixed(2),
                                            ),
                                            TextSpan(
                                              text: " ${"rubleSignText".tr()}",
                                              style: appTextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: heightRatio(size: 12, context: context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    // - +
                                    alignment: Alignment.center,
                                    height: heightRatio(size: 30, context: context),
                                    decoration: BoxDecoration(
                                      color: newRedDark,
                                      borderRadius: BorderRadius.circular(heightRatio(size: 4, context: context)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          //Убавить из каталога
                                          padding: EdgeInsets.all(0),
                                          onPressed: () async {
                                            if (widget.assortmentsListModel.assortmentUnitId != "kilogram") {
                                              setState(() {
                                                widget.assortmentsListModel.quantityInClientCart -= 1;
                                              });
                                              if (widget.assortmentsListModel.quantityInClientCart != null &&
                                                  widget.assortmentsListModel.quantityInClientCart <= 0) {
                                                if (await BasketProvider().reomoveProductFromBasket(widget.assortmentsListModel.uuid)) {
                                                  _basketListBloc.add(BasketLoadEvent());
                                                }
                                              }
                                              if (await BasketProvider().updateProductInBasket(
                                                  productUuid: widget.assortmentsListModel.uuid,
                                                  quantity: widget.assortmentsListModel.quantityInClientCart)) {
                                                _basketListBloc.add(BasketLoadEvent());
                                              }
                                            } else {
                                              double weight = double.tryParse(widget.assortmentsListModel.weight) ?? 0.0;
                                              double weightInKg = weight / 1000;
                                              setState(() {
                                                widget.assortmentsListModel.quantityInClientCart -= weightInKg; // Уменьшение по 100 грамм
                                              });
                                              if (widget.assortmentsListModel.quantityInClientCart <= 0) {
                                                if (await BasketProvider().reomoveProductFromBasket(widget.assortmentsListModel.uuid)) {
                                                  _basketListBloc.add(BasketLoadEvent());
                                                }
                                              } else if (await BasketProvider().updateProductInBasket(
                                                  productUuid: widget.assortmentsListModel.uuid,
                                                  quantity: widget.assortmentsListModel.quantityInClientCart)) {
                                                _basketListBloc.add(BasketLoadEvent());
                                              }
                                              // тут тоже если нужно вернуть нужно просто расскоментить:
                                              // List weightResult = await showModalBottomSheet(
                                              //     isScrollControlled: true, useSafeArea: true,
                                              //     context: context,
                                              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                                              //     builder: (BuildContext bc) {
                                              //       return SetWeigtForProductInBasketBottomSheet(
                                              //         isupdate: true,
                                              //         gr: (widget.assortmentsListModel.quantityInClientCart % 1 * 1000).toInt(),
                                              //         kg: widget.assortmentsListModel.quantityInClientCart ~/ 1,
                                              //         productUuid: widget.assortmentsListModel.uuid,
                                              //       );
                                              //     });
                                              // if (weightResult != null && weightResult[2]) {
                                              //   kgToAddToBasket = double.parse(weightResult[0].isEmpty ? "0" : weightResult[0]) + (double.parse(weightResult[1].isEmpty ? "0" : weightResult[1]) / 1000);
                                              //   if (widget.assortmentsListModel.quantityInClientCart < widget.assortmentsListModel.productsQuantity) {
                                              //     widget.assortmentsListModel.quantityInClientCart = kgToAddToBasket;
                                              //   }
                                              //   widget.assortmentsListModel.isbasketAdding = true;
                                              //   quantityInCartToBack = kgToAddToBasket;
                                              // } else {
                                              //   if (weightResult != null) {
                                              //     setState(() {
                                              //       widget.assortmentsListModel.quantityInClientCart = 0;
                                              //       widget.assortmentsListModel.isbasketAdding = false;
                                              //     });
                                              //   }
                                              // }
                                            }
                                          },
                                          icon: SvgPicture.asset('assets/images/minus.svg', width: 14, height: 1),
                                        ),
                                        Text(
                                          widget.assortmentsListModel.assortmentUnitId == "kilogram"
                                              ? widget.assortmentsListModel.quantityInClientCart > 0.5
                                                  ? (widget.assortmentsListModel.quantityInClientCart % 1 == 0
                                                      ? "${widget.assortmentsListModel.quantityInClientCart.toInt()}${"kgText".tr()}"
                                                      : "${widget.assortmentsListModel.quantityInClientCart.toStringAsFixed(1)}${"kgText".tr()}")
                                                  : "${(widget.assortmentsListModel.quantityInClientCart * 1000).toStringAsFixed(0)}${"grText".tr()}"
                                              : "${widget.assortmentsListModel.quantityInClientCart.toInt().toString()} ${getAssortmentUnitId(assortmentUnitId: widget.assortmentsListModel.assortmentUnitId)[1]}",
                                          style: appHeadersTextStyle(color: whiteColor, fontSize: heightRatio(size: 12, context: context)),
                                        ),
                                        IconButton(
                                          //Добавить из каталога
                                          padding: EdgeInsets.all(0),
                                          onPressed: () async {
                                            if (widget.assortmentsListModel.assortmentUnitId != "kilogram") {
                                              if (widget.assortmentsListModel.productsQuantity >=
                                                  widget.assortmentsListModel.quantityInClientCart + 1) {
                                                setState(() {
                                                  widget.assortmentsListModel.quantityInClientCart += 1;
                                                });
                                                if (await BasketProvider().updateProductInBasket(
                                                    productUuid: widget.assortmentsListModel.uuid,
                                                    quantity: widget.assortmentsListModel.assortmentUnitId != "kilogram"
                                                        ? widget.assortmentsListModel.quantityInClientCart
                                                        : widget.assortmentsListModel.quantityInClientCart)) {
                                                  _basketListBloc.add(BasketLoadEvent());
                                                }
                                              }
                                            } else {
                                              double weight = double.tryParse(widget.assortmentsListModel.weight) ?? 0.0;
                                              double weightInKg = weight / 1000;
                                              if (widget.assortmentsListModel.productsQuantity >=
                                                  widget.assortmentsListModel.quantityInClientCart + 0.1) {
                                                setState(() {
                                                  widget.assortmentsListModel.quantityInClientCart += weightInKg; // Добавление по 100 грамм
                                                });
                                                if (await BasketProvider().updateProductInBasket(
                                                    productUuid: widget.assortmentsListModel.uuid,
                                                    quantity: widget.assortmentsListModel.quantityInClientCart)) {
                                                  _basketListBloc.add(BasketLoadEvent());
                                                }
                                              }
                                              // если нужно вернуть:
                                              // List weightResult = await showModalBottomSheet(
                                              //     isScrollControlled: true, useSafeArea: true,
                                              //     context: context,
                                              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                                              //     builder: (BuildContext bc) {
                                              //       return SetWeigtForProductInBasketBottomSheet(
                                              //         isupdate: true,
                                              //         gr: (widget.assortmentsListModel.quantityInClientCart % 1 * 1000).toInt(),
                                              //         kg: widget.assortmentsListModel.quantityInClientCart ~/ 1,
                                              //         productUuid: widget.assortmentsListModel.uuid,
                                              //       );
                                              //     });
                                              // if (weightResult != null && weightResult[2]) {
                                              //   kgToAddToBasket = double.parse(weightResult[0].isEmpty ? "0" : weightResult[0]) + (double.parse(weightResult[1].isEmpty ? "0" : weightResult[1]) / 1000);
                                              //   if (widget.assortmentsListModel.quantityInClientCart < widget.assortmentsListModel.productsQuantity) {
                                              //     widget.assortmentsListModel.quantityInClientCart = kgToAddToBasket;
                                              //   }
                                              //   widget.assortmentsListModel.isbasketAdding = true;
                                              //   quantityInCartToBack = kgToAddToBasket;
                                              // } else {
                                              //   if (weightResult != null) {
                                              //     setState(() {
                                              //       widget.assortmentsListModel.quantityInClientCart = 0;
                                              //       widget.assortmentsListModel.isbasketAdding = false;
                                              //     });
                                              //   }
                                              // }
                                            }
                                          },
                                          icon: SvgPicture.asset('assets/images/plus.svg', width: 12, height: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                      if (widget.assortmentsListModel.totalBonus != null && widget.assortmentsListModel.totalBonus != 0)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: whiteColor, borderRadius: BorderRadius.circular(widthRatio(size: 4, context: context))),
                            padding: EdgeInsets.symmetric(
                                horizontal: widthRatio(size: 4, context: context), vertical: heightRatio(size: 2, context: context)),
                            margin: EdgeInsets.all(4),
                            child: Row(
                              children: [
                                Container(
                                  width: widthRatio(size: 15, context: context),
                                  height: heightRatio(size: 15, context: context),
                                  child: SvgPicture.asset('assets/images/bonus_vector.svg',
                                      width: widthRatio(size: 15, context: context), height: heightRatio(size: 15, context: context)),
                                ),
                                SizedBox(width: widthRatio(size: 3, context: context)),
                                Text(
                                  widget.assortmentsListModel.totalBonus.toStringAsFixed(0),
                                  style: appTextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: colorBlack06),
                                )
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              );
            },
          );
  }
}

class CustomMaterialPageRoute extends MaterialPageRoute {
  @protected
  bool get hasScopedWillPopCallback => false;

  CustomMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(builder: builder, settings: settings, maintainState: maintainState, fullscreenDialog: fullscreenDialog);
}
