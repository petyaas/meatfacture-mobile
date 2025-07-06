import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/bloc_files/add_or_subtract_bonuses_bloc.dart';
import 'package:smart/bloc_files/order_calculate_bloc.dart';
import 'package:smart/bloc_files/selected_pay_card_and_address_for_order_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/features/basket/models/basket_list_model.dart';
import 'package:smart/models/product_model_for_order_request.dart';
import 'package:smart/pages/redesigned_pages/redes_product_details_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/utils/custom_cache_manager.dart';

class BasketListItem extends StatefulWidget {
  final int index;
  final BasketListDataModel item;
  final BasketListBloc basketListBloc;
  final BasketLoadedState state;
  final List<ProductModelForOrderRequest> productModelForOrderRequestList;
  final OrderCalculateBloc orderCalculateBloc;
  final AddOrSubtractBonusesState addOrSubtractBonusesState;
  final SelectedPayCardAndAddressForOrderState selectedPayCardAndAddressForOrderState;
  final int subtractBonuses;
  final String orderDeliveryTypeId;

  const BasketListItem({
    Key key,
    @required this.index,
    @required this.item,
    @required this.basketListBloc,
    @required this.state,
    @required this.productModelForOrderRequestList,
    @required this.orderCalculateBloc,
    @required this.addOrSubtractBonusesState,
    @required this.selectedPayCardAndAddressForOrderState,
    @required this.subtractBonuses,
    @required this.orderDeliveryTypeId,
  }) : super(key: key);

  @override
  _BasketListItemState createState() => _BasketListItemState();
}

class _BasketListItemState extends State<BasketListItem> {
  SlidableController _shoppingListSlidableController = SlidableController();
  bool isLoadingText = false;

  Future<void> _updateProductInBasket(String productUuid, double quantity) async {
    setState(() {
      isLoadingText = true;
    });

    await BasketProvider().updateProductInBasket(
      productUuid: productUuid,
      quantity: quantity,
    );

    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoadingText = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          new CupertinoPageRoute(
            builder: (context) => RedesProductDetailsPage(
              isFromBasket: true,
              productUuid: widget.item.assortment.uuid,
            ),
          ),
        );
      },
      child: Slidable(
        controller: _shoppingListSlidableController,
        actionExtentRatio: 1 / 6,
        secondaryActions: [
          IconSlideAction(
            onTap: () async {
              await _deleteProductFromBasket(
                index: widget.index,
                basketListBloc: widget.basketListBloc,
              );
            },
            closeOnTap: true,
            iconWidget: Container(
              height: 89,
              margin: EdgeInsets.only(left: widthRatio(size: 20, context: context)),
              padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 11, context: context)),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/images/newTrash.svg',
                height: heightRatio(size: 21, context: context),
                width: widthRatio(size: 18, context: context),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(heightRatio(size: 15, context: context)),
                border: Border.all(color: newGrey, width: widthRatio(size: 1, context: context)),
              ),
            ),
          ),
        ],
        actionPane: SlidableScrollActionPane(),
        child: Column(
          children: [
            Builder(
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: heightRatio(size: 10, context: context)),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              //фото левая часть товара
                              Container(
                                foregroundDecoration: (widget.item.assortment.currentPrice != null || widget.item.assortment.priceWithDiscount != null) && widget.item.assortment.quantityInStore != null
                                    ? BoxDecoration()
                                    : BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 8, context: context)), color: Colors.grey, backgroundBlendMode: BlendMode.saturation),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(heightRatio(size: 8, context: context)),
                                  color: newIconBg,
                                ),
                                height: heightRatio(size: 89, context: context),
                                width: widthRatio(size: 89, context: context),
                                child: widget.item.assortment.images.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: widget.item.assortment.images[0].thumbnails.the1000X1000,
                                        cacheManager: CustomCacheManager(),
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => Image.asset("assets/images/notImage.png", fit: BoxFit.contain),
                                        useOldImageOnUrlChange: true,
                                      )
                                    // ? Image.network(
                                    //     widget.item.assortment.images[0].thumbnails.the1000X1000,
                                    //     fit: BoxFit.cover,
                                    //   )
                                    : Image.asset("assets/images/notImage.png", fit: BoxFit.fitWidth),
                              ),

                              // bonuses
                              if (widget.item.assortment.bonusPercent != null && widget.item.assortment.bonusPercent != 0)
                                Positioned(
                                  bottom: heightRatio(size: 4, context: context),
                                  left: widthRatio(size: 4, context: context),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(widthRatio(size: 4, context: context)),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 4, context: context), vertical: heightRatio(size: 2, context: context)),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: widthRatio(size: 15, context: context),
                                          height: heightRatio(size: 15, context: context),
                                          child: SvgPicture.asset('assets/images/bonus_vector.svg', width: widthRatio(size: 15, context: context), height: heightRatio(size: 15, context: context)),
                                        ),
                                        SizedBox(width: widthRatio(size: 3, context: context)),
                                        Text(
                                          widget.item.assortment.priceWithDiscount == null || widget.item.assortment.priceWithDiscount == 0
                                              ? (widget.item.assortment.currentPrice / 100 * widget.item.assortment.bonusPercent).toStringAsFixed(0)
                                              : (widget.item.assortment.priceWithDiscount / 100 * widget.item.assortment.bonusPercent).toStringAsFixed(0),
                                          style: appHeadersTextStyle(fontSize: heightRatio(size: 10, context: context), fontWeight: FontWeight.w700, color: colorBlack06),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                            ],
                          ),
                          SizedBox(width: widthRatio(size: 10, context: context)),
                          Expanded(
                            // правая часть товара
                            child: SizedBox(
                              height: heightRatio(size: 89, context: context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.item.assortment.name,
                                          maxLines: 2,
                                          style: appHeadersTextStyle(
                                            color: (widget.item.assortment.currentPrice != null || widget.item.assortment.priceWithDiscount != null) && widget.item.assortment.quantityInStore != null ? newBlack : colorBlack04,
                                            fontSize: heightRatio(size: 12, context: context),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            //rating
                                            if (widget.item.assortment.rating != null)
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/images/newStar.svg",
                                                    height: heightRatio(size: 11, context: context),
                                                  ),
                                                  SizedBox(width: widthRatio(size: 2, context: context)),
                                                  Text(
                                                    widget.item.assortment.rating != null ? widget.item.assortment.rating.toString() : '',
                                                    style: appHeadersTextStyle(fontSize: heightRatio(size: 9, context: context), color: newGrey),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start, // + -
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              setState(() {
                                                isLoadingText = true;
                                              });
                                              await _updateProductInBasket(
                                                widget.item.assortment.uuid,
                                                widget.item.quantity - (widget.item.assortment.assortmentUnitId == "kilogram" ? widget.item.assortment.weight.toInt() / 1000 : 1),
                                              );

                                              if (widget.item.assortment.assortmentUnitId != "kilogram") {
                                                if (widget.item.quantity > 1) {
                                                  context.read<BasketListBloc>().add(UpdateProductQuantityEvent(index: widget.index, newQuantity: widget.item.quantity - 1));
                                                } else {
                                                  await _deleteProductFromBasket(
                                                    index: widget.index,
                                                    basketListBloc: widget.basketListBloc,
                                                  );
                                                }
                                              } else {
                                                // Обработка для весового товара
                                                //убавляем с корзины
                                                double weight = double.tryParse(widget.item.assortment.weight) ?? 0.0;
                                                double weightInKg = weight / 1000;
                                                double newQuantity = widget.item.quantity - weightInKg;
                                                if (newQuantity > 0) {
                                                  context.read<BasketListBloc>().add(UpdateProductQuantityEvent(index: widget.index, newQuantity: newQuantity));
                                                } else {
                                                  await _deleteProductFromBasket(
                                                    index: widget.index,
                                                    basketListBloc: widget.basketListBloc,
                                                  );
                                                }
                                              }
                                              _calculateOrder(
                                                orderCalculateBloc: widget.orderCalculateBloc,
                                                productModelForOrderRequestList: widget.productModelForOrderRequestList,
                                                selectedPayCardAndAddressForOrderState: widget.selectedPayCardAndAddressForOrderState,
                                                addOrSubtractBonusesState: widget.addOrSubtractBonusesState,
                                              );
                                              Timer(Duration(seconds: 1), () {
                                                setState(() {
                                                  isLoadingText = false;
                                                });
                                              });
                                            },
                                            child: SvgPicture.asset(
                                              ((widget.item.assortment.currentPrice == null || widget.item.assortment.priceWithDiscount == null) && widget.item.assortment.quantityInStore == null)
                                                  ? "assets/images/remove_circle_button_grey.svg"
                                                  : "assets/images/remove_circle_button.svg",
                                              height: heightRatio(size: 28, context: context),
                                              width: widthRatio(size: 28, context: context),
                                            ),
                                          ),
                                          SizedBox(width: widthRatio(size: 8, context: context)),
                                          isLoadingText
                                              ? Shimmer.fromColors(
                                                  baseColor: Colors.grey[500],
                                                  highlightColor: Colors.grey[100],
                                                  child: Text(
                                                    widget.item.assortment.assortmentUnitId == "kilogram"
                                                        ? widget.item.quantity > 0.9
                                                            ? "${widget.item.quantity.toStringAsFixed(1)}${"kgText".tr()}"
                                                            : "${(widget.item.quantity * 1000).toStringAsFixed(0)}${"grText".tr()}".toString()
                                                        : widget.item.quantity.toInt().toString() + " " + getAssortmentUnitId(assortmentUnitId: widget.item.assortment.assortmentUnitId)[1],
                                                    style: appHeadersTextStyle(fontSize: 12, color: newBlack),
                                                  ),
                                                )
                                              : Text(
                                                  widget.item.assortment.assortmentUnitId == "kilogram"
                                                      ? widget.item.quantity > 0.9
                                                          ? (widget.item.quantity % 1 == 0 ? "${widget.item.quantity.toInt()}${"kgText".tr()}" : "${widget.item.quantity.toStringAsFixed(1)}${"kgText".tr()}")
                                                          : "${(widget.item.quantity * 1000).toStringAsFixed(0)}${"grText".tr()}"
                                                      : widget.item.quantity.toInt().toString() + " " + getAssortmentUnitId(assortmentUnitId: widget.item.assortment.assortmentUnitId)[1],
                                                  style: appHeadersTextStyle(fontSize: 12, color: newBlack),
                                                ),
                                          SizedBox(width: widthRatio(size: 8, context: context)),
                                          InkWell(
                                            onTap: () async {
                                              setState(() {
                                                isLoadingText = true;
                                              });

                                              await _updateProductInBasket(
                                                widget.item.assortment.uuid,
                                                widget.item.quantity + (widget.item.assortment.assortmentUnitId == "kilogram" ? widget.item.assortment.weight.toInt() / 1000 : 1),
                                              );

                                              if (widget.item.assortment.assortmentUnitId != "kilogram") {
                                                context.read<BasketListBloc>().add(UpdateProductQuantityEvent(index: widget.index, newQuantity: widget.item.quantity + 1));
                                              } else {
                                                // Обработка для весового товара
                                                //Добавляем с корзины
                                                double weight = double.tryParse(widget.item.assortment.weight) ?? 0.0;
                                                double weightInKg = weight / 1000;
                                                double newQuantity = widget.item.quantity + weightInKg;
                                                context.read<BasketListBloc>().add(UpdateProductQuantityEvent(index: widget.index, newQuantity: newQuantity));
                                              }
                                              _calculateOrder(
                                                orderCalculateBloc: widget.orderCalculateBloc,
                                                productModelForOrderRequestList: widget.productModelForOrderRequestList,
                                                selectedPayCardAndAddressForOrderState: widget.selectedPayCardAndAddressForOrderState,
                                                addOrSubtractBonusesState: widget.addOrSubtractBonusesState,
                                              );
                                              Timer(Duration(seconds: 1), () {
                                                setState(() {
                                                  isLoadingText = false;
                                                });
                                              });
                                            },
                                            child: SvgPicture.asset(
                                              ((widget.item.assortment.currentPrice == null || widget.item.assortment.priceWithDiscount == null) && widget.item.assortment.quantityInStore == null) ? "assets/images/add_circle_button_grey.svg" : "assets/images/add_circle_button.svg",
                                              height: heightRatio(size: 28, context: context),
                                              width: widthRatio(size: 28, context: context),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Prices
                                      BlocBuilder<OrderCalculateBloc, OrderCalculateState>(
                                        builder: (context, calculateState) {
                                          return calculateState.orderCalculateResponseModel != null && calculateState.orderCalculateResponseModel.data.products.length > widget.index
                                              ? Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        if (calculateState.orderCalculateResponseModel.data.products[widget.index].originalPrice != calculateState.orderCalculateResponseModel.data.products[widget.index].priceWithDiscount)
                                                          Stack(
                                                            //цена перечеркнутая
                                                            alignment: Alignment.center,
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text: calculateState.orderCalculateResponseModel.data.products[widget.index].originalPrice.toStringAsFixed(0),
                                                                      style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newGrey),
                                                                    ),
                                                                    TextSpan(
                                                                      text: " ${"rubleSignText".tr()}",
                                                                      style: appTextStyle(fontSize: heightRatio(size: 12, context: context), color: newGrey, fontWeight: FontWeight.w700),
                                                                    )
                                                                  ],
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
                                                        SizedBox(width: widthRatio(size: 10, context: context)),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: calculateState.orderCalculateResponseModel.data.products[widget.index].price.toStringAsFixed(0),
                                                                style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: Colors.black),
                                                              ),
                                                              TextSpan(
                                                                text: " ${"rubleSignText".tr()}",
                                                                style: appTextStyle(fontSize: heightRatio(size: 12, context: context), color: Colors.black, fontWeight: FontWeight.w400),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: heightRatio(size: 6, context: context)),
                                                    if (calculateState.orderCalculateResponseModel.data.products[widget.index].price != null || calculateState.orderCalculateResponseModel.data.products[widget.index].priceWithDiscount != null)
                                                      Container(
                                                        //цена закрашенная price
                                                        padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 6, context: context), vertical: heightRatio(size: 3, context: context)),
                                                        decoration: BoxDecoration(
                                                            color: calculateState.orderCalculateResponseModel.data.products[widget.index].discountTypeColor == null
                                                                ? newRedDark
                                                                : Color(int.parse("0xff${calculateState.orderCalculateResponseModel.data.products[widget.index].discountTypeColor}")),
                                                            borderRadius: BorderRadius.circular(heightRatio(size: 4, context: context))),
                                                        child: isLoadingText
                                                            ? Shimmer.fromColors(
                                                                baseColor: Colors.grey[300],
                                                                highlightColor: Colors.grey[100],
                                                                child: RichText(
                                                                  text: TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        style: appHeadersTextStyle(
                                                                            color: (calculateState.orderCalculateResponseModel.data.products[widget.index].price != null || calculateState.orderCalculateResponseModel.data.products[widget.index].priceWithDiscount != null) &&
                                                                                    widget.item.assortment.quantityInStore != null
                                                                                ? whiteColor
                                                                                : colorBlack04,
                                                                            fontSize: heightRatio(size: 12, context: context)),
                                                                        text: calculateState.orderCalculateResponseModel.data.products[widget.index].totalAmountWithDiscount.toStringAsFixed(0),
                                                                      ),
                                                                      TextSpan(
                                                                        text: " ${"rubleSignText".tr()}",
                                                                        style: appTextStyle(
                                                                            color: (calculateState.orderCalculateResponseModel.data.products[widget.index].price != null || calculateState.orderCalculateResponseModel.data.products[widget.index].priceWithDiscount != null) &&
                                                                                    widget.item.assortment.quantityInStore != null
                                                                                ? whiteColor
                                                                                : colorBlack04,
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: heightRatio(size: 12, context: context)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      style: appHeadersTextStyle(
                                                                          color: (calculateState.orderCalculateResponseModel.data.products[widget.index].price != null || calculateState.orderCalculateResponseModel.data.products[widget.index].priceWithDiscount != null) &&
                                                                                  widget.item.assortment.quantityInStore != null
                                                                              ? whiteColor
                                                                              : colorBlack04,
                                                                          fontSize: heightRatio(size: 12, context: context)),
                                                                      text: calculateState.orderCalculateResponseModel.data.products[widget.index].totalAmountWithDiscount.toStringAsFixed(0),
                                                                    ),
                                                                    TextSpan(
                                                                      text: " ${"rubleSignText".tr()}",
                                                                      style: appTextStyle(
                                                                          color: (calculateState.orderCalculateResponseModel.data.products[widget.index].price != null || calculateState.orderCalculateResponseModel.data.products[widget.index].priceWithDiscount != null) &&
                                                                                  widget.item.assortment.quantityInStore != null
                                                                              ? whiteColor
                                                                              : colorBlack04,
                                                                          fontWeight: FontWeight.w700,
                                                                          fontSize: heightRatio(size: 12, context: context)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                      ),
                                                    SizedBox(height: heightRatio(size: 4, context: context)),
                                                  ],
                                                )
                                              : Column(
                                                  children: [
                                                    if ((widget.item.assortment.currentPrice == null || widget.item.assortment.priceWithDiscount == null) && widget.item.assortment.quantityInStore == null)
                                                      Text("notAvailable".tr(), style: appHeadersTextStyle(fontSize: heightRatio(size: 13, context: context), color: newRedDark)),
                                                    SizedBox(height: heightRatio(size: 4, context: context)),
                                                  ],
                                                );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: heightRatio(size: 20, context: context)),
                      Container(height: 1, color: grey04),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteProductFromBasket({
    @required int index,
    @required BasketListBloc basketListBloc,
  }) async {
    if (await BasketProvider().reomoveProductFromBasket(widget.item.assortment.uuid)) {
      basketListBloc.add(BasketRemoveItemEvent(index));
      if (widget.state.basketListModel.data.isNotEmpty) {
        _calculateOrder(
          orderCalculateBloc: widget.orderCalculateBloc,
          productModelForOrderRequestList: widget.productModelForOrderRequestList,
          selectedPayCardAndAddressForOrderState: widget.selectedPayCardAndAddressForOrderState,
          addOrSubtractBonusesState: widget.addOrSubtractBonusesState,
        );
      }
    } else {
      Fluttertoast.showToast(msg: "Не удалось удалить продукт!");
    }
  }

  void _calculateOrder({
    @required OrderCalculateBloc orderCalculateBloc,
    @required List<ProductModelForOrderRequest> productModelForOrderRequestList,
    @required SelectedPayCardAndAddressForOrderState selectedPayCardAndAddressForOrderState,
    @required AddOrSubtractBonusesState addOrSubtractBonusesState,
  }) {
    orderCalculateBloc.add(OrderCalculateLoadEvent(
      subtractBonusesCount: addOrSubtractBonusesState is AddBonusesState ? null : widget.subtractBonuses,
      orderDeliveryTypeId: widget.orderDeliveryTypeId,
      orderPaymentTypeId: selectedPayCardAndAddressForOrderState is SelectedPayCardAndAddressForOrderLoadedState ? selectedPayCardAndAddressForOrderState.payType : null,
      productModelForOrderRequestList: productModelForOrderRequestList,
    ));
  }
}
