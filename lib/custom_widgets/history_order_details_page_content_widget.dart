// ignore: implementation_imports
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc_files/hisory_oder_details_bloc.dart';
import 'package:smart/custom_widgets/send_mark_for_product_bottom_sheet.dart';
import 'package:smart/custom_widgets/shimmer_history_check_details_loader.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/utils/custom_cache_manager.dart';

import '../pages/redesigned_pages/redes_product_details_page.dart';

class HistoryOrderDetailsPageContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void openSendMarkForProductBottomSheet({String checkLineUuid, String checkUuid, double rating, String comment}) {
      showModalBottomSheet<dynamic>(
        isScrollControlled: false,
        context: context,
        useSafeArea: true,
        useRootNavigator: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(heightRatio(size: 25, context: context)),
            topRight: Radius.circular(heightRatio(size: 25, context: context)),
          ),
        ),
        builder: (BuildContext bc) {
          return Wrap(
            children: [
              SendMarkForProductBottomSheet(
                checkLineUuid: checkLineUuid,
                orderOrCheck: "order",
                comment: comment,
                rating: rating,
                checkUuid: checkUuid,
              )
            ],
          );
        },
      );
    }

    return BlocBuilder<HistoryOrdertDetailsBloc, HistoryOrderDetailsState>(
      builder: (context, state) {
        if (state is HistoryOrderDetailsLoadingState) {
          return ShimmerHistoryCheckDeatilsLoader();
        }

        if (state is HistoryOrderDetailsErrorState) {
          return Center(
            child: Text("errorText".tr()),
          );
        }

        if (state is HistoryOrderDetailsLoadedState) {
          // DateTime _plannedDeliveryDatetimeFrom = DateTime.parse(state
          //     .orderDetailsAndCalculateResponseModel
          //     .data
          //     .plannedDeliveryDatetimeFrom
          //     .replaceAll("+0300", "+0000"));

          DateTime _plannedDeliveryDatetimeTo =
              DateTime.parse(state.orderDetailsAndCalculateResponseModel.data.plannedDeliveryDatetimeTo.replaceAll("+0300", "+0000"));
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("dateAndTimeOfOrderText".tr(), style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: colorBlack04)),
                SizedBox(height: heightRatio(size: 3, context: context)),
                Text("${_plannedDeliveryDatetimeTo.toFormatedDate()}  ${_plannedDeliveryDatetimeTo.toFormatedTime()}",
                    style: appLabelTextStyle(fontSize: heightRatio(size: 18, context: context), fontWeight: FontWeight.w400, color: Colors.black)),
                SizedBox(height: heightRatio(size: 12, context: context)),
                Text("purchaseAmountText".tr(), style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: colorBlack04)),
                SizedBox(height: heightRatio(size: 3, context: context)),
                Text("${state.orderDetailsAndCalculateResponseModel.data.totalPrice} р",
                    style: appLabelTextStyle(fontSize: heightRatio(size: 18, context: context), color: Colors.black)),
                SizedBox(height: heightRatio(size: 12, context: context)),
                Text(state.orderDetailsAndCalculateResponseModel.data.orderDeliveryTypeId == "pickup" ? "storeAddressText".tr() : "Адрес доставки",
                    style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: colorBlack04)),
                SizedBox(height: heightRatio(size: 3, context: context)),
                Text(
                    state.orderDetailsAndCalculateResponseModel.data.orderDeliveryTypeId == "pickup"
                        ? state.orderDetailsAndCalculateResponseModel.data.storeUserAddress
                        : state.orderDetailsAndCalculateResponseModel.data.clientAddressData != null
                            ? "${state.orderDetailsAndCalculateResponseModel.data.clientAddressData.address}"
                            : "",
                    style: appLabelTextStyle(fontSize: heightRatio(size: 18, context: context), color: Colors.black)),
                //Charge bonuses
                if (state.orderDetailsAndCalculateResponseModel.data.bonusToCharge != null &&
                    state.orderDetailsAndCalculateResponseModel.data.bonusToCharge != 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: heightRatio(size: 12, context: context)),
                      Text(
                        "purchaseBonusesEarnedText".tr(),
                        style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: colorBlack04),
                      ),
                      SizedBox(height: heightRatio(size: 3, context: context)),
                      Text(
                        "${state.orderDetailsAndCalculateResponseModel.data.bonusToCharge} бонусов",
                        style: appLabelTextStyle(fontSize: heightRatio(size: 18, context: context), color: Colors.black),
                      ),
                    ],
                  ),

                //Paid bonuses
                if (state.orderDetailsAndCalculateResponseModel.data.paidBonus != null && state.orderDetailsAndCalculateResponseModel.data.paidBonus != 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: heightRatio(size: 12, context: context)),
                      Text("paidBonusesForThePurchaseText".tr(),
                          style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: colorBlack04)),
                      SizedBox(height: heightRatio(size: 3, context: context)),
                      Text(
                        "-${state.orderDetailsAndCalculateResponseModel.data.paidBonus} бонусов",
                        style: appLabelTextStyle(fontSize: heightRatio(size: 18, context: context), color: Colors.black),
                      ),
                    ],
                  ),
                SizedBox(height: heightRatio(size: 28, context: context)),
                Text(
                  state.orderDetailsAndCalculateResponseModel.data.orderStatusId == "done" ? 'Оцените ваши покупки' : "yourPurchasesText".tr(),
                  style: appHeadersTextStyle(fontSize: heightRatio(size: 24, context: context), color: Colors.black),
                ),
                SizedBox(height: heightRatio(size: 20, context: context)),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.orderDetailsAndCalculateResponseModel.data.products.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      //тут я не знаю откуда брать количество
                      Navigator.push(
                        context,
                        new CupertinoPageRoute(
                          builder: (context) => RedesProductDetailsPage(
                            productUuid: state.orderDetailsAndCalculateResponseModel.data.products[index].assortment.uuid,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: heightRatio(size: 10, context: context)),
                        Stack(
                          children: [
                            Card(
                              shadowColor: Colors.white,
                              elevation: 0,
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widthRatio(size: 8, context: context))),
                              color: colorBlack03,
                              child: state.orderDetailsAndCalculateResponseModel.data.products[index].assortment.images.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: state.orderDetailsAndCalculateResponseModel.data.products[index].assortment.images[0].path,
                                      cacheManager: CustomCacheManager(),
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) => Image.asset("assets/images/notImage.png", fit: BoxFit.contain),
                                      useOldImageOnUrlChange: true,
                                      height: heightRatio(size: 100, context: context),
                                      width: widthRatio(size: 89, context: context),
                                    )
                                  : Container(
                                      height: heightRatio(size: 100, context: context),
                                      width: widthRatio(size: 89, context: context),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 20, context: context))),
                                      child: Image.asset("assets/images/notImage.png", fit: BoxFit.cover),
                                    ),
                            ),
                            //product's bonuses to charge
                            // if (state.orderDetailsAndCalculateResponseModel.data.products[index].totalBonus != null)
                            //   Positioned(
                            //     bottom: widthRatio(size: 10, context: context),
                            //     left: widthRatio(size: 10, context: context),
                            //     child: Container(
                            //       decoration: BoxDecoration(
                            //         color: whiteColor,
                            //         borderRadius: BorderRadius.circular(widthRatio(size: 4, context: context)),
                            //       ),
                            //       padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 4, context: context), vertical: heightRatio(size: 2, context: context)),
                            //       child: Row(children: [
                            //         Container(
                            //           width: widthRatio(size: 15, context: context),
                            //           height: heightRatio(size: 15, context: context),
                            //           child: SvgPicture.asset('assets/images/bonus_vector.svg', width: widthRatio(size: 15, context: context), height: heightRatio(size: 15, context: context)),
                            //         ),
                            //         SizedBox(width: widthRatio(size: 3, context: context)),
                            //         Text(
                            //           state.orderDetailsAndCalculateResponseModel.data.products[index].totalBonus.removeAfterPointNulles().toString(),
                            //           style: appLabelTextStyle(fontSize: 10, color: colorBlack06),
                            //         )
                            //       ]),
                            //     ),
                            //   ),
                          ],
                        ),
                        SizedBox(width: widthRatio(size: 5, context: context)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: heightRatio(size: 2, context: context)),
                              Container(
                                height: heightRatio(size: 40, context: context),
                                alignment: Alignment.topLeft,
                                child: Text(state.orderDetailsAndCalculateResponseModel.data.products[index].assortment.name,
                                    maxLines: 3, style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: Colors.black)),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  state.orderDetailsAndCalculateResponseModel.data.orderStatusId == "done" &&
                                          state.orderDetailsAndCalculateResponseModel.data.products[index].quantity > 0
                                      ? InkWell(
                                          onTap: () {
                                            if (state.orderDetailsAndCalculateResponseModel.data.totalQuantity != 0) {
                                              openSendMarkForProductBottomSheet(
                                                comment: state.orderDetailsAndCalculateResponseModel.data.products[index].ratingComment ?? "  ",
                                                rating: state.orderDetailsAndCalculateResponseModel.data.products[index].rating != null
                                                    ? state.orderDetailsAndCalculateResponseModel.data.products[index].rating.toDouble()
                                                    : null,
                                                checkUuid: state.orderDetailsAndCalculateResponseModel.data.uuid,
                                                checkLineUuid: state.orderDetailsAndCalculateResponseModel.data.products[index].uuid,
                                              );
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                state.orderDetailsAndCalculateResponseModel.data.products[index].rating != null &&
                                                        state.orderDetailsAndCalculateResponseModel.data.products[index].rating > 0
                                                    ? 'assets/images/activeStar.svg'
                                                    : 'assets/images/star.svg',
                                                width: widthRatio(size: 20, context: context),
                                                height: heightRatio(size: 20, context: context),
                                              ),
                                              SizedBox(width: widthRatio(size: 3, context: context)),
                                              SvgPicture.asset(
                                                state.orderDetailsAndCalculateResponseModel.data.products[index].rating != null &&
                                                        state.orderDetailsAndCalculateResponseModel.data.products[index].rating > 1
                                                    ? 'assets/images/activeStar.svg'
                                                    : 'assets/images/star.svg',
                                                width: widthRatio(size: 20, context: context),
                                                height: heightRatio(size: 20, context: context),
                                              ),
                                              SizedBox(width: widthRatio(size: 3, context: context)),
                                              SvgPicture.asset(
                                                state.orderDetailsAndCalculateResponseModel.data.products[index].rating != null &&
                                                        state.orderDetailsAndCalculateResponseModel.data.products[index].rating > 2
                                                    ? 'assets/images/activeStar.svg'
                                                    : 'assets/images/star.svg',
                                                width: widthRatio(size: 20, context: context),
                                                height: heightRatio(size: 20, context: context),
                                              ),
                                              SizedBox(width: widthRatio(size: 3, context: context)),
                                              SvgPicture.asset(
                                                state.orderDetailsAndCalculateResponseModel.data.products[index].rating != null &&
                                                        state.orderDetailsAndCalculateResponseModel.data.products[index].rating > 3
                                                    ? 'assets/images/activeStar.svg'
                                                    : 'assets/images/star.svg',
                                                width: widthRatio(size: 20, context: context),
                                                height: heightRatio(size: 20, context: context),
                                              ),
                                              SizedBox(width: widthRatio(size: 3, context: context)),
                                              SvgPicture.asset(
                                                state.orderDetailsAndCalculateResponseModel.data.products[index].rating != null &&
                                                        state.orderDetailsAndCalculateResponseModel.data.products[index].rating > 4
                                                    ? 'assets/images/activeStar.svg'
                                                    : 'assets/images/star.svg',
                                                width: widthRatio(size: 20, context: context),
                                                height: heightRatio(size: 20, context: context),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox(),

                                  SizedBox(width: widthRatio(size: 10, context: context)),
                                  //price area
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        (state.orderDetailsAndCalculateResponseModel.data.products[index].originalPrice != null ||
                                                    state.orderDetailsAndCalculateResponseModel.data.products[index].price != null) &&
                                                state.orderDetailsAndCalculateResponseModel.data.products[index].uuid != null
                                            ? Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                // margin: EdgeInsets
                                                //     .only(
                                                //         right:
                                                //             15),
                                                decoration: BoxDecoration(
                                                  color: state.orderDetailsAndCalculateResponseModel.data.products[index].discountTypeColor == null
                                                      ? colorBlack03
                                                      : Color(int.parse(
                                                          "0xff${state.orderDetailsAndCalculateResponseModel.data.products[index].discountTypeColor}")),
                                                  borderRadius: BorderRadius.circular(heightRatio(size: 4, context: context)),
                                                ),
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: state.orderDetailsAndCalculateResponseModel.data.products[index].price == null
                                                            ? state.orderDetailsAndCalculateResponseModel.data.products[index].originalPrice.toStringAsFixed(2)
                                                            : state.orderDetailsAndCalculateResponseModel.data.products[index].price.toStringAsFixed(2),
                                                        style: appLabelTextStyle(
                                                          fontSize: heightRatio(size: 12, context: context),
                                                          color: (state.orderDetailsAndCalculateResponseModel.data.products[index].originalPrice != null ||
                                                                      state.orderDetailsAndCalculateResponseModel.data.products[index].price != null) &&
                                                                  state.orderDetailsAndCalculateResponseModel.data.products[index].quantity != null
                                                              ? Colors.black
                                                              : colorBlack04,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: " ₽",
                                                        style: appTextStyle(
                                                          fontSize: heightRatio(size: 12, context: context),
                                                          color: (state.orderDetailsAndCalculateResponseModel.data.products[index].originalPrice != null ||
                                                                      state.orderDetailsAndCalculateResponseModel.data.products[index].price != null) &&
                                                                  state.orderDetailsAndCalculateResponseModel.data.products[index].quantity != null
                                                              ? Colors.black
                                                              : colorBlack04,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: state.orderDetailsAndCalculateResponseModel.data.products[index].price == null
                                                            ? "/${getAssortmentUnitId(assortmentUnitId: state.orderDetailsAndCalculateResponseModel.data.products[index].assortment.assortmentUnitId ?? "")[1]}"
                                                            : "/${getAssortmentUnitId(assortmentUnitId: state.orderDetailsAndCalculateResponseModel.data.products[index].assortment.assortmentUnitId ?? "")[1]}",
                                                        style: appLabelTextStyle(
                                                          fontSize: heightRatio(size: 12, context: context),
                                                          color: (state.orderDetailsAndCalculateResponseModel.data.products[index].originalPrice != null ||
                                                                      state.orderDetailsAndCalculateResponseModel.data.products[index].price != null) &&
                                                                  state.orderDetailsAndCalculateResponseModel.data.products[index].quantity != null
                                                              ? Colors.black
                                                              : colorBlack04,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                height: heightRatio(size: 34, context: context),
                                              ),
                                        SizedBox(
                                          height: heightRatio(size: 5, context: context),
                                        ),
                                        state.orderDetailsAndCalculateResponseModel.data.products[index].discountableType != null
                                            ? Container(
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                          state.orderDetailsAndCalculateResponseModel.data.products[index].uuid != null
                                                              ? state.orderDetailsAndCalculateResponseModel.data.products[index].price != null
                                                                  ? state.orderDetailsAndCalculateResponseModel.data.products[index].originalPrice != null
                                                                      ? state.orderDetailsAndCalculateResponseModel.data.products[index].originalPrice
                                                                              .toStringAsFixed(2) +
                                                                          " ₽"
                                                                      : ""
                                                                  : ""
                                                              : "",
                                                          style: appTextStyle(
                                                            decorationColor: colorBlack04,
                                                            fontSize: heightRatio(size: 12, context: context),
                                                            color: colorBlack04,
                                                          )),
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      left: 0,
                                                      right: 0,
                                                      bottom: 0,
                                                      child: Image.asset(
                                                        "assets/images/line_through_image.png",
                                                        fit: BoxFit.contain,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : SizedBox(height: heightRatio(size: 14, context: context)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // if (state.orderDetailsAndCalculateResponseModel.data.products[index].assortment.assortmentWeight != null && state.orderDetailsAndCalculateResponseModel.data.products[index].assortment.assortmentWeight != 0)
                                  //   Text(
                                  //     state.orderDetailsAndCalculateResponseModel.data.products[index].assortment.assortmentWeight > 500
                                  //         ? "${"productWeightText".tr()}: ${(state.orderDetailsAndCalculateResponseModel.data.products[index].assortment.assortmentWeight / 1000).removeAfterPointNulles()}${"kgText".tr()}"
                                  //         : "${"productWeightText".tr()}: ${state.orderDetailsAndCalculateResponseModel.data.products[index].assortment.assortmentWeight.removeAfterPointNulles()}${"grText".tr()}",
                                  //     style: appLabelTextStyle(fontSize: heightRatio(size: 9, context: context), color: colorBlack04),
                                  //   )
                                  // else
                                  //   SizedBox(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (state.orderDetailsAndCalculateResponseModel.data.products[index].assortment.rating != null)
                                        SvgPicture.asset(
                                          "assets/images/activeStar.svg",
                                          height: heightRatio(size: 15, context: context),
                                        ),
                                      SizedBox(width: widthRatio(size: 5, context: context)),
                                      Text(
                                        state.orderDetailsAndCalculateResponseModel.data.products[index].assortment.rating != null
                                            ? state.orderDetailsAndCalculateResponseModel.data.products[index].assortment.rating.toString()
                                            : '',
                                        style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: colorBlack04),
                                      )
                                    ],
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              "x${state.orderDetailsAndCalculateResponseModel.data.products[index].quantity % 1 == 0 ? state.orderDetailsAndCalculateResponseModel.data.products[index].quantity.toInt() : state.orderDetailsAndCalculateResponseModel.data.products[index].quantity} (${state.orderDetailsAndCalculateResponseModel.data.products[index].totalAmountWithDiscount.toStringAsFixed(2)} ",
                                          style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack),
                                        ),
                                        TextSpan(
                                          text: '₽)',
                                          style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                        SizedBox(height: heightRatio(size: 10, context: context)),
                        Divider(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }

        return Center(child: Text("errorText".tr()));
      },
    );
  }
}
