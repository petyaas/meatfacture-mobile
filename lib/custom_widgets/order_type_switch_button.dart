// ignore: implementation_imports
import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/add_or_subtract_bonuses_bloc.dart';
import 'package:smart/bloc_files/order_calculate_bloc.dart';
import 'package:smart/bloc_files/order_type_bloc.dart';
import 'package:smart/models/product_model_for_order_request.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class OrderTypeSwitchButton extends StatelessWidget {
  final AddOrSubtractBonusesState addOrSubtractBonusesState;
  final int subtractBonuses;
  final String paymentTypeChoose;
  final List<ProductModelForOrderRequest> productModelForOrderRequestList;

  const OrderTypeSwitchButton({Key key, this.addOrSubtractBonusesState, this.subtractBonuses, this.paymentTypeChoose, this.productModelForOrderRequestList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderTypeBloc _orderTypeBloc = BlocProvider.of<OrderTypeBloc>(context);
    AddOrSubtractBonusesBloc _addOrSubtractBonusesBloc = BlocProvider.of(context);
    OrderCalculateBloc _orderCalculateBloc = BlocProvider.of(context);

    return BlocBuilder<OrderTypeBloc, OrderTypeState>(
      builder: (context, state) {
        if (state is OrderTypePickupState) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context)),
            child: Container(
              height: 40,
              decoration: BoxDecoration(color: grey04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (state is! OrderTypeDeliveryState) {
                          _orderTypeBloc.add(OrderTypeDeliveryEvent());
                          _addOrSubtractBonusesBloc.add(AddBonusesEvent());
                          _orderCalculateBloc.add(
                            OrderCalculateLoadEvent(
                              orderDeliveryTypeId: "delivery",
                              orderPaymentTypeId: paymentTypeChoose,
                              productModelForOrderRequestList: productModelForOrderRequestList,
                            ),
                          );
                          log("-------------------------------- нажали на ------ delivery ---------------------------------------");
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Text(
                          'Доставка',
                          textAlign: TextAlign.center,
                          style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(-3, 4), blurRadius: 10, spreadRadius: 0)],
                        borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context)),
                        color: newRedDark,
                      ),
                      child: Text(
                        'pickupText'.tr(),
                        style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: whiteColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return ClipRRect(
            borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context)),
            child: Container(
              height: 40,
              decoration: BoxDecoration(color: grey04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(-3, 4), blurRadius: 10, spreadRadius: 0)],
                        borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context)),
                        color: newRedDark,
                      ),
                      child: Text(
                        'Доставка',
                        style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: whiteColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (state is! OrderTypePickupState) {
                          _orderTypeBloc.add(OrderTypePickupEvent());
                          _addOrSubtractBonusesBloc.add(AddBonusesEvent());
                          _orderCalculateBloc.add(
                            OrderCalculateLoadEvent(
                              orderDeliveryTypeId: "pickup",
                              orderPaymentTypeId: paymentTypeChoose,
                              productModelForOrderRequestList: productModelForOrderRequestList,
                            ),
                          );
                          log("------------------------------ нажали на -------- pickup ---------------------------------------");
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Text(
                          'pickupText'.tr(),
                          textAlign: TextAlign.center,
                          style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
