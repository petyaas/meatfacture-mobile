import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/order_calculate_bloc.dart';
import 'package:smart/bloc_files/order_created_bloc.dart';
import 'package:smart/custom_widgets/order_created_bottom_sheet.dart';
import 'package:smart/models/product_model_for_order_request.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class OrderCalculateBottomSheet extends StatelessWidget {
  final String clientCreditCardUuid;
  final String address;
  final String clientComment;
  final String clientEmail;
  final int floor;
  final int entrance;
  final int apartmentNumber;
  final String intercomCode;
  final String plannedDeliveryDatetimeFrom;
  final String plannedDeliveryDatetimeTo;
  final String orderDeliveryTypeId;
  final String orderPaymentTypeId;
  final List<ProductModelForOrderRequest> productModelForOrderRequestList;

  const OrderCalculateBottomSheet({
    @required this.address,
    @required this.clientComment,
    @required this.clientEmail,
    @required this.floor,
    @required this.entrance,
    @required this.apartmentNumber,
    @required this.intercomCode,
    @required this.plannedDeliveryDatetimeFrom,
    @required this.plannedDeliveryDatetimeTo,
    @required this.orderDeliveryTypeId,
    @required this.orderPaymentTypeId,
    @required this.productModelForOrderRequestList,
    @required this.clientCreditCardUuid,
  });
  @override
  Widget build(BuildContext context) {
    void _openOrderCreateBottomSheet() {
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
            return Wrap(children: [OrderCreatedBottomSheet()]);
          }).then(
        (value) => Navigator.pop(context),
      );
    }

    // ignore: close_sinks
    OrderCreatedBloc _orderCreatedBloc = BlocProvider.of<OrderCreatedBloc>(context);
    return BlocBuilder<OrderCalculateBloc, OrderCalculateState>(
      builder: (context, state) {
        if (state is OrderCalculateLoadingState) {
          return Container(
            height: heightRatio(size: 320, context: context),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
              ),
            ),
          );
        }
        if (state is OrderCalculateLoadedState) {
          return Container(
              padding: EdgeInsets.all(widthRatio(size: 20, context: context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Подтверждение стоимости",
                    style: appHeadersTextStyle(fontSize: heightRatio(size: 21, context: context)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: heightRatio(size: 30, context: context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Товаров на сумму:",
                        style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                      ),
                      Text(
                        state.orderCalculateResponseModel.data.totalPriceForProductsWithDiscount.toString() + " " + "rubleSignText".tr(),
                        style: appTextStyle(fontWeight: FontWeight.w400, fontSize: heightRatio(size: 16, context: context)),
                      )
                    ],
                  ),
                  SizedBox(height: heightRatio(size: 15, context: context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Скидка по акциям:",
                        style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                      ),
                      Text(
                        "-" + state.orderCalculateResponseModel.data.totalDiscountForProducts.toString() + " " + "rubleSignText".tr(),
                        style: appTextStyle(fontWeight: FontWeight.w400, fontSize: heightRatio(size: 16, context: context)),
                      )
                    ],
                  ),
                  SizedBox(height: heightRatio(size: 15, context: context)),
                  //списанно баллов
                  if (state.orderCalculateResponseModel.data.paidBonus != null && state.orderCalculateResponseModel.data.paidBonus != 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Списано ${state.orderCalculateResponseModel.data.paidBonus} бонусов",
                          style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                        ),
                        Text(
                          "-" + state.orderCalculateResponseModel.data.paidBonus.toString() + " " + "rubleSignText".tr(),
                          style: appTextStyle(fontWeight: FontWeight.w400, fontSize: heightRatio(size: 16, context: context)),
                        )
                      ],
                    ),

                  SizedBox(height: heightRatio(size: 15, context: context)),
                  if (state.orderCalculateResponseModel.data.orderDeliveryTypeId == "delivery")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Доставка:',
                          style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                        ),
                        Text(
                          state.orderCalculateResponseModel.data.deliveryPrice.toString() + " " + "rubleSignText".tr(),
                          style: appTextStyle(fontWeight: FontWeight.w400, fontSize: heightRatio(size: 16, context: context)),
                        )
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "pickupText".tr(),
                          style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                        ),
                        Text(
                          "forFreeText".tr(),
                          style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                        )
                      ],
                    ),

                  SizedBox(height: heightRatio(size: 15, context: context)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "totalText".tr() + ":",
                        style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), color: newBlack),
                      ),
                      Text(
                        state.orderCalculateResponseModel.data.totalPrice.toString() + " " + "rubleSignText".tr(),
                        style: appTextStyle(fontWeight: FontWeight.w700, fontSize: heightRatio(size: 18, context: context)),
                      )
                    ],
                  ),
                  SizedBox(height: heightRatio(size: 35, context: context)),
                  InkWell(
                    onTap: () {
                      _orderCreatedBloc.add(
                        OrderCreatedLoadEvent(
                          subtractBonusesCount:
                              state.orderCalculateResponseModel.data.paidBonus == null || state.orderCalculateResponseModel.data.paidBonus == 0
                                  ? null
                                  : state.orderCalculateResponseModel.data.paidBonus,
                          clientCreditCardUuid: clientCreditCardUuid,
                          address: address,
                          clientComment: clientComment,
                          clientEmail: clientEmail,
                          floor: floor,
                          entrance: entrance,
                          apartmentNumber: apartmentNumber,
                          intercomCode: intercomCode,
                          plannedDeliveryDatetimeFrom: plannedDeliveryDatetimeFrom,
                          plannedDeliveryDatetimeTo: plannedDeliveryDatetimeTo,
                          orderDeliveryTypeId: orderDeliveryTypeId,
                          orderPaymentTypeId: orderPaymentTypeId,
                          productModelForOrderRequestList: productModelForOrderRequestList,
                        ),
                      );
                      _openOrderCreateBottomSheet();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                      child: Text("Подтвердить", style: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: heightRatio(size: 30, context: context)),
                ],
              ));
        }

        return Container(
          // height: heightRatio(size: 320, context: context),
          child: Center(child: Text("errorText".tr())),
        );
      },
    );
  }
}
