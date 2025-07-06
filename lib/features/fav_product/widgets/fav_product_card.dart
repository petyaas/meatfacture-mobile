import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_rotated_box_for_fav_prod_discount.dart';
import 'package:smart/features/fav_product/models/favorite_product_model.dart';
import 'package:smart/pages/redesigned_pages/redes_product_details_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class FavProductCard extends StatelessWidget {
  final FavoriteProductDataModel productModel;
  FavProductCard({@required this.productModel});

  @override
  Widget build(BuildContext context) {
    DateTime _activeTo = dateTimeConverter(productModel.activeTo);
    DateTime _activeFrom = dateTimeConverter(productModel.activeFrom);
    BasketListBloc _basketListBloc = BlocProvider.of<BasketListBloc>(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          new CupertinoPageRoute(
            builder: (context) => RedesProductDetailsPage(productUuid: productModel.assortmentUuid),
          ),
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: heightRatio(size: 8, context: context)),
        padding: EdgeInsets.all(widthRatio(size: 12, context: context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(heightRatio(size: 15, context: context)),
          color: Colors.white,
          boxShadow: [BoxShadow(color: shadowGrayColor006, spreadRadius: 5, blurRadius: 7, offset: Offset(0, 0))],
        ),
        child: Row(
          children: [
            Stack(
              //фото с процентом
              clipBehavior: Clip.none,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  height: heightRatio(size: 60, context: context),
                  width: widthRatio(size: 60, context: context),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)), color: colorBlack03),
                  child: Image.network(productModel.images.first.path, fit: BoxFit.fitHeight),
                ),
                Positioned(right: -6, top: -5, child: redesRotatedBoxForFavProdDiscount(double.parse(productModel.discountPercent).toStringAsFixed(0), context)),
              ],
            ),
            // Container(
            //   width: 60,
            //   height: 60,
            //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)), color: newIconBg),
            //   child: SvgPicture.asset("assets/images/newHeart.svg", height: heightRatio(size: 28, context: context), width: widthRatio(size: 32, context: context), fit: BoxFit.scaleDown),
            // ),
            SizedBox(width: widthRatio(size: 12, context: context)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productModel.assortmentName,
                    style: appHeadersTextStyle(fontSize: heightRatio(size: 13, context: context)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: heightRatio(size: 3, context: context)),
                  Text(
                    validText(activeTo: _activeTo, activeFrom: _activeFrom),
                    style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), fontWeight: FontWeight.w500, color: colorBlack06),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: heightRatio(size: 10, context: context)),
                  Row(
                    children: [
                      Text(
                        "${productModel.priceWithDiscount.toStringAsFixed(2)} ${"rubleSignText".tr()}/${getAssortmentUnitId(assortmentUnitId: productModel.assortmentUnitId)[1]}",
                        style: appTextStyle(fontSize: heightRatio(size: 12, context: context), fontWeight: FontWeight.w700, color: mainColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: widthRatio(size: 5, context: context)),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              productModel.priceWithDiscount != null
                                  ? productModel.currentPrice != null
                                      ? productModel.currentPrice.toString() + " ₽"
                                      : ""
                                  : "",
                              style: appTextStyle(decorationColor: colorBlack04, fontSize: heightRatio(size: 12, context: context), color: colorBlack04, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Image.asset("assets/images/line_through_image.png", fit: BoxFit.contain),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: widthRatio(size: 10, context: context)),
            InkWell(
              onTap: () async {
                if (await BasketProvider().addProductInBasket(productModel.assortmentUuid, 1)) {
                  _basketListBloc.add(BasketLoadEvent());
                }
              },
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: newRedDark),
                padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
                child: SvgPicture.asset("assets/images/redes_cart_icon.svg"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String validText({DateTime activeTo, DateTime activeFrom}) {
  String _formedDate = "${activeTo.day < 10 ? ("0" + activeTo.day.toString()) : activeTo.day}.${activeTo.month < 10 ? ("0" + activeTo.month.toString()) : activeTo.month}";
  if (activeFrom.isBefore(DateTime.now())) {
    return "${"validForText".tr()} $_formedDate";
  } else if (activeFrom.isAfter(DateTime.now())) {
    if (DateTime.now().day == activeFrom.day) {
      return "${"fromToday".tr()} $_formedDate";
    } else {
      return "${"fromTomorrow".tr()} $_formedDate";
    }
  } else {
    return "";
  }
}
