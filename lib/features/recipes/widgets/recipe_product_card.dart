import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/custom_widgets/assortment_filter_button.dart';
import 'package:smart/pages/redesigned_pages/redes_product_details_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/utils/custom_cache_manager.dart';
import '../models/receipts_list_model.dart' as Recipe;

// это карточка товара которую мы предлагаем

// ignore: must_be_immutable
class RecipeProductCard extends StatefulWidget {
  final Recipe.Assortment assortmentsListModel;
  final bool isFavoriteProdiuctPicking;
  bool isRecomendations = false;

  RecipeProductCard({@required this.assortmentsListModel, this.isFavoriteProdiuctPicking, @required this.isRecomendations});

  @override
  State<RecipeProductCard> createState() => _ReceiptsAssortmentsCard();
}

class _ReceiptsAssortmentsCard extends State<RecipeProductCard> {
  double kgToAddToBasket = 0;
  double quantityInCartToBack;
  double priceWithDiscountInCartToBack;
  String currentPriceInCartToBack;
  String discountTypeColorInCartToBack;

  @override
  Widget build(BuildContext context) {
    SecondaryPageBloc _secondaryPageBloc = BlocProvider.of(context);
    BasketListBloc _basketListBloc = BlocProvider.of<BasketListBloc>(context);

    return BlocBuilder<BasketListBloc, BasketState>(builder: (context, basketState) {
      if (basketState is BasketLoadedState) {
        for (var i = 0; i < basketState.basketListModel.data.length; i++) {
          if (widget.assortmentsListModel.uuid == basketState.basketListModel.data[i].assortment.uuid) {
            widget.assortmentsListModel.quantity = basketState.basketListModel.data[i].quantity;
            break;
          } else {
            widget.assortmentsListModel.quantity = 0;
          }
        }
      } else {
        if (basketState is BasketEmptyState && _secondaryPageBloc.state is SecondaryBasketPageState) {
          widget.assortmentsListModel.quantity = 0;
        }
      }

      double price = double.tryParse(widget.assortmentsListModel.currentPrice) ?? 0.0;
      String priceText;
      if (price % 1 == 0) {
        priceText = price.toInt().toString();
      } else {
        priceText = price.toString();
      }
      // Здесь можно использовать priceText для отображения
      return InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            new CupertinoPageRoute(
              builder: (context) => RedesProductDetailsPage(
                productUuid: widget.assortmentsListModel.uuid,
              ),
            ),
          );
          // if (resulte != null) {
          //   SchedulerBinding.instance.addPostFrameCallback((_) {
          //     setState(() {
          //       widget.assortmentsListModel.quantity = resulte[0];
          //       widget.assortmentsListModel.priceWithDiscount = resulte[1];
          //       widget.assortmentsListModel.currentPrice = resulte[2];
          //       widget.assortmentsListModel.discountTypeColor = resulte[3];
          //     });
          //   });
          // }
        },
        child: Container(
          padding: EdgeInsets.only(top: 9, left: 9, right: 9, bottom: 9),
          margin: EdgeInsets.only(
              right: widthRatio(size: 4, context: context), top: heightRatio(size: 2.5, context: context), bottom: heightRatio(size: 2.5, context: context)),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(heightRatio(size: 14, context: context)),
            boxShadow: [BoxShadow(color: newShadow, offset: Offset(6, 4), blurRadius: 12, spreadRadius: 0)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: heightRatio(size: 30, context: context),
                      child: Text(
                        widget.assortmentsListModel.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newBlack),
                      ),
                    ),
                  ),
                  Container(
                    width: widthRatio(size: 48, context: context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (widget.assortmentsListModel.rating != null) // rating
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset("assets/images/newStar.svg",
                                  height: heightRatio(size: 12, context: context), width: widthRatio(size: 12, context: context)),
                              SizedBox(width: widthRatio(size: 3, context: context)),
                              Text(
                                widget.assortmentsListModel.rating != null ? widget.assortmentsListModel.rating.toString() : '',
                                style: appLabelTextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: newGrey),
                              ),
                            ],
                          ),
                        SizedBox(height: heightRatio(size: 3, context: context)),
                        Text(
                          widget.assortmentsListModel.weight == null || widget.assortmentsListModel.weight == "0"
                              ? ""
                              : double.parse(widget.assortmentsListModel.weight) > 500
                                  ? "${double.parse(widget.assortmentsListModel.weight) / 1000}${"kgText".tr()}"
                                  : "${widget.assortmentsListModel.weight}${"grText".tr()}",
                          style: appLabelTextStyle(fontSize: heightRatio(size: 9, context: context), color: colorBlack04),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: heightRatio(size: 60, context: context),
                    width: widthRatio(size: 60, context: context),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
                      color: widget.assortmentsListModel.images.isNotEmpty ? Colors.transparent : newGrey2,
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
                          child: widget.assortmentsListModel.images.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: widget.assortmentsListModel.images[0].thumbnails.the1000X1000,
                                  cacheManager: CustomCacheManager(),
                                  fit: BoxFit.cover,
                                  height: heightRatio(size: 60, context: context),
                                  width: widthRatio(size: 60, context: context),
                                  errorWidget: (context, url, error) => Image.asset("assets/images/notImage.png", fit: BoxFit.contain),
                                )
                              : Image.asset(
                                  "assets/images/notImage.png",
                                  height: heightRatio(size: 60, context: context),
                                  width: widthRatio(size: 60, context: context),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        widget.assortmentsListModel.quantity != null &&
                                widget.assortmentsListModel.quantity > 0 &&
                                (widget.isFavoriteProdiuctPicking == null || !widget.isFavoriteProdiuctPicking)
                            ? Positioned.fill(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: colorBlack04, borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('В корзине', style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 10, context: context))),
                                      SizedBox(height: heightRatio(size: 4, context: context)),
                                      Text(
                                        widget.assortmentsListModel.assortmentUnitId == "kilogram"
                                            ? widget.assortmentsListModel.quantity > 0.9
                                                ? "${widget.assortmentsListModel.quantity.toStringAsFixed(1)}${"kgText".tr()}"
                                                : "${(widget.assortmentsListModel.quantity * 1000).toStringAsFixed(0)}${"grText".tr()}"
                                            : "${widget.assortmentsListModel.quantity.toInt().toString()} ${getAssortmentUnitId(assortmentUnitId: widget.assortmentsListModel.assortmentUnitId != null ? widget.assortmentsListModel.assortmentUnitId : '')[1]}",
                                        style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 10, context: context)),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: heightRatio(size: 60, context: context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                          decoration: BoxDecoration(color: newRedDark, borderRadius: BorderRadius.circular(heightRatio(size: 3, context: context))),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  style: appHeadersTextStyle(color: whiteColor, fontSize: heightRatio(size: 10, context: context)),
                                  text: widget.assortmentsListModel.currentPrice != null ? priceText : '',
                                ),
                                TextSpan(
                                  text: " ${"rubleSignText".tr()}",
                                  style: appTextStyle(color: whiteColor, fontWeight: FontWeight.w700, fontSize: heightRatio(size: 10, context: context)),
                                ),
                                if (getAssortmentUnitId(assortmentUnitId: widget.assortmentsListModel.assortmentUnitId)[1] != '')
                                  TextSpan(
                                    style: appHeadersTextStyle(color: whiteColor, fontSize: heightRatio(size: 10, context: context)),
                                    text: "/${getAssortmentUnitId(assortmentUnitId: widget.assortmentsListModel.assortmentUnitId)[1]}",
                                  ),
                              ],
                            ),
                          ),
                        ),
                        widget.assortmentsListModel.quantity == null || widget.assortmentsListModel.quantity <= 0
                            ? InkWell(
                                // Добавить из recipe
                                onTap: () async {
                                  if (await loadToken() != "guest") {
                                    if (widget.assortmentsListModel.assortmentUnitId != "kilogram") {
                                      if (widget.assortmentsListModel.quantity < widget.assortmentsListModel.productsQuantity) {
                                        widget.assortmentsListModel.quantity++;
                                        if (await BasketProvider().updateProductInBasket(
                                            productUuid: widget.assortmentsListModel.uuid, quantity: widget.assortmentsListModel.quantity)) {
                                          _basketListBloc.add(BasketLoadEvent());
                                        }
                                      }
                                    } else {
                                      // List weightResult = await showModalBottomSheet(
                                      //     isScrollControlled: true, useSafeArea: true,
                                      //     context: context,
                                      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                                      //     builder: (BuildContext bc) {
                                      //       return SetWeigtForProductInBasketBottomSheet(
                                      //         isupdate: false,
                                      //         gr: (widget.assortmentsListModel.quantity % 1 * 100).toInt(),
                                      //         kg: widget.assortmentsListModel.quantity ~/ 1,
                                      //         productUuid: widget.assortmentsListModel.uuid,
                                      //       );
                                      //     });

                                      // if (weightResult != null && weightResult[2]) {
                                      //   kgToAddToBasket = double.parse(weightResult[0].isEmpty ? "0" : weightResult[0]) + (double.parse(weightResult[1].isEmpty ? "0" : weightResult[1]) / 1000);
                                      //   if (widget.assortmentsListModel.quantity < widget.assortmentsListModel.productsQuantity) {
                                      //     widget.assortmentsListModel.quantity = kgToAddToBasket.toInt();
                                      //   }
                                      //   quantityInCartToBack = kgToAddToBasket;
                                      // } else {
                                      //   if (weightResult != null) {
                                      //     setState(() {
                                      //       widget.assortmentsListModel.quantity = 0;
                                      //     });
                                      //   }
                                      // }
                                      double weight = double.tryParse(widget.assortmentsListModel.weight) ?? 0.0;
                                      double weightInKg = weight / 1000;
                                      if (widget.assortmentsListModel.quantity < widget.assortmentsListModel.productsQuantity) {
                                        setState(() {
                                          widget.assortmentsListModel.quantity += weightInKg; // Добавление по 100 грамм
                                        });
                                        if (await BasketProvider().updateProductInBasket(
                                            productUuid: widget.assortmentsListModel.uuid, quantity: widget.assortmentsListModel.quantity)) {
                                          _basketListBloc.add(BasketLoadEvent());
                                        }
                                      }
                                    }
                                  } else {
                                    AssortmentFilterButton().loginOrRegWarning(context);
                                  }
                                },
                                child: Container(
                                  width: widthRatio(size: 82, context: context),
                                  height: heightRatio(size: 22, context: context),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: newRedDark, borderRadius: BorderRadius.circular(heightRatio(size: 3, context: context))),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("assets/images/newBuy.svg",
                                          height: heightRatio(size: 10, context: context), width: widthRatio(size: 10, context: context)),
                                      SizedBox(width: widthRatio(size: 6, context: context)),
                                      Text('В корзину', style: appLabelTextStyle(color: whiteColor, fontSize: 10)),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                width: widthRatio(size: 82, context: context),
                                height: heightRatio(size: 22, context: context),
                                decoration: BoxDecoration(color: newRedDark, borderRadius: BorderRadius.circular(heightRatio(size: 3, context: context))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: widthRatio(size: 5, context: context)),
                                    GestureDetector(
                                      // Убавить из recipe
                                      onTap: () async {
                                        if (widget.assortmentsListModel.assortmentUnitId != "kilogram") {
                                          setState(() {
                                            widget.assortmentsListModel.quantity -= 1;
                                          });

                                          if (widget.assortmentsListModel.quantity != null && widget.assortmentsListModel.quantity <= 0) {
                                            if (await BasketProvider().reomoveProductFromBasket(widget.assortmentsListModel.uuid)) {
                                              _basketListBloc.add(BasketLoadEvent());
                                            }
                                          } else if (await BasketProvider().updateProductInBasket(
                                              productUuid: widget.assortmentsListModel.uuid, quantity: widget.assortmentsListModel.quantity)) {
                                            _basketListBloc.add(BasketLoadEvent());
                                          }
                                        } else {
                                          double weight = double.tryParse(widget.assortmentsListModel.weight) ?? 0.0;
                                          double weightInKg = weight / 1000;
                                          setState(() {
                                            widget.assortmentsListModel.quantity -= weightInKg; // Уменьшение по 100 грамм
                                          });
                                          if (widget.assortmentsListModel.quantity <= 0) {
                                            if (await BasketProvider().reomoveProductFromBasket(widget.assortmentsListModel.uuid)) {
                                              _basketListBloc.add(BasketLoadEvent());
                                            }
                                          } else if (await BasketProvider().updateProductInBasket(
                                              productUuid: widget.assortmentsListModel.uuid, quantity: widget.assortmentsListModel.quantity)) {
                                            _basketListBloc.add(BasketLoadEvent());
                                          }
                                        }
                                      },
                                      child: Icon(Icons.remove, color: Colors.white, size: 12),
                                    ),
                                    SizedBox(width: widthRatio(size: 5, context: context)),
                                    Text(
                                      widget.assortmentsListModel.assortmentUnitId == "kilogram"
                                          ? widget.assortmentsListModel.quantity > 0.9
                                              ? "${widget.assortmentsListModel.quantity.toStringAsFixed(1)}${"kgText".tr()}"
                                              : "${(widget.assortmentsListModel.quantity * 1000).toStringAsFixed(0)}${"grText".tr()}"
                                          : "${widget.assortmentsListModel.quantity.toInt().toString()} ${getAssortmentUnitId(assortmentUnitId: widget.assortmentsListModel.assortmentUnitId != null ? widget.assortmentsListModel.assortmentUnitId : '')[1]}",
                                      style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 10, context: context)),
                                    ),
                                    SizedBox(width: widthRatio(size: 5, context: context)),
                                    GestureDetector(
                                      //Добавить из recipe
                                      onTap: () async {
                                        if (widget.assortmentsListModel.assortmentUnitId != "kilogram") {
                                          if (widget.assortmentsListModel.productsQuantity >= widget.assortmentsListModel.quantity + 1) {
                                            setState(() {
                                              widget.assortmentsListModel.quantity += 1;
                                            });
                                            if (await BasketProvider().updateProductInBasket(
                                                productUuid: widget.assortmentsListModel.uuid, quantity: widget.assortmentsListModel.quantity)) {
                                              _basketListBloc.add(BasketLoadEvent());
                                            }
                                          }
                                        } else {
                                          double weight = double.tryParse(widget.assortmentsListModel.weight) ?? 0.0;
                                          double weightInKg = weight / 1000;
                                          if (widget.assortmentsListModel.productsQuantity >= widget.assortmentsListModel.quantity + 0.1) {
                                            setState(() {
                                              widget.assortmentsListModel.quantity += weightInKg; // Добавление по 100 грамм
                                            });
                                            if (await BasketProvider().updateProductInBasket(
                                                productUuid: widget.assortmentsListModel.uuid, quantity: widget.assortmentsListModel.quantity)) {
                                              _basketListBloc.add(BasketLoadEvent());
                                            }
                                          }
                                        }
                                      },
                                      child: Icon(Icons.add, color: Colors.white, size: 12),
                                    ),
                                    SizedBox(width: widthRatio(size: 5, context: context)),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
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
