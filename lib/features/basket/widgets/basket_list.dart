import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/bloc_files/add_or_subtract_bonuses_bloc.dart';
import 'package:smart/bloc_files/order_calculate_bloc.dart';
import 'package:smart/bloc_files/order_type_bloc.dart';
import 'package:smart/bloc_files/selected_pay_card_and_address_for_order_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/features/basket/widgets/basket_list_item.dart';
import 'package:smart/features/basket/widgets/dashed_border_container.dart';
import 'package:smart/main.dart';
import 'package:smart/models/product_model_for_order_request.dart';
import 'package:smart/pages/redesigned_pages/redes_product_details_page.dart';
import 'package:smart/theme/app_alert.dart';

class BasketList extends StatefulWidget {
  const BasketList({Key key}) : super(key: key);

  @override
  State<BasketList> createState() => _BasketListState();
}

class _BasketListState extends State<BasketList> {
  double kgToAddToBasket = 0;
  bool isinit;
  bool isLoadingText;
  List<ProductModelForOrderRequest> productModelForOrderRequestList = [];
  final TextEditingController _promoCodeController = TextEditingController();

  @override
  void initState() {
    isinit = true;
    isLoadingText = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BasketListBloc _basketListBloc = BlocProvider.of<BasketListBloc>(context);
    OrderCalculateBloc _orderCalculateBloc = BlocProvider.of(context);

    return BlocBuilder<OrderTypeBloc, OrderTypeState>(
      builder: (context, orderTypeState) {
        final String orderDeliveryTypeId = orderTypeState is OrderTypePickupState ? "pickup" : "delivery";
        return BlocBuilder<SelectedPayCardAndAddressForOrderBloc, SelectedPayCardAndAddressForOrderState>(
          builder: (context, selectedPayCardAndAddressForOrderState) {
            final int subtractBonuses =
                selectedPayCardAndAddressForOrderState is SelectedPayCardAndAddressForOrderLoadedState //
                    ? selectedPayCardAndAddressForOrderState.apartmentNumber ?? 0
                    : 0;
            return BlocBuilder<AddOrSubtractBonusesBloc, AddOrSubtractBonusesState>(
              builder: (context, addOrSubtractBonusesState) {
                return BlocBuilder<BasketListBloc, BasketState>(
                  builder: (context, state) {
                    void _setProductsForCalculation() {
                      if (state is BasketLoadedState) {
                        productModelForOrderRequestList.clear();
                        state.basketListModel.data.map((e) {
                          if ((e.assortment.priceWithDiscount != null || e.assortment.currentPrice != null) &&
                              e.assortment.quantityInStore != null) {
                            return ProductModelForOrderRequest(assortmentUuid: e.assortment.uuid, quantity: e.quantity);
                          }
                        });
                        for (var item in state.basketListModel.data) {
                          if ((item.assortment.priceWithDiscount != null || item.assortment.currentPrice != null) &&
                              item.assortment.quantityInStore != null) {
                            productModelForOrderRequestList.add(ProductModelForOrderRequest(
                                assortmentUuid: item.assortment.uuid, quantity: item.quantity));
                          }
                        }
                      }
                    }

                    if (state is BasketLoadedState) {
                      _setProductsForCalculation();
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<OrderCalculateBloc, OrderCalculateState>(
                            builder: (context, calculateState) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  calculateState.orderCalculateResponseModel != null
                                      ? calculateState.orderCalculateResponseModel.data.products.length == 1
                                          ? "Всего: 1 товар"
                                          : calculateState.orderCalculateResponseModel.data.products.length > 1 &&
                                                  calculateState.orderCalculateResponseModel.data.products.length < 5
                                              ? "Всего: ${calculateState.orderCalculateResponseModel.data.products.length} товара"
                                              : "Всего: ${calculateState.orderCalculateResponseModel.data.products.length} товаров"
                                      : "",
                                  style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context)),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: heightRatio(size: 15, context: context)),
                          ListView.builder(
                            padding: EdgeInsets.only(
                                left: widthRatio(size: 15, context: context),
                                right: widthRatio(size: 15, context: context)),
                            itemCount: state.basketListModel.data.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return BlocBuilder<BasketListBloc, BasketState>(
                                buildWhen: (previous, current) {
                                  if (previous is BasketLoadedState && current is BasketLoadedState) {
                                    return index < current.basketListModel.data.length &&
                                        previous.basketListModel.data[index] != current.basketListModel.data[index];
                                  }
                                  return false;
                                },
                                builder: (context, basketState) {
                                  if (basketState is BasketLoadedState) {
                                    if (index >= basketState.basketListModel.data.length) {
                                      return SizedBox(); // Защита от выхода за пределы списка
                                    }
                                    final item = basketState.basketListModel.data[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          new CupertinoPageRoute(
                                            builder: (context) => RedesProductDetailsPage(
                                              isFromBasket: true,
                                              productUuid: item.assortment.uuid,
                                            ),
                                          ),
                                        );
                                      },
                                      child: BasketListItem(
                                        addOrSubtractBonusesState: addOrSubtractBonusesState,
                                        basketListBloc: _basketListBloc,
                                        index: index,
                                        item: item,
                                        orderCalculateBloc: _orderCalculateBloc,
                                        selectedPayCardAndAddressForOrderState: selectedPayCardAndAddressForOrderState,
                                        state: state,
                                        productModelForOrderRequestList: productModelForOrderRequestList,
                                        orderDeliveryTypeId: orderDeliveryTypeId,
                                        subtractBonuses: subtractBonuses,
                                      ),
                                    );
                                  }
                                  return SizedBox();
                                },
                              );
                            },
                          ),
                          // SizedBox(height: heightRatio(size: 8, context: context)),
                          BlocBuilder<OrderCalculateBloc, OrderCalculateState>(
                            builder: (context, calculateState) {
                              String appliedPromoCode = calculateState is OrderCalculateLoadedState &&
                                      calculateState.orderCalculateResponseModel?.data?.promocode != null
                                  ? calculateState.orderCalculateResponseModel.data.promocode
                                  : null;

                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Общая сумма:',
                                            style: appLabelTextStyle(
                                                fontSize: heightRatio(size: 16, context: context),
                                                color: Colors.black)),
                                        Spacer(),
                                        if (state.orderCalculateResponseModel != null &&
                                            state.orderCalculateResponseModel.data.totalDiscountForProducts > 0)
                                          Stack(
                                            //цена перечеркнутая
                                            alignment: Alignment.center,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: (state.orderCalculateResponseModel.data
                                                                  .totalDiscountForProducts +
                                                              state.orderCalculateResponseModel.data
                                                                  .totalPriceForProductsWithDiscount)
                                                          .toStringAsFixed(0),
                                                      style: appLabelTextStyle(
                                                          fontSize: heightRatio(size: 12, context: context),
                                                          color: newGrey),
                                                    ),
                                                    TextSpan(
                                                      text: " ${"rubleSignText".tr()}",
                                                      style: appTextStyle(
                                                          fontSize: heightRatio(size: 12, context: context),
                                                          color: newGrey,
                                                          fontWeight: FontWeight.w700),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                right: 0,
                                                bottom: 0,
                                                child: Image.asset("assets/images/line_through_image.png",
                                                    fit: BoxFit.contain),
                                              )
                                            ],
                                          ),
                                        SizedBox(width: widthRatio(size: 16, context: context)),
                                        if (state.orderCalculateResponseModel != null)
                                          RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: appliedPromoCode != null
                                                      ? calculateState.orderCalculateResponseModel.data
                                                          .totalPriceForProductsWithDiscount
                                                          .toStringAsFixed(0)
                                                      : state.orderCalculateResponseModel.data
                                                          .totalPriceForProductsWithDiscount
                                                          .toStringAsFixed(0),
                                                  style: appHeadersTextStyle(
                                                      fontSize: heightRatio(size: 16, context: context)),
                                                ),
                                                TextSpan(
                                                  text: ' ${"rubleSignText".tr()}',
                                                  style: appTextStyle(
                                                      fontSize: heightRatio(size: 16, context: context),
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: heightRatio(size: 24, context: context)),
                                  // if (appliedPromoCode != null)
                                  // Padding(
                                  //   padding: EdgeInsets.symmetric(horizontal: 16),
                                  //   child: ClipPath(
                                  //     clipper: BannerClipper(),
                                  //     child: Container(
                                  //       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                                  //       color: newBlack,
                                  //       child: Row(
                                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //         children: [
                                  //           Expanded(
                                  //             child: RichText(
                                  //               text: TextSpan(
                                  //                 children: [
                                  //                   TextSpan(
                                  //                     text: 'Применен промокод: ',
                                  //                     style: appLabelTextStyle(
                                  //                         fontSize: heightRatio(size: 14, context: context),
                                  //                         color: Colors.white),
                                  //                   ),
                                  //                   TextSpan(
                                  //                     text: ' $appliedPromoCode',
                                  //                     style: appTextStyle(
                                  //                         fontSize: heightRatio(size: 14, context: context),
                                  //                         color: Colors.white,
                                  //                         fontWeight: FontWeight.w700),
                                  //                   )
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           TextButton(
                                  //             onPressed: () {
                                  //               _orderCalculateBloc.updatePromoCode(null);
                                  //               BlocProvider.of<BasketListBloc>(context)
                                  //                   .add(BasketLoadEvent()); // Обновляем корзину
                                  //             },
                                  //             child: Text(
                                  //               'Отменить',
                                  //               style: TextStyle(
                                  //                 color: Colors.white,
                                  //                 fontSize: heightRatio(size: 12, context: context),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  if (appliedPromoCode != null)
                                    Padding(
                                      padding: EdgeInsets.only(bottom: heightRatio(size: 16, context: context)),
                                      child: Row(
                                        children: [
                                          SizedBox(width: widthRatio(size: 16, context: context)),
                                          Text(
                                            'Применен промокод: ',
                                            style: appLabelTextStyle(
                                                fontSize: heightRatio(size: 16, context: context), color: Colors.black),
                                          ),
                                          Text(
                                            ' $appliedPromoCode',
                                            style: appTextStyle(
                                                fontSize: heightRatio(size: 16, context: context),
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  GestureDetector(
                                    onTap: () {
                                      if (appliedPromoCode != null) {
                                        _orderCalculateBloc.updatePromoCode(null);
                                        BlocProvider.of<BasketListBloc>(context).add(BasketLoadEvent());
                                      } else {
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
                                              bool isPromoCodeSend = false;
                                              double bottomSizedBox = MediaQuery.of(bc).viewInsets.bottom > 0
                                                  ? 0
                                                  : heightRatio(size: 24, context: context);
                                              return BlocListener<OrderCalculateBloc, OrderCalculateState>(
                                                listener: (context, orderCalcState) {
                                                  if (orderCalcState is OrderCalculateLoadedState &&
                                                      orderCalcState.orderCalculateResponseModel?.data?.promocode !=
                                                          null) {
                                                    Navigator.pop(context);
                                                    BlocProvider.of<BasketListBloc>(context)
                                                        .add(BasketLoadEvent()); // Обновляем корзину
                                                    String appliedPromoCode =
                                                        orderCalcState.orderCalculateResponseModel?.data?.promocode;
                                                    AppAlert.show(
                                                      context: context,
                                                      message: 'Промокод “$appliedPromoCode” успешно применен',
                                                      sec: 8,
                                                      isPushToContactsWidget: true,
                                                      svgName: 'promocode_percent.svg',
                                                    );
                                                  }
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom: MediaQuery.of(context).viewInsets.bottom,
                                                    left: widthRatio(size: 22, context: context),
                                                    right: widthRatio(size: 22, context: context),
                                                  ),
                                                  child: BlocBuilder<OrderCalculateBloc, OrderCalculateState>(
                                                    builder: (context, orderCalculateState) {
                                                      return Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: heightRatio(size: 25, context: context)),
                                                          Center(
                                                            child: Text('Активировать промокод',
                                                                style: appHeadersTextStyle(
                                                                    fontSize: heightRatio(size: 20, context: context),
                                                                    color: newBlack),
                                                                textAlign: TextAlign.center),
                                                          ),
                                                          SizedBox(height: heightRatio(size: 24, context: context)),
                                                          Text('Введите промокод для активации',
                                                              style: appLabelTextStyle(
                                                                  fontSize: heightRatio(size: 15, context: context),
                                                                  color: grey6D6D6D)),
                                                          SizedBox(height: heightRatio(size: 16, context: context)),
                                                          Container(
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal: widthRatio(size: 16, context: context)),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(color: grey04, width: 1),
                                                                borderRadius: BorderRadius.circular(5)),
                                                            child: TextField(
                                                              // textCapitalization: TextCapitalization.sentences,
                                                              style: appTextStyle(
                                                                  fontSize: heightRatio(size: 18, context: context)),
                                                              controller: _promoCodeController,
                                                              decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                hintText: "Введите промокод для активации",
                                                                hintStyle: appTextStyle(
                                                                    fontSize: heightRatio(size: 18, context: context),
                                                                    color: colorBlack03),
                                                              ),
                                                            ),
                                                          ),
                                                          if (orderCalculateState is OrderCalculateLoadedState &&
                                                              (orderCalculateState.orderCalculateResponseModel?.data
                                                                          ?.promocode ==
                                                                      null &&
                                                                  _promoCodeController.text.isNotEmpty &&
                                                                  isPromoCodeSend))
                                                            Text('Неверный или устаревший промокод',
                                                                style: appLabelTextStyle(
                                                                    fontSize: heightRatio(size: 15, context: context),
                                                                    color: newRedDark)),
                                                          SizedBox(height: heightRatio(size: 16, context: context)),
                                                          InkWell(
                                                            onTap: () async {
                                                              String promoCode = _promoCodeController.text.trim();
                                                              isPromoCodeSend = true;
                                                              _orderCalculateBloc.updatePromoCode(promoCode);
                                                              _orderCalculateBloc.add(
                                                                OrderCalculateLoadEvent(
                                                                  orderDeliveryTypeId: "delivery",
                                                                  orderPaymentTypeId: "online",
                                                                  productModelForOrderRequestList:
                                                                      productModelForOrderRequestList,
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              alignment: Alignment.center,
                                                              padding: EdgeInsets.only(
                                                                  top: heightRatio(size: 15, context: context),
                                                                  bottom: heightRatio(size: 18, context: context)),
                                                              width: MediaQuery.of(context).size.width,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  color: newRedDark),
                                                              child: Text(
                                                                'Применить',
                                                                style: appLabelTextStyle(
                                                                    fontSize: heightRatio(size: 18, context: context),
                                                                    color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: bottomSizedBox),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            }).then((value) {
                                          context.read<BasketListBloc>().add(BasketLoadEvent());
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: DashedBorderContainer(
                                        color: newBlack,
                                        dashWidth: 6,
                                        dashSpace: 3,
                                        padding: EdgeInsets.all(12),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              appliedPromoCode == null ? 'ВВЕДИТЕ ПРОМОКОД' : 'ОТМЕНИТЬ ПРОМОКОД',
                                              style: appHeadersTextStyle(
                                                fontSize: heightRatio(size: 16, context: context),
                                              ),
                                            ),
                                            Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20), color: redE60D2E),
                                              child: SvgPicture.asset(
                                                appliedPromoCode == null
                                                    ? "assets/images/coupon_arrow.svg"
                                                    : "assets/images/coupon_close.svg",
                                                height: heightRatio(size: 18, context: context),
                                                width: widthRatio(size: 21, context: context),
                                                fit: BoxFit.scaleDown,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),

                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text('Скидка по акциям', style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: Colors.black)),
                          //       if (state.orderCalculateResponseModel != null)
                          //         RichText(
                          //           text: TextSpan(
                          //             children: <TextSpan>[
                          //               TextSpan(
                          //                 text: state.orderCalculateResponseModel.data.totalDiscountForProducts.toStringAsFixed(0),
                          //                 style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context)),
                          //               ),
                          //               TextSpan(
                          //                 text: ' ${"rubleSignText".tr()}',
                          //                 style: appTextStyle(fontSize: heightRatio(size: 16, context: context), color: Colors.black, fontWeight: FontWeight.bold),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 16),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text('Доставка', style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: Colors.black)),
                          //       if (state.orderCalculateResponseModel != null)
                          //         RichText(
                          //           text: TextSpan(
                          //             children: <TextSpan>[
                          //               TextSpan(
                          //                 text: state.orderCalculateResponseModel.data.deliveryPrice.toStringAsFixed(0),
                          //                 style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context)),
                          //               ),
                          //               TextSpan(
                          //                 text: ' ${"rubleSignText".tr()}',
                          //                 style: appTextStyle(fontSize: heightRatio(size: 16, context: context), color: Colors.black, fontWeight: FontWeight.bold),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //     ],
                          //   ),
                          // ),
                          // BasketTotal(),
                        ],
                      );
                    }

                    if (state is BasketEmptyState) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart,
                                color: colorBlack03, size: heightRatio(size: 70, context: context)),
                            SizedBox(height: heightRatio(size: 10, context: context)),
                            Text("emptyBasketText".tr(),
                                textAlign: TextAlign.center,
                                style: appHeadersTextStyle(
                                    fontSize: heightRatio(size: 22, context: context),
                                    color: colorBlack06,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      );
                    }
                    if (state is BasketLoadingState) {
                      return Container(
                        height: heightRatio(size: 384, context: context),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(newRedDark)),
                      );
                    }
                    if (state is BasketErrorState) {
                      return Container(
                        height: heightRatio(size: 100, context: context),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
                              decoration: BoxDecoration(color: colorBlack03, shape: BoxShape.circle),
                              child: SvgPicture.asset('assets/images/netErrorIcon.svg',
                                  color: Colors.white, height: heightRatio(size: 30, context: context)),
                            ),
                            SizedBox(height: heightRatio(size: 15, context: context)),
                            Text("errorText".tr(),
                                style: appHeadersTextStyle(
                                    fontSize: heightRatio(size: 18, context: context),
                                    color: colorBlack06,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: heightRatio(size: 10, context: context)),
                            InkWell(
                              onTap: () => _basketListBloc.add(BasketLoadEvent()),
                              child: Container(
                                color: Colors.transparent,
                                child: Text("tryAgainText".tr(),
                                    style: appHeadersTextStyle(
                                        fontSize: heightRatio(size: 14, context: context),
                                        color: mainColor,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(height: 100, alignment: Alignment.center, child: Text("errorText".tr()));
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void initSlidableAnimation({BuildContext context}) async {
    if (await prefs.getBool("hasBasketListIn") == null || await prefs.getBool("hasBasketListIn") == false) {
      prefs.setBool("hasBasketListIn", true);
      final slidable = Slidable.of(context);
      slidable.open(actionType: SlideActionType.secondary);
      Timer(Duration(milliseconds: 1500), () => slidable.close());
    }
  }
}

class BannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final middleY = size.height / 2;
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - 20, middleY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(20, middleY);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
