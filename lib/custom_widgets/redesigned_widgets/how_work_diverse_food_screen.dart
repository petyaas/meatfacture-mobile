import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

import '../../bloc_files/diverse_food_bloc.dart';

class HowWorkDiverseFoodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DiverseFoodBloc _diverseFoodBloc = BlocProvider.of(context);
    return BlocBuilder<DiverseFoodBloc, DiverseFoodState>(builder: (context, state) {
      if (state is DiverseFoodLoadedState) {
        return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(color: newRedDark),
            child: Column(
              children: [
                SizedBox(height: heightRatio(size: 8, context: context)),
                Container(
                  height: 75,
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 26),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        top: 2,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: heightRatio(size: 25, context: context),
                            color: whiteColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Text(
                        "howWorkDiscountText".tr(),
                        style: appHeadersTextStyle(fontSize: heightRatio(size: 22, context: context), fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                ), //Как работает акция шапка конец
                SizedBox(height: heightRatio(size: 6, context: context)),
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                      topRight: Radius.circular(heightRatio(size: 15, context: context)),
                    ),
                    child: Container(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: heightRatio(size: 25, context: context)),
                            ...state.diverseFoodPersentListModel.data
                                .map((element) => _percentCard(
                                    purchasesCount: element.countPurchases,
                                    ratedCount: element.countRatingScores,
                                    percent: element.discountPercent,
                                    context: context))
                                .toList(),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: widthRatio(size: 16, context: context),
                                  right: widthRatio(size: 16, context: context),
                                  top: heightRatio(size: 19, context: context)),
                              child: Text(
                                "diverseFoodDescOnBottomSheetText".tr(),
                                style: appLabelTextStyle(
                                  fontSize: heightRatio(size: 16, context: context),
                                  color: newBlackLight,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: heightRatio(size: heightRatio(size: 20, context: context), context: context),
                                  bottom: heightRatio(size: heightRatio(size: 50, context: context), context: context),
                                  left: widthRatio(size: widthRatio(size: 16, context: context), context: context),
                                  right: widthRatio(size: widthRatio(size: 16, context: context), context: context),
                                ),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)), color: newRedDark),
                                alignment: Alignment.center,
                                height: heightRatio(size: 53, context: context),
                                child: Text(
                                  "Понятно",
                                  style: appLabelTextStyle(fontSize: heightRatio(size: 18, context: context), color: whiteColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      }

      if (state is DiverseFoodErrorState) {
        return Container(
            alignment: Alignment.center,
            height: screenHeight(context) * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
                  decoration: BoxDecoration(color: colorBlack03, shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    'assets/images/netErrorIcon.svg',
                    color: Colors.white,
                    height: heightRatio(size: 30, context: context),
                  ),
                ),
                SizedBox(height: heightRatio(size: 15, context: context)),
                Text("errorText".tr(),
                    style: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500)),
                SizedBox(height: heightRatio(size: 10, context: context)),
                InkWell(
                    onTap: () {
                      _diverseFoodBloc.add(DiverseFoodLoadEvent());
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Text("tryAgainText".tr(),
                          style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500)),
                    ))
              ],
            ));
      }

      return Container(
        height: screenHeight(context) * 0.95,
        color: whiteColor,
      );
    });
  }
}

// карточка процента
Widget _percentCard({int percent, BuildContext context, int purchasesCount, int ratedCount}) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: widthRatio(size: 16, context: context),
      vertical: heightRatio(size: 7, context: context),
    ),
    padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
    decoration: BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.circular(
        heightRatio(size: 10, context: context),
      ),
      boxShadow: [
        BoxShadow(
          color: newShadow,
          offset: Offset(12, 12),
          blurRadius: 24,
          spreadRadius: 0,
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          height: heightRatio(size: 35, context: context),
          width: widthRatio(size: 35, context: context),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: newRedDark,
            borderRadius: BorderRadius.all(
              Radius.circular(
                widthRatio(size: 5, context: context),
              ),
            ),
          ),
          child: Text(
            "$percent%",
            style: appLabelTextStyle(fontSize: 13, color: whiteColor),
          ),
        ),
        SizedBox(width: widthRatio(size: 20, context: context)),
        Flexible(
            child: Text(
          "${"toBuy".tr()} $purchasesCount ${"differentProducts".tr()}\n${"andRate".tr()} $ratedCount из них",
          textAlign: TextAlign.start,
          style: appLabelTextStyle(
            fontSize: heightRatio(size: 14, context: context),
            color: newBlack,
          ),
        ))
      ],
    ),
  );
}
