import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart/bloc_files/diverse_food_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

// проценты в квадратиках
Widget redesDiverseFoodProgressBox({
  @required bool forMaim,
  @required DiverseFoodState state,
  @required BuildContext context,
}) {
  int futuretRating = 0;
  int futurePuchases = 0;
  int minDiscountPercent = 0;
  if (state is DiverseFoodLoadedState) {
    if (state.diverseFoodFutureDiscountModel.data != null) {
      minDiscountPercent = state.diverseFoodFutureDiscountModel.data.discountPercent;
      for (var i = 0; i < state.diverseFoodPersentListModel.data.length; i++) {
        if (minDiscountPercent < state.diverseFoodPersentListModel.data[i].discountPercent || i == state.diverseFoodPersentListModel.data.length - 1) {
          minDiscountPercent = state.diverseFoodPersentListModel.data[i].discountPercent;
          futurePuchases = state.diverseFoodPersentListModel.data[i].countPurchases;
          futuretRating = state.diverseFoodPersentListModel.data[i].countRatingScores;
          break;
        }
      }
    } else {
      minDiscountPercent = state.diverseFoodPersentListModel.data.first.discountPercent;
      for (var i = 0; i < state.diverseFoodPersentListModel.data.length; i++) {
        if (state.diverseFoodPersentListModel.data[i].discountPercent <= minDiscountPercent) {
          minDiscountPercent = state.diverseFoodPersentListModel.data[i].discountPercent;
          futurePuchases = state.diverseFoodPersentListModel.data[i].countPurchases;
          futuretRating = state.diverseFoodPersentListModel.data[i].countRatingScores;
        }
      }
    }

    return Container(
      padding: EdgeInsets.only(top: widthRatio(size: 20, context: context)),
      alignment: Alignment.center,
      child: _redesDiverseFoodOnlyProgressBox(
          formMaim: forMaim,
          minDiscountPercent: minDiscountPercent,
          state: state,
          context: context,
          countPurchases: state.diverseFoodStatsModel.data.isEmpty ? 0 : state.diverseFoodStatsModel.data.first.purchasedCount,
          requiredPurchases: futurePuchases,
          ratedCount: state.diverseFoodStatsModel.data.isEmpty ? 0 : state.diverseFoodStatsModel.data.first.ratedCount,
          requiredRatedCount: futuretRating),
    );
  }
  return SizedBox();
}

Widget _redesDiverseFoodOnlyProgressBox({
  @required bool formMaim,
  @required DiverseFoodState state,
  @required int minDiscountPercent,
  @required BuildContext context,
  @required int countPurchases,
  @required int requiredPurchases,
  @required int ratedCount,
  @required int requiredRatedCount,
}) {
  if (countPurchases > requiredPurchases) countPurchases = requiredPurchases;
  if (ratedCount > requiredRatedCount) ratedCount = requiredRatedCount;
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (state is DiverseFoodLoadedState)
            ...state.diverseFoodPersentListModel.data
                .map((item) => _getPercentArea(
                    isLast: item.discountPercent == state.diverseFoodPersentListModel.data.last.discountPercent ? true : false,
                    percent: item.discountPercent,
                    context: context,
                    formMaim: formMaim,
                    minDiscountPercent: minDiscountPercent,
                    doneProgress: countPurchases + ratedCount,
                    requiredProgress: requiredPurchases + requiredRatedCount))
                .toList()
        ],
      ),
      SizedBox(height: heightRatio(size: 25, context: context)),
      if (state is DiverseFoodLoadedState)
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Center(
            child: Text(
              (requiredRatedCount - ratedCount) > 0 || (requiredPurchases - countPurchases) > 0
                  ? "Осталось купить ${requiredPurchases - countPurchases < 0 ? "0" : (requiredPurchases - countPurchases).toString()} товаров" +
                      (requiredRatedCount - ratedCount > 0 ? " ${"andEvaluateText".tr()} ${(requiredRatedCount - ratedCount).toString()} из них" : "")
                  : "YouAccumulatedMaximumDiscount".tr(),
              style: appLabelTextStyle(color: newBlackLight),
            ),
          ),
        ),
    ],
  );
}

Widget _getPercentArea(
    {@required int percent,
    bool isLast,
    @required BuildContext context,
    @required bool formMaim,
    @required minDiscountPercent,
    @required int doneProgress,
    @required int requiredProgress}) {
  return SizedBox(
    width: widthRatio(size: 45, context: context),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: widthRatio(size: 35, context: context),
            height: heightRatio(size: 35, context: context),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: percent < minDiscountPercent || (percent == minDiscountPercent && doneProgress >= requiredProgress && isLast) ? newRedDark : newIconBg,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  widthRatio(size: 5, context: context),
                ),
              ),
            ),
            child: Text(
              percent.toString() + "%",
              style: formMaim
                  ? appLabelTextStyle(
                      fontSize: 13,
                      color: percent < minDiscountPercent || (percent == minDiscountPercent && isLast && doneProgress >= requiredProgress)
                          ? whiteColor
                          : newBlack2)
                  : appLabelTextStyle(
                      fontSize: 13,
                      color: percent < minDiscountPercent || (percent == minDiscountPercent && isLast && doneProgress >= requiredProgress)
                          ? whiteColor
                          : newBlack2),
            )),
        SizedBox(height: heightRatio(size: 15, context: context)),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(heightRatio(size: 25, context: context)),
            color: newIconBg2,
          ),
          height: heightRatio(size: 5, context: context),
          child: Row(
            children: [
              Expanded(
                flex: percent == minDiscountPercent
                    ? doneProgress
                    : percent < minDiscountPercent
                        ? 1
                        : 0,
                child: Container(height: heightRatio(size: 15, context: context), decoration: BoxDecoration(color: newIconBg2)),
              ),
              Expanded(
                  flex: percent == minDiscountPercent
                      ? requiredProgress - doneProgress
                      : percent < minDiscountPercent
                          ? 0
                          : 1,
                  child: Container(height: heightRatio(size: 15, context: context), decoration: BoxDecoration(color: newIconBg2))),
            ],
          ),
        ),
      ],
    ),
  );
}
