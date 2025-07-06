import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc_files/order_calculate_bloc.dart';
import 'package:smart/bloc_files/order_type_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/main.dart';

bool isFirst = true;

class ToFreeDeliveryWidget extends StatefulWidget {
  final bool isfromCatalog;

  const ToFreeDeliveryWidget({Key key, this.isfromCatalog = true}) : super(key: key);

  @override
  State<ToFreeDeliveryWidget> createState() => _ToFreeDeliveryWidgetState();
}

class _ToFreeDeliveryWidgetState extends State<ToFreeDeliveryWidget> {
  String orderDeliveryTypeId = 'pickup';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderTypeBloc, OrderTypeState>(
      builder: (context, orderTypeState) {
        if (orderTypeState is OrderTypeDeliveryState) {
          orderDeliveryTypeId = "delivery";
        }
        log('⭐️ orderDeliveryTypeId из ToFreeDeliveryWidget = $orderDeliveryTypeId');
        return BlocBuilder<BasketListBloc, BasketState>(
          builder: (context, basketState) {
            if (basketState is BasketEmptyState) {
              return SizedBox.shrink();
            }
            if (widget.isfromCatalog) {
              if (basketState is BasketLoadedState) {
                if (basketState.productModelForOrderRequestList.isEmpty) {
                  BasketListBloc _basketListBloc = BlocProvider.of(context);
                  _basketListBloc.add(BasketLoadEvent());
                } else {
                  if (isFirst) {
                    print('BasketLoadedState stateeeeee event ');
                    OrderCalculateBloc _orderCalculateBloc = BlocProvider.of<OrderCalculateBloc>(context);
                    _orderCalculateBloc.add(OrderCalculateLoadEvent(
                      orderDeliveryTypeId: orderDeliveryTypeId,
                      orderPaymentTypeId: "online",
                      productModelForOrderRequestList: basketState.productModelForOrderRequestList,
                    ));
                    print('PRDUCTSSS --- ${basketState.productModelForOrderRequestList}');
                    isFirst = false;
                  }
                }
              }
              return BlocBuilder<OrderCalculateBloc, OrderCalculateState>(
                builder: (context, state) {
                  print('OrderCalculateBloc stateeeeee $state ');
                  if (state is OrderCalculateLoadedState) {
                    double totalPriceForProductsWithDiscountInCart = prefs.getDouble(SharedKeys.totalPriceForProductsWithDiscount);
                    return state.orderCalculateResponseModel.data.toFreeDelivery == null || state.orderCalculateResponseModel.data.toFreeDelivery == 0.0
                        ? InkWell(
                            onTap: () => BlocProvider.of<SecondaryPageBloc>(context).add(BasketPageLoadEvent()),
                            child: Container(
                              width: double.maxFinite,
                              height: heightRatio(size: 60, context: context),
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                left: widthRatio(size: 17, context: context),
                                right: widthRatio(size: 17, context: context),
                                bottom: heightRatio(size: 4, context: context),
                              ),
                              decoration: BoxDecoration(
                                color: newRedDark,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(widthRatio(size: 16, context: context)),
                                  topLeft: Radius.circular(widthRatio(size: 16, context: context)),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/images/green_select_circle.svg", height: heightRatio(size: 14, context: context)),
                                  SizedBox(width: widthRatio(size: 6, context: context)),
                                  Text(
                                    "free_delivery".tr(),
                                    style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: whiteColor),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            height: heightRatio(size: 80, context: context),
                            child: InkWell(
                              onTap: () => BlocProvider.of<SecondaryPageBloc>(context).add(BasketPageLoadEvent()),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      height: heightRatio(size: 80, context: context),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                        left: widthRatio(size: 17, context: context),
                                        right: widthRatio(size: 17, context: context),
                                        bottom: heightRatio(size: 55, context: context),
                                      ),
                                      decoration: BoxDecoration(
                                        color: newBlack,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(widthRatio(size: 16, context: context)),
                                          topLeft: Radius.circular(widthRatio(size: 16, context: context)),
                                        ),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Еще ',
                                              style: appLabelTextStyle(fontSize: heightRatio(size: 10, context: context), color: whiteColor),
                                            ),
                                            TextSpan(
                                              text: '${state.orderCalculateResponseModel.data.toFreeDelivery.removeAfterPointNulles()} руб',
                                              style: appHeadersTextStyle(fontSize: heightRatio(size: 10, context: context), color: whiteColor),
                                            ),
                                            TextSpan(
                                              text: ' до бесплатной доставки',
                                              style: appLabelTextStyle(fontSize: heightRatio(size: 10, context: context), color: whiteColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      height: heightRatio(size: 54, context: context),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                        left: widthRatio(size: 17, context: context),
                                        right: widthRatio(size: 17, context: context),
                                        bottom: heightRatio(size: 6, context: context),
                                      ),
                                      decoration: BoxDecoration(
                                        color: newRedDark,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(widthRatio(size: 16, context: context)),
                                          topLeft: Radius.circular(widthRatio(size: 16, context: context)),
                                        ),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  'Перейти в корзину - ${totalPriceForProductsWithDiscountInCart % 1 == 0 ? totalPriceForProductsWithDiscountInCart.toInt() : totalPriceForProductsWithDiscountInCart}',
                                              style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: whiteColor),
                                            ),
                                            TextSpan(
                                              text: ' ₽',
                                              style: appTextStyle(
                                                  fontSize: heightRatio(size: 14, context: context), color: whiteColor, fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                  }
                  if (state is OrderCalculateErrorState) {
                    return Container(
                      width: double.maxFinite,
                      height: heightRatio(size: 60, context: context),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        left: widthRatio(size: 17, context: context),
                        right: widthRatio(size: 17, context: context),
                        bottom: heightRatio(size: 4, context: context),
                      ),
                      decoration: BoxDecoration(
                        color: newRedDark,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(widthRatio(size: 16, context: context)),
                          topLeft: Radius.circular(widthRatio(size: 16, context: context)),
                        ),
                      ),
                      child: DefaultTextStyle(
                        textAlign: TextAlign.center,
                        style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: whiteColor),
                        child: Text('Ошибка'),
                      ),
                    );
                  }
                  //Загрузка1:
                  return Container(
                    width: double.maxFinite,
                    height: heightRatio(size: 60, context: context),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                      left: widthRatio(size: 17, context: context),
                      right: widthRatio(size: 17, context: context),
                      bottom: heightRatio(size: 4, context: context),
                    ),
                    decoration: BoxDecoration(
                      color: newRedDark,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(widthRatio(size: 16, context: context)),
                        topLeft: Radius.circular(widthRatio(size: 16, context: context)),
                      ),
                    ),
                    child: DefaultTextStyle(
                      textAlign: TextAlign.center,
                      style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: whiteColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Загрузка'),
                          AnimatedTextKit(animatedTexts: [TyperAnimatedText('...')], isRepeatingAnimation: true),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(bottom: heightRatio(size: 10, context: context)),
                child: BlocBuilder<OrderCalculateBloc, OrderCalculateState>(
                  builder: (context, state) {
                    if (state is OrderCalculateLoadedState) {
                      return state.orderCalculateResponseModel.data.toFreeDelivery == null || state.orderCalculateResponseModel.data.toFreeDelivery == 0.0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/green_select_circle.svg",
                                  height: heightRatio(size: 14, context: context),
                                ),
                                SizedBox(width: widthRatio(size: 6, context: context)),
                                Text(
                                  "free_delivery".tr(),
                                  style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context)),
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/delivery_bike.svg",
                                  color: mainColor,
                                  height: heightRatio(size: 14, context: context),
                                ),
                                Text(
                                  tr('sum_to_free_delivery', args: [state.orderCalculateResponseModel.data.toFreeDelivery.removeAfterPointNulles().toString()]),
                                  style: appHeadersTextStyle(
                                    fontSize: heightRatio(size: 14, context: context),
                                  ),
                                ),
                                SizedBox(width: widthRatio(size: 14, context: context))
                              ],
                            );
                    }
                    return DefaultTextStyle(
                      textAlign: TextAlign.center,
                      style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: whiteColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Загрузка'),
                          AnimatedTextKit(
                            animatedTexts: [TyperAnimatedText('...')],
                            isRepeatingAnimation: true,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          },
        );
      },
    );
  }
}
