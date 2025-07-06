// ignore: implementation_imports
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/bloc_files/history_check_details_bloc.dart';
import 'package:smart/custom_widgets/send_mark_for_product_bottom_sheet.dart';
import 'package:smart/custom_widgets/shimmer_history_check_details_loader.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/utils/custom_cache_manager.dart';

import '../pages/redesigned_pages/redes_product_details_page.dart';

class HistoryCheckDetailsPageContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void openSendMarkForProductBottomSheet({String checkLineUuid, String checkUuid, double rating, String comment}) {
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
          return Wrap(
            children: [
              SendMarkForProductBottomSheet(
                orderOrCheck: "check",
                checkLineUuid: checkLineUuid,
                comment: comment,
                rating: rating,
                checkUuid: checkUuid,
              ),
            ],
          );
        },
      );
    }

    return BlocBuilder<HistoryCheckDetailsBloc, HistoryCheckDetailsState>(
      builder: (context, state) {
        if (state is HistoryCheckDetailsLoadingState) {
          return ShimmerHistoryCheckDeatilsLoader();
        }

        // if (state is HistoryCheckDetailsErrorState) {
        //   return Center(
        //     child: Text("errorText".tr()),
        //   );
        // }

        if (state is HistoryCheckDetailsLoadedState) {
          DateTime _createAt = DateTime.parse(state.checkDetailsModel.checkDetailsDataModel.createdAt.replaceAll("+0300", "+0000"));
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context), vertical: widthRatio(size: 23, context: context)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Дата и время покупки',
                  style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: colorBlack04),
                ),
                SizedBox(height: heightRatio(size: 6, context: context)),
                Text(
                  "${_createAt.toFormatedDate()}  ${_createAt.toFormatedTime()}",
                  style: appLabelTextStyle(fontSize: heightRatio(size: 18, context: context), color: Colors.black),
                ),
                SizedBox(height: heightRatio(size: 16, context: context)),
                Text(
                  "purchaseAmountText".tr(),
                  style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: colorBlack04),
                ),
                SizedBox(height: heightRatio(size: 6, context: context)),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: state.checkDetailsModel.checkDetailsDataModel.total,
                        style: appLabelTextStyle(fontSize: heightRatio(size: 18, context: context), color: Colors.black),
                      ),
                      TextSpan(
                        text: " ₽",
                        style: appTextStyle(color: Colors.black, fontSize: heightRatio(size: 18, context: context)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: heightRatio(size: 16, context: context)),
                Text(
                  'Вы собираетесь изменить адрес магазина?',
                  style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: colorBlack04),
                ),
                SizedBox(height: heightRatio(size: 6, context: context)),
                Text(
                  "${state.checkDetailsModel.checkDetailsDataModel.storeAddress}",
                  style: appLabelTextStyle(fontSize: heightRatio(size: 18, context: context), color: Colors.black),
                ),
                //Charge bonuses
                if (state.checkDetailsModel.checkDetailsDataModel.bonusToCharge != null && state.checkDetailsModel.checkDetailsDataModel.bonusToCharge != 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: heightRatio(size: 12, context: context)),
                      Text(
                        'Начислено бонусов за покупку',
                        style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: colorBlack04),
                      ),
                      SizedBox(height: heightRatio(size: 3, context: context)),
                      Text("${state.checkDetailsModel.checkDetailsDataModel.bonusToCharge} бонусов",
                          style: appTextStyle(fontSize: heightRatio(size: 18, context: context), fontWeight: FontWeight.w400, color: Colors.black)),
                    ],
                  ),

                //Paid bonuses
                if (state.checkDetailsModel.checkDetailsDataModel.paidBonus != null && state.checkDetailsModel.checkDetailsDataModel.paidBonus != 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: heightRatio(size: 12, context: context)),
                      Text(
                        'Списано бонусов за покупку',
                        style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: colorBlack04),
                      ),
                      SizedBox(height: heightRatio(size: 3, context: context)),
                      Text("-${state.checkDetailsModel.checkDetailsDataModel.paidBonus} бонусов",
                          style: appTextStyle(fontSize: heightRatio(size: 18, context: context), fontWeight: FontWeight.w400, color: Colors.black)),
                    ],
                  ),

                SizedBox(height: heightRatio(size: 28, context: context)),
                Text(
                  'Оцените ваши покупки',
                  style: appHeadersTextStyle(fontSize: heightRatio(size: 24, context: context), color: Colors.black),
                ),
                SizedBox(height: heightRatio(size: 20, context: context)),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.checkDetailsProductsModel.data.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      if (state.checkDetailsProductsModel.data[index].assortmentUuid != null) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RedesProductDetailsPage(
                              productUuid: state.checkDetailsProductsModel.data[index].assortmentUuid,
                            ),
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(msg: "productNotRecognizedText".tr());
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: heightRatio(size: 10, context: context)),
                        Stack(
                          children: [
                            Card(
                              shadowColor: Colors.white,
                              elevation: 1,
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widthRatio(size: 8, context: context))),
                              color: colorBlack03,
                              child: state.checkDetailsProductsModel.data[index].assortmentImages.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: state.checkDetailsProductsModel.data[index].assortmentImages[0].thumbnails.the1000X1000,
                                      cacheManager: CustomCacheManager(),
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) => Image.asset("assets/images/notImage.png", fit: BoxFit.contain),
                                      useOldImageOnUrlChange: true,
                                      height: heightRatio(size: 100, context: context),
                                      width: widthRatio(size: 90, context: context),
                                    )
                                  : Container(
                                      height: heightRatio(size: 100, context: context),
                                      width: widthRatio(size: 90, context: context),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 20, context: context))),
                                      child: Image.asset("assets/images/notImage.png", fit: BoxFit.cover),
                                    ),
                            ),
                            // product's bonuses to charge
                            if (state.checkDetailsProductsModel.data[index].totalBonus != null && state.checkDetailsProductsModel.data[index].totalBonus != 0)
                              Positioned(
                                bottom: widthRatio(size: 10, context: context),
                                left: widthRatio(size: 16, context: context),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(widthRatio(size: 4, context: context)),
                                  ),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: widthRatio(size: 4, context: context), vertical: heightRatio(size: 2, context: context)),
                                  child: Row(children: [
                                    Container(
                                      width: widthRatio(size: 15, context: context),
                                      height: heightRatio(size: 15, context: context),
                                      child: SvgPicture.asset('assets/images/bonus_vector.svg',
                                          width: widthRatio(size: 15, context: context), height: heightRatio(size: 15, context: context)),
                                    ),
                                    SizedBox(width: widthRatio(size: 3, context: context)),
                                    Text(
                                      state.checkDetailsProductsModel.data[index].totalBonus.removeAfterPointNulles().toString(),
                                      style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: colorBlack06),
                                    )
                                  ]),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(width: widthRatio(size: 8, context: context)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: heightRatio(size: 5, context: context)),
                              Container(
                                height: heightRatio(size: 40, context: context),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  state.checkDetailsProductsModel.data[index].assortmentName == null
                                      ? "productNotRecognizedText".tr()
                                      : state.checkDetailsProductsModel.data[index].assortmentName,
                                  maxLines: 3,
                                  style: appLabelTextStyle(fontSize: heightRatio(size: 15, context: context), color: Colors.black),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (state.checkDetailsProductsModel.data[index].assortmentUuid != null) {
                                          openSendMarkForProductBottomSheet(
                                              rating: state.checkDetailsProductsModel.data[index].rating,
                                              comment: state.checkDetailsProductsModel.data[index].ratingComment,
                                              checkUuid: state.checkDetailsModel.checkDetailsDataModel.uuid,
                                              checkLineUuid: state.checkDetailsProductsModel.data[index].uuid);
                                        } else {
                                          Fluttertoast.showToast(msg: "productNotRecognizedText".tr());
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SvgPicture.asset(
                                              state.checkDetailsProductsModel.data[index].rating != null &&
                                                      state.checkDetailsProductsModel.data[index].rating > 0
                                                  ? 'assets/images/activeStar.svg'
                                                  : 'assets/images/star.svg',
                                              width: widthRatio(size: 20, context: context),
                                              height: heightRatio(size: 20, context: context),
                                            ),
                                            SvgPicture.asset(
                                              state.checkDetailsProductsModel.data[index].rating != null &&
                                                      state.checkDetailsProductsModel.data[index].rating > 1
                                                  ? 'assets/images/activeStar.svg'
                                                  : 'assets/images/star.svg',
                                              width: widthRatio(size: 20, context: context),
                                              height: heightRatio(size: 20, context: context),
                                            ),
                                            SvgPicture.asset(
                                              state.checkDetailsProductsModel.data[index].rating != null &&
                                                      state.checkDetailsProductsModel.data[index].rating > 2
                                                  ? 'assets/images/activeStar.svg'
                                                  : 'assets/images/star.svg',
                                              width: widthRatio(size: 20, context: context),
                                              height: heightRatio(size: 20, context: context),
                                            ),
                                            SvgPicture.asset(
                                              state.checkDetailsProductsModel.data[index].rating != null &&
                                                      state.checkDetailsProductsModel.data[index].rating > 3
                                                  ? 'assets/images/activeStar.svg'
                                                  : 'assets/images/star.svg',
                                              width: widthRatio(size: 20, context: context),
                                              height: heightRatio(size: 20, context: context),
                                            ),
                                            SvgPicture.asset(
                                              state.checkDetailsProductsModel.data[index].rating != null &&
                                                      state.checkDetailsProductsModel.data[index].rating > 4
                                                  ? 'assets/images/activeStar.svg'
                                                  : 'assets/images/star.svg',
                                              width: widthRatio(size: 20, context: context),
                                              height: heightRatio(size: 20, context: context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: widthRatio(size: 20, context: context)),
                                  //price area
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        (state.checkDetailsProductsModel.data[index].originalPrice != null ||
                                                    state.checkDetailsProductsModel.data[index].price != null) &&
                                                state.checkDetailsProductsModel.data[index].assortmentUuid != null
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: widthRatio(size: 5, context: context), vertical: heightRatio(size: 3, context: context)),
                                                decoration: BoxDecoration(
                                                  color: state.checkDetailsProductsModel.data[index].discountTypeColor == null
                                                      ? colorBlack03
                                                      : Color(int.parse("0xff${state.checkDetailsProductsModel.data[index].discountTypeColor}")),
                                                  borderRadius: BorderRadius.circular(heightRatio(size: 4, context: context)),
                                                ),
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: state.checkDetailsProductsModel.data[index].price == null
                                                            ? state.checkDetailsProductsModel.data[index].originalPrice.toStringAsFixed(2)
                                                            : state.checkDetailsProductsModel.data[index].price.toStringAsFixed(2),
                                                        style: appLabelTextStyle(
                                                          color: (state.checkDetailsProductsModel.data[index].originalPrice != null ||
                                                                      state.checkDetailsProductsModel.data[index].price != null) &&
                                                                  state.checkDetailsProductsModel.data[index].quantity != null
                                                              ? Colors.black
                                                              : colorBlack04,
                                                          fontSize: heightRatio(size: 12, context: context),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: " ₽",
                                                        style: appTextStyle(
                                                          color: (state.checkDetailsProductsModel.data[index].originalPrice != null ||
                                                                      state.checkDetailsProductsModel.data[index].price != null) &&
                                                                  state.checkDetailsProductsModel.data[index].quantity != null
                                                              ? Colors.black
                                                              : colorBlack04,
                                                          fontSize: heightRatio(size: 12, context: context),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: state.checkDetailsProductsModel.data[index].assortmentUnitId == 'package'
                                                            ? ""
                                                            : "/${getAssortmentUnitId(assortmentUnitId: state.checkDetailsProductsModel.data[index].assortmentUnitId ?? "")[1]}",
                                                        style: appLabelTextStyle(
                                                          color: (state.checkDetailsProductsModel.data[index].originalPrice != null ||
                                                                      state.checkDetailsProductsModel.data[index].price != null) &&
                                                                  state.checkDetailsProductsModel.data[index].quantity != null
                                                              ? Colors.black
                                                              : colorBlack04,
                                                          fontSize: heightRatio(size: 12, context: context),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : SizedBox(height: heightRatio(size: 24, context: context)),
                                        SizedBox(height: heightRatio(size: 3, context: context)),
                                        state.checkDetailsProductsModel.data[index].discountableType != null
                                            ? Container(
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                          state.checkDetailsProductsModel.data[index].assortmentUuid != null
                                                              ? state.checkDetailsProductsModel.data[index].price != null
                                                                  ? state.checkDetailsProductsModel.data[index].originalPrice != null
                                                                      ? state.checkDetailsProductsModel.data[index].originalPrice.toStringAsFixed(2) + " ₽"
                                                                      : ""
                                                                  : ""
                                                              : "",
                                                          style: appTextStyle(
                                                            decorationColor: colorBlack04,
                                                            fontSize: heightRatio(size: 12, context: context),
                                                            color: colorBlack04,
                                                            fontWeight: FontWeight.w600,
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
                              SizedBox(height: heightRatio(size: 6, context: context)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (state.checkDetailsProductsModel.data[index].assortmentWeight != null &&
                                      state.checkDetailsProductsModel.data[index].assortmentWeight != 0)
                                    Text(
                                      state.checkDetailsProductsModel.data[index].assortmentWeight > 500
                                          ? "${"productWeightText".tr()}: ${(state.checkDetailsProductsModel.data[index].assortmentWeight / 1000).removeAfterPointNulles()}${"kgText".tr()}"
                                          : "${"productWeightText".tr()}: ${state.checkDetailsProductsModel.data[index].assortmentWeight.removeAfterPointNulles()}${"grText".tr()}",
                                      style: appLabelTextStyle(fontSize: heightRatio(size: 9, context: context), color: colorBlack04),
                                    )
                                  else
                                    SizedBox(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (state.checkDetailsProductsModel.data[index].assortmentRating != null)
                                        SvgPicture.asset("assets/images/activeStar.svg", height: heightRatio(size: 15, context: context)),
                                      SizedBox(width: widthRatio(size: 5, context: context)),
                                      Text(
                                        state.checkDetailsProductsModel.data[index].assortmentRating != null
                                            ? state.checkDetailsProductsModel.data[index].assortmentRating.toString()
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
                                              "x${state.checkDetailsProductsModel.data[index].quantity % 1 == 0 ? state.checkDetailsProductsModel.data[index].quantity.toInt() : state.checkDetailsProductsModel.data[index].quantity} (${state.checkDetailsProductsModel.data[index].total}",
                                          style: appHeadersTextStyle(color: Colors.black, fontSize: heightRatio(size: 14, context: context)),
                                        ),
                                        TextSpan(
                                          text: " ₽",
                                          style: appTextStyle(
                                            color: (state.checkDetailsProductsModel.data[index].originalPrice != null ||
                                                        state.checkDetailsProductsModel.data[index].price != null) &&
                                                    state.checkDetailsProductsModel.data[index].quantity != null
                                                ? Colors.black
                                                : colorBlack04,
                                            fontSize: heightRatio(size: 14, context: context),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ")",
                                          style: appHeadersTextStyle(color: Colors.black, fontSize: heightRatio(size: 14, context: context)),
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
