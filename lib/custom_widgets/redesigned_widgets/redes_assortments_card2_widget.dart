import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/models/assortments_list_model.dart';
import 'package:smart/pages/redesigned_pages/redes_product_details_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/utils/custom_cache_manager.dart';

// карточка товара которая отображается внутри категорий и в блоке я в магазине на главной иногда
// ignore: must_be_immutable
class RedesAssortmentsCard2Widget extends StatefulWidget {
  final AssortmentsListModel assortmentsListModel;
  final bool isFavoriteProdiuctPicking;
  final int index;
  bool isRecomendations = false;

  RedesAssortmentsCard2Widget({@required this.assortmentsListModel, this.isFavoriteProdiuctPicking, @required this.isRecomendations, this.index});

  @override
  State<RedesAssortmentsCard2Widget> createState() => _RedesAssortmentsCard2WidgetState();
}

class _RedesAssortmentsCard2WidgetState extends State<RedesAssortmentsCard2Widget> {
  double kgToAddToBasket = 0;
  double quantityInCartToBack;
  double priceWithDiscountInCartToBack;
  String currentPriceInCartToBack;
  String discountTypeColorInCartToBack;

  @override
  Widget build(BuildContext context) {
    SecondaryPageBloc _secondaryPageBloc = BlocProvider.of(context);

    return BlocBuilder<BasketListBloc, BasketState>(builder: (context, basketState) {
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

      return InkWell(
        onTap: () async {
          List resulte = await Navigator.push(
            context,
            new CupertinoPageRoute(
              builder: (context) => RedesProductDetailsPage(
                productUuid: widget.assortmentsListModel.uuid,
              ),
            ),
          );

          if (resulte != null) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              setState(() {
                widget.assortmentsListModel.quantityInClientCart = resulte[0];
                widget.assortmentsListModel.priceWithDiscount = resulte[1];
                widget.assortmentsListModel.currentPrice = resulte[2];
                widget.assortmentsListModel.discountTypeColor = resulte[3];
              });
            });
          }
        },
        child: Container(
          padding: EdgeInsets.only(top: 9, left: 9, right: 9, bottom: 9),
          margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 2.5, context: context), vertical: heightRatio(size: 2.5, context: context)),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(heightRatio(size: 14, context: context)),
            boxShadow: [BoxShadow(color: newShadow, offset: Offset(6, 4), blurRadius: 12, spreadRadius: 0)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Карточка товара рекомендаций
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: heightRatio(size: 30, context: context),
                      child: Text(
                        widget.index != null
                            ? widget.assortmentsListModel.name != null
                                ? '${widget.index}. ${widget.assortmentsListModel.name}' //наименование товара
                                : ''
                            : widget.assortmentsListModel.name != null
                                ? widget.assortmentsListModel.name
                                : '',
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
                        if (widget.assortmentsListModel.rating != null) //рейтинг
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset("assets/images/newStar.svg", height: heightRatio(size: 12, context: context), width: widthRatio(size: 12, context: context)),
                              SizedBox(width: widthRatio(size: 3, context: context)),
                              Text(
                                widget.assortmentsListModel.rating != null ? widget.assortmentsListModel.rating.toString() : '',
                                style: appLabelTextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: newGrey),
                              ),
                            ],
                          ),
                        SizedBox(height: heightRatio(size: 3, context: context)),
                        Text(
                          //quantity
                          widget.assortmentsListModel.weight == "0"
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
                    width: widthRatio(size: 60, context: context),
                    height: heightRatio(size: 60, context: context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
                      color: widget.assortmentsListModel.images.isNotEmpty ? Colors.transparent : newGrey2,
                    ),
                    child: widget.assortmentsListModel.images.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: widget.assortmentsListModel.images[0].thumbnails.the1000X1000,
                            cacheManager: CustomCacheManager(),
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Image.asset("assets/images/notImage.png", fit: BoxFit.contain),
                            useOldImageOnUrlChange: true,
                          )
                        : Image.asset("assets/images/notImage.png", fit: BoxFit.fitWidth),
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
                          decoration: BoxDecoration(
                            // color: widget.assortmentsListModel.discountTypeColor == null ? colorBlack03 : Color(int.parse("0xff${widget.assortmentsListModel.discountTypeColor}")),
                            color: (widget.assortmentsListModel.hasYellowPrice != null) && (widget.assortmentsListModel.hasYellowPrice == true) ? newYellow : newRedDark,
                            borderRadius: BorderRadius.circular(heightRatio(size: 3, context: context)),
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  style: appHeadersTextStyle(color: whiteColor, fontSize: heightRatio(size: 10, context: context)),
                                  text: widget.assortmentsListModel.priceWithDiscount != null ? widget.assortmentsListModel.priceWithDiscount.toString() : widget.assortmentsListModel.currentPrice,
                                ),
                                TextSpan(
                                  text: " ${"rubleSignText".tr()}",
                                  style: appTextStyle(color: whiteColor, fontWeight: FontWeight.w700, fontSize: heightRatio(size: 10, context: context)),
                                ),
                                TextSpan(
                                  style: appHeadersTextStyle(color: whiteColor, fontSize: heightRatio(size: 10, context: context)),
                                  text: widget.assortmentsListModel.assortmentUnitId != 'package' ? "/${getAssortmentUnitId(assortmentUnitId: widget.assortmentsListModel.assortmentUnitId)[1]}" : "",
                                ),
                              ],
                            ),
                          ),
                        ), //widget.assortmentsListModel.priceWithDiscount.toString() + " Р/${getAssortmentUnitId(assortmentUnitId: widget.assortmentsListModel.assortmentUnitId)[1]}",
                        widget.assortmentsListModel.priceWithDiscount != null
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                      text: widget.assortmentsListModel.currentPrice.toString(),
                                      style: appHeadersTextStyle(fontSize: heightRatio(size: 10, context: context), color: newGrey),
                                    ),
                                    TextSpan(
                                      text: " ${"rubleSignText".tr()}",
                                      style: appTextStyle(fontSize: heightRatio(size: 10, context: context), color: newGrey, fontWeight: FontWeight.w700),
                                    )
                                  ])),
                                  Positioned(top: 0, left: 0, right: 0, bottom: 0, child: Image.asset("assets/images/line_through_image.png", fit: BoxFit.contain))
                                ],
                              )
                            : SizedBox(),
                        //если в корзине уже есть то отображается кол-во:
                        widget.assortmentsListModel.quantityInClientCart != null && widget.assortmentsListModel.quantityInClientCart > 0 && (widget.isFavoriteProdiuctPicking == null || !widget.isFavoriteProdiuctPicking)
                            ? SizedBox()
                            : Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                decoration: BoxDecoration(
                                  // color: widget.assortmentsListModel.discountTypeColor == null ? colorBlack03 : Color(int.parse("0xff${widget.assortmentsListModel.discountTypeColor}")),
                                  color: newRedDark,
                                  borderRadius: BorderRadius.circular(heightRatio(size: 3, context: context)),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset("assets/images/newBuy.svg", height: heightRatio(size: 10, context: context), width: widthRatio(size: 10, context: context)),
                                    SizedBox(width: widthRatio(size: 6, context: context)),
                                    Text('В корзину', style: appLabelTextStyle(color: whiteColor, fontSize: 10)),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
              // Stack(
              //   children: [
              //     Positioned(
              //       right: 8, // избранное
              //       top: 8,
              //       child: SvgPicture.asset((widget.assortmentsListModel.isFavorite != null && widget.assortmentsListModel.isFavorite) ? "assets/images/newHeartConturActive.svg" : "assets/images/newHeartContur.svg", width: 18, height: 16),
              //     ),
              //     //- скидка %
              //     if (widget.assortmentsListModel.priceWithDiscount != null && widget.assortmentsListModel.currentPrice != null)
              //       Positioned(
              //         top: heightRatio(size: heightRatio(size: 7, context: context), context: context),
              //         child: Container(
              //           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              //           decoration: BoxDecoration(color: newYellow, borderRadius: BorderRadius.circular(2)),
              //           child: Text(
              //             // ( (Исходная цена − Цена со скидкой) / Исходная цена) * 100
              //             '-' + (((widget.assortmentsListModel.currentPrice.toDouble() - widget.assortmentsListModel.priceWithDiscount) / widget.assortmentsListModel.currentPrice.toDouble()) * 100).toInt().toString() + '%',
              //             style: appLabelTextStyle(fontSize: 11, color: whiteColor),
              //           ),
              //         ),
              //       ),
              //   ],
              // ),
            ],
          ),
        ),
      );
    });
  }
}

class CustomMaterialPageRoute extends MaterialPageRoute {
  @protected
  bool get hasScopedWillPopCallback {
    return false;
  }

  CustomMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
}
