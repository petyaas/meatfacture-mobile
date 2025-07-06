// ignore: implementation_imports
import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/main.dart';
import 'package:smart/models/shopping_list_deatils_model.dart';
import 'package:smart/pages/shopping_list/widgets/shopping_list_products_item.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class ShoppinsListProductItemBuilder extends StatefulWidget {
  final ShoppingListDeatailsModel shoppingListDeatailsModel;
  const ShoppinsListProductItemBuilder({@required this.shoppingListDeatailsModel});

  @override
  _ShoppinsListProductItemBuilderState createState() => _ShoppinsListProductItemBuilderState();
}

class _ShoppinsListProductItemBuilderState extends State<ShoppinsListProductItemBuilder> {
  bool isinit;
  @override
  void initState() {
    isinit = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    SecondaryPageBloc _secondaryPageBloc = BlocProvider.of(context);
    // widget.shoppingListDeatailsModel.data.assortments.first.rating = 4.6;
    // ignore: close_sinks
    // ignore: close_sinks
    BasketListBloc _basketListBloc = BlocProvider.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 25, bottom: 15),
          child: Text(
            'Всего: ${widget.shoppingListDeatailsModel.data.assortments.length} товара',
            style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
          ),
        ),
        SizedBox(
          height: heightRatio(
            size: widget.shoppingListDeatailsModel.data.assortments.length == 1
                ? 280.0
                : widget.shoppingListDeatailsModel.data.assortments.length.isOdd
                    ? 180.0 * widget.shoppingListDeatailsModel.data.assortments.length
                    : 140.0 * widget.shoppingListDeatailsModel.data.assortments.length,
            context: context,
          ),
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            itemCount: widget.shoppingListDeatailsModel.data.assortments.length,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.65,
              crossAxisSpacing: 21,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => ShoppingListProductsItem(
              uuid: widget.shoppingListDeatailsModel.data.assortments[index].uuid,
              name: widget.shoppingListDeatailsModel.data.assortments[index].name,
              thumbnail: widget.shoppingListDeatailsModel.data.assortments[index].images.isNotEmpty ? widget.shoppingListDeatailsModel.data.assortments[index].images[0].thumbnails.the1000X1000 : '',
              currentPrice: widget.shoppingListDeatailsModel.data.assortments[index].currentPrice,
              priceWithDiscount: widget.shoppingListDeatailsModel.data.assortments[index].priceWithDiscount,
              assortmentUnitId: widget.shoppingListDeatailsModel.data.assortments[index].assortmentUnitId,
              rating: widget.shoppingListDeatailsModel.data.assortments[index].rating,
              isFavorite: widget.shoppingListDeatailsModel.data.assortments[index].isFavorite,
            ),
          ),
          // child: ListView.builder(
          //   padding: EdgeInsets.only(bottom: heightRatio(size: 140, context: context)),
          //   itemCount: widget.shoppingListDeatailsModel.data.assortments.length,
          //   itemBuilder: (BuildContext context, int index) {
          // return InkWell(
          //   onTap: () {
          //     Navigator.push(context, new MaterialPageRoute(builder: (context) => RedesProductDetailsPage(productUuid: widget.shoppingListDeatailsModel.data.assortments[index].uuid)));
          //   },
          //   child: Slidable(
          //     actionExtentRatio: 1 / 7,
          //     secondaryActions: [
          //       IconSlideAction(
          //         onTap: () async {
          //           // Fluttertoast.showToast(msg: "Подождите...");
          //           if (await DeleteProductToShopingListProvider().getDeleteProducttoShoppingListRespone(shoppingListsUuid: widget.shoppingListDeatailsModel.data.uuid, assortmentUuid: widget.shoppingListDeatailsModel.data.assortments[index].uuid)) {
          //             await Fluttertoast.showToast(msg: 'Продукт удалён');
          //             setState(() {
          //               widget.shoppingListDeatailsModel.data.assortments.removeAt(index);
          //             });
          //           } else {
          //             await Fluttertoast.showToast(msg: 'errorText'.tr());
          //           }
          //         },
          //         iconWidget: Container(
          //           margin: EdgeInsets.symmetric(vertical: heightRatio(size: 10, context: context), horizontal: widthRatio(size: 5, context: context)),
          //           alignment: Alignment.center,
          //           child: SvgPicture.asset('assets/images/deleteForeverIcon.svg', height: heightRatio(size: 20, context: context), width: widthRatio(size: 20, context: context), color: mainColor),
          //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 15, context: context)), border: Border.all(color: Color.fromRGBO(255, 107, 44, 1), width: 1)),
          //         ),
          //       )
          //     ],
          //     actionPane: SlidableScrollActionPane(),
          //     child: Builder(builder: (context) {
          //       SchedulerBinding.instance.addPostFrameCallback((_) {
          //         if (isinit) {
          //           initSlidableAnimation(
          //             context: context,
          //           );
          //           isinit = false;
          //         }
          //       });
          //       return Stack(
          //         children: [
          //           Container(
          //             padding: EdgeInsets.only(left: widthRatio(size: 15, context: context), top: heightRatio(size: 15, context: context)),
          //             color: (widget.shoppingListDeatailsModel.data.assortments[index].currentPrice != null || widget.shoppingListDeatailsModel.data.assortments[index].priceWithDiscount != null) && widget.shoppingListDeatailsModel.data.assortments[index].productsQuantity != 0
          //                 ? whiteColor
          //                 : colorBlack03,
          //             child: Row(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Container(
          //                   clipBehavior: Clip.hardEdge,
          //                   decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.circular(heightRatio(size: 20, context: context)),
          //                     color: colorBlack03,
          //                   ),
          //                   height: heightRatio(size: 95, context: context),
          //                   width: widthRatio(size: 95, context: context),
          //                   child: Image.network(
          //                     widget.shoppingListDeatailsModel.data.assortments[index].images[0].path,
          //                     fit: BoxFit.cover,
          //                   ),
          //                 ),
          //                 SizedBox(width: widthRatio(size: 10, context: context)),
          //                 Expanded(
          //                   child: Container(
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Container(
          //                           padding: EdgeInsets.only(right: widthRatio(size: 10, context: context)),
          //                           height: heightRatio(size: 40, context: context),
          //                           child: Text(widget.shoppingListDeatailsModel.data.assortments[index].name, maxLines: 2, style: appTextStyle(fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w600)),
          //                         ),
          //                         SizedBox(height: heightRatio(size: 5, context: context)),
          //                         Row(
          //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                           children: [
          //                             Column(
          //                               crossAxisAlignment: CrossAxisAlignment.start,
          //                               children: [
          //                                 Row(
          //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                                   children: [
          //                                     Row(
          //                                       children: [
          //                                         Text(
          //                                           widget.shoppingListDeatailsModel.data.assortments[index].weight == null || widget.shoppingListDeatailsModel.data.assortments[index].weight == "0"
          //                                               ? ""
          //                                               : double.parse(widget.shoppingListDeatailsModel.data.assortments[index].weight) > 500
          //                                                   ? "${"productWeightText".tr()}: ${double.parse(widget.shoppingListDeatailsModel.data.assortments[index].weight) / 1000}${"kgText".tr()}"
          //                                                   : "${"productWeightText".tr()}: ${widget.shoppingListDeatailsModel.data.assortments[index].weight}${"grText".tr()}",
          //                                           style: appTextStyle(fontSize: heightRatio(size: 9, context: context), color: colorBlack04, fontWeight: FontWeight.w500),
          //                                         ),
          //                                         SizedBox(
          //                                           width: widthRatio(size: 5, context: context),
          //                                         ),
          //                                         Container(
          //                                           child: SvgPicture.asset(
          //                                             widget.shoppingListDeatailsModel.data.assortments[index].rating == null ? "assets/images/star.svg" : "assets/images/activeStar.svg",
          //                                             height: heightRatio(size: 11, context: context),
          //                                           ),
          //                                         ),
          //                                         SizedBox(width: 1),
          //                                         Text(
          //                                           "${widget.shoppingListDeatailsModel.data.assortments[index].rating ?? ""}",
          //                                           style: appTextStyle(fontSize: heightRatio(size: 9, context: context), fontWeight: FontWeight.w500, color: colorBlack04),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ],
          //                                 ),
          //                                 SizedBox(
          //                                   height: heightRatio(size: 3, context: context),
          //                                 ),
          //                                 Row(
          //                                   mainAxisAlignment: MainAxisAlignment.start,
          //                                   children: [
          //                                     GestureDetector(
          //                                       onTap: () async {
          //                                         setState(() {
          //                                           if (widget.shoppingListDeatailsModel.data.assortments[index].quantity > 0) {
          //                                             if (widget.shoppingListDeatailsModel.data.assortments[index].assortmentUnitId != "kilogram") {
          //                                               widget.shoppingListDeatailsModel.data.assortments[index].quantity -= 1;
          //                                             } else {
          //                                               widget.shoppingListDeatailsModel.data.assortments[index].quantity -= double.parse(widget.shoppingListDeatailsModel.data.assortments[index].weight);
          //                                             }
          //                                           }
          //                                         });

          //                                         if (widget.shoppingListDeatailsModel.data.assortments[index].quantity == 0) {
          //                                           if (await DeleteProductToShopingListProvider()
          //                                               .getDeleteProducttoShoppingListRespone(shoppingListsUuid: widget.shoppingListDeatailsModel.data.uuid, assortmentUuid: widget.shoppingListDeatailsModel.data.assortments[index].uuid)) {
          //                                             await Fluttertoast.showToast(msg: 'Продукт удалён');
          //                                             setState(() {
          //                                               widget.shoppingListDeatailsModel.data.assortments.removeAt(index);
          //                                             });
          //                                           } else {
          //                                             await Fluttertoast.showToast(msg: 'errorText'.tr());
          //                                           }
          //                                         }
          //                                       },
          //                                       child: Container(
          //                                         padding: EdgeInsets.all(widthRatio(size: 3, context: context)),
          //                                         decoration: BoxDecoration(shape: BoxShape.circle, color: mainColor),
          //                                         child: Icon(Icons.remove_rounded, color: whiteColor),
          //                                       ),
          //                                     ),
          //                                     SizedBox(width: widthRatio(size: 10, context: context)),
          //                                     Text(
          //                                       widget.shoppingListDeatailsModel.data.assortments[index].assortmentUnitId == "kilogram"
          //                                           ? widget.shoppingListDeatailsModel.data.assortments[index].quantity.toString() + " ${getAssortmentUnitId(assortmentUnitId: widget.shoppingListDeatailsModel.data.assortments[index].assortmentUnitId)[1]}"
          //                                           : widget.shoppingListDeatailsModel.data.assortments[index].quantity.toInt().toString() + " ${getAssortmentUnitId(assortmentUnitId: widget.shoppingListDeatailsModel.data.assortments[index].assortmentUnitId)[1]}",
          //                                       style: appTextStyle(color: mainColor, fontWeight: FontWeight.w700),
          //                                     ),
          //                                     SizedBox(width: widthRatio(size: 10, context: context)),
          //                                     GestureDetector(
          //                                       onTap: () {
          //                                         setState(() {
          //                                           if (widget.shoppingListDeatailsModel.data.assortments[index].assortmentUnitId != "kilogram") {
          //                                             widget.shoppingListDeatailsModel.data.assortments[index].quantity++;
          //                                           } else {
          //                                             widget.shoppingListDeatailsModel.data.assortments[index].quantity += double.parse(widget.shoppingListDeatailsModel.data.assortments[index].weight);
          //                                           }
          //                                         });
          //                                       },
          //                                       child: Container(
          //                                         padding: EdgeInsets.all(widthRatio(size: 3, context: context)),
          //                                         decoration: BoxDecoration(shape: BoxShape.circle, color: mainColor),
          //                                         child: Icon(
          //                                           Icons.add_rounded,
          //                                           color: whiteColor,
          //                                         ),
          //                                       ),
          //                                     ),
          //                                   ],
          //                                 ),
          //                               ],
          //                             ),

          //                             //prices
          //                             Padding(
          //                               padding: EdgeInsets.only(right: widthRatio(size: 10, context: context)),
          //                               child: Column(
          //                                 crossAxisAlignment: CrossAxisAlignment.start,
          //                                 children: [
          //                                   widget.shoppingListDeatailsModel.data.assortments[index].currentPrice != null
          //                                       ? Container(
          //                                           padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 4, context: context), vertical: heightRatio(size: 2, context: context)),
          //                                           decoration: BoxDecoration(
          //                                               color: widget.shoppingListDeatailsModel.data.assortments[index].discountTypeColor == null ? colorBlack03 : Color(int.parse("0xff${widget.shoppingListDeatailsModel.data.assortments[index].discountTypeColor}")),
          //                                               borderRadius: BorderRadius.circular(heightRatio(size: 4, context: context))),
          //                                           child: Text(
          //                                               widget.shoppingListDeatailsModel.data.assortments[index].priceWithDiscount == null
          //                                                   ? widget.shoppingListDeatailsModel.data.assortments[index].currentPrice.toString() +
          //                                                       " ${"rubleSignText".tr()}/${getAssortmentUnitId(assortmentUnitId: widget.shoppingListDeatailsModel.data.assortments[index].assortmentUnitId)[1]}"
          //                                                   : widget.shoppingListDeatailsModel.data.assortments[index].priceWithDiscount.toString() + " ₽/${getAssortmentUnitId(assortmentUnitId: widget.shoppingListDeatailsModel.data.assortments[index].assortmentUnitId)[1]}",
          //                                               style: appTextStyle(fontWeight: FontWeight.w800, fontSize: heightRatio(size: 12, context: context))),
          //                                         )
          //                                       : SizedBox(),
          //                                   SizedBox(
          //                                     height: heightRatio(size: 3, context: context),
          //                                   ),
          //                                   Container(
          //                                     child: Stack(
          //                                       alignment: Alignment.center,
          //                                       children: [
          //                                         Container(
          //                                           alignment: Alignment.center,
          //                                           child: Text(
          //                                               widget.shoppingListDeatailsModel.data.assortments[index].priceWithDiscount != null
          //                                                   ? widget.shoppingListDeatailsModel.data.assortments[index].currentPrice != null
          //                                                       ? widget.shoppingListDeatailsModel.data.assortments[index].currentPrice.toString() + " ${"rubleSignText".tr()}"
          //                                                       : ""
          //                                                   : "",
          //                                               style: appTextStyle(
          //                                                 decorationColor: colorBlack04,
          //                                                 fontSize: heightRatio(size: 12, context: context),
          //                                                 color: colorBlack04,
          //                                                 fontWeight: FontWeight.w600,
          //                                               )),
          //                                         ),
          //                                         Positioned(
          //                                           top: 0,
          //                                           left: 0,
          //                                           right: 0,
          //                                           bottom: 0,
          //                                           child: Image.asset("assets/images/line_through_image.png", fit: BoxFit.contain),
          //                                         )
          //                                       ],
          //                                     ),
          //                                   ),
          //                                   SizedBox(width: widthRatio(size: 15, context: context)),
          //                                 ],
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                         SizedBox(height: heightRatio(size: 13, context: context)),
          //                         Container(alignment: Alignment.center, height: 0.5, color: colorBlack03)
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           if ((widget.shoppingListDeatailsModel.data.assortments[index].currentPrice != null || widget.shoppingListDeatailsModel.data.assortments[index].priceWithDiscount != null) && widget.shoppingListDeatailsModel.data.assortments[index].productsQuantity != 0)
          //             SizedBox()
          //           else
          //             Positioned(
          //               // top: 0,
          //               bottom: 0,
          //               right: 0,
          //               // left: 0,
          //               child: Container(
          //                 padding: EdgeInsets.only(bottom: heightRatio(size: 3, context: context), right: widthRatio(size: 10, context: context)),
          //                 alignment: Alignment.bottomRight,
          //                 child: Text("notAvailable".tr(), style: appTextStyle(fontSize: heightRatio(size: 13.5, context: context), fontWeight: FontWeight.w700, color: mainColor)),
          //               ),
          //             ),
          //         ],
          //       );
          //     }),
          //   ),
          // );
          //   },
          // ),
        ),
        InkWell(
          onTap: () async {
            // if (!await BasketProvider().addShoppingListToBasket(
            //     widget.shoppingListDeatailsModel.data.uuid)) {
            //   Fluttertoast.showToast(msg: "errorText".tr());
            // } else {
            //   _basketListBloc.add(BasketLoadEvent());
            // }
            _secondaryPageBloc.add(CatalogEvent());
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
            margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
            child: Text("addProductsToList".tr(), style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context))),
          ),
        ),
        SizedBox(height: heightRatio(size: 12, context: context)),
        InkWell(
          onTap: () async {
            Fluttertoast.showToast(msg: "Подождите...");
            if (!await BasketProvider().addShoppingListToBasket(widget.shoppingListDeatailsModel.data.uuid)) {
              Fluttertoast.showToast(msg: "errorText".tr());
            } else {
              _basketListBloc.add(BasketLoadEvent());
              _secondaryPageBloc.add(BasketPageLoadEvent());
              Navigator.of(context).pushNamedAndRemoveUntil('', (Route<dynamic> route) => false);
            }
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
            margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
            child: Text("Добавить все товары в корзину", style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context))),
          ),
        ),
        SizedBox(height: heightRatio(size: 50, context: context)),
      ],
    );
  }

  void initSlidableAnimation({BuildContext context}) async {
    if (await prefs.getBool("hasShoppingListDetailsIn") == null || await prefs.getBool("hasShoppingListDetailsIn") == false) {
      prefs.setBool("hasShoppingListDetailsIn", true);
      final slidable = Slidable.of(context);
      slidable.open(actionType: SlideActionType.secondary);
      Timer(
        Duration(milliseconds: 1500),
        () => slidable.close(),
      );
    }
  }
}
