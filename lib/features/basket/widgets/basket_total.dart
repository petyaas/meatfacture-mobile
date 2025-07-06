import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/order_calculate_bloc.dart';
import 'package:smart/custom_widgets/shimmer_for_calculate_in_basket.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class BasketTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: widthRatio(size: 15, context: context), right: widthRatio(size: 15, context: context)),
      child: BlocBuilder<OrderCalculateBloc, OrderCalculateState>(
        builder: (context, calculateState) {
          if (calculateState is OrderCalculateErrorState) {
            return Row(
              children: [
                Container(
                  height: heightRatio(size: 52, context: context),
                  width: widthRatio(size: 52, context: context),
                  decoration: BoxDecoration(
                    color: newRedDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.info_outline, color: Colors.white, size: heightRatio(size: 35, context: context)),
                ),
                SizedBox(width: widthRatio(size: 13, context: context)),
                Flexible(
                  child: Text(
                    'В данном магазине товаров в наличии нет, вернитесь пожалуйста назад чтобы пересмотреть товары или выберите другой магазин',
                    style: appLabelTextStyle(color: newBlack, fontSize: heightRatio(size: 13, context: context), height: heightRatio(size: 1.2, context: context)),
                  ),
                ),
              ],
            );
          }
          if (calculateState is OrderCalculateLoadingState) {
            return Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor)),
            );
          }
          if (calculateState is OrderCalculateLoadedState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "${"goodsupperFirstText".tr()} ${calculateState.orderCalculateResponseModel.data.products.length} (${calculateState.orderCalculateResponseModel.data.totalWeight >= 0.5 ? (calculateState.orderCalculateResponseModel.data.totalWeight / 1000).toStringAsFixed(2) + "kgText".tr() : calculateState.orderCalculateResponseModel.data.totalWeight.toStringAsFixed(0) + "grText".tr()})",
                        style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                      ),
                    ), // Товаров 1 (1.50 кг)
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: calculateState.orderCalculateResponseModel.data.totalPriceForProductsWithDiscount.toString(),
                          style: appHeadersTextStyle(color: newBlack, fontSize: heightRatio(size: 16, context: context)),
                        ),
                        TextSpan(
                          text: " ${"rubleSignText".tr()}",
                          style: appTextStyle(color: newBlack, fontWeight: FontWeight.w800, fontSize: heightRatio(size: 16, context: context)),
                        )
                      ]),
                    )
                  ],
                ),
                SizedBox(height: heightRatio(size: 8, context: context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "DiscountOnPromotionsText".tr(),
                      style: appLabelTextStyle(color: newBlack, fontSize: heightRatio(size: 16, context: context)),
                    ), // скидка по акциям
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: calculateState.orderCalculateResponseModel.data.totalDiscountForProducts.toString(),
                          style: appHeadersTextStyle(color: newBlack, fontSize: heightRatio(size: 16, context: context)),
                        ),
                        TextSpan(
                          text: " ${"rubleSignText".tr()}",
                          style: appTextStyle(color: newBlack, fontWeight: FontWeight.w700, fontSize: heightRatio(size: 16, context: context)),
                        )
                      ]),
                    )
                  ],
                ),
                if (calculateState.orderCalculateResponseModel.data.orderDeliveryTypeId == "delivery") SizedBox(height: heightRatio(size: 8, context: context)),
                if (calculateState.orderCalculateResponseModel.data.orderDeliveryTypeId == "delivery")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Доставка',
                        style: appLabelTextStyle(color: newBlack, fontSize: heightRatio(size: 16, context: context)),
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: calculateState.orderCalculateResponseModel.data.deliveryPrice.toString(),
                            style: appHeadersTextStyle(color: newBlack, fontSize: heightRatio(size: 16, context: context)),
                          ),
                          TextSpan(
                            text: " ${"rubleSignText".tr()}",
                            style: appTextStyle(color: newBlack, fontWeight: FontWeight.w700, fontSize: heightRatio(size: 16, context: context)),
                          )
                        ]),
                      )
                    ],
                  ),
                SizedBox(height: heightRatio(size: 16, context: context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Итого к оплате",
                      style: appHeadersTextStyle(color: newBlack, fontSize: heightRatio(size: 16, context: context)),
                    ), // Доставка
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: calculateState.orderCalculateResponseModel.data.totalPrice.toString(),
                          style: appHeadersTextStyle(color: newBlack, fontSize: heightRatio(size: 16, context: context)),
                        ),
                        TextSpan(
                          text: " ${"rubleSignText".tr()}",
                          style: appTextStyle(color: newBlack, fontWeight: FontWeight.w700, fontSize: heightRatio(size: 16, context: context)),
                        )
                      ]),
                    )
                  ],
                ),
                SizedBox(height: heightRatio(size: 15, context: context)),
                Divider(),
              ],
            );
          }

          return ShimmerforCalculateInBasket(countStr: calculateState.orderCalculateResponseModel.data.orderDeliveryTypeId == "delivery" ? 2 : 3);
        },
      ),
    );
  }
}
