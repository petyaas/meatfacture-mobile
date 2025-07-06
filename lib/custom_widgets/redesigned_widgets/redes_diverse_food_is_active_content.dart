import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc_files/diverse_food_bloc.dart';
import 'package:smart/custom_widgets/redesigned_widgets/how_work_diverse_food_screen.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_diverse_food_assortment_to_rate_card.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_diverse_food_assortmnets_to_rate_content.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_diverse_food_progress_box.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_rotated_box_for_discount.dart';
import 'package:smart/pages/redesigned_pages/redes_secondary_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import '../../bloc_files/basic_page_bloc.dart';
import '../../bloc_files/reg_page_bloc.dart';
import '../../features/profile/profile_page.dart';

// ignore: must_be_immutable
class RedesDiverseFoodIsActiveContent extends StatelessWidget {
  int futuretRating = 0;
  int futurePuchases = 0;
  int minDiscountPercent = 0;
  @override
  Widget build(BuildContext context) {
    DiverseFoodBloc _diverseFoodBloc = BlocProvider.of(context);
    BasicPageBloc _basicPageBloc = BlocProvider.of(context);
    AuthPageBloc _authPageBloc = BlocProvider.of(context);
    return BlocConsumer<DiverseFoodBloc, DiverseFoodState>(
      listener: (context, state) {
        if (state is DiverseFoodOldTokenState) {
          ProfilePage.logout(regBloc: _authPageBloc, basicPageBloc: _basicPageBloc);
        }
      },
      builder: (context, state) {
        if (state is DiverseFoodLoadingState) {
          //разнообр пит отображающееся при загрузке страницы:
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
                  //разнообразное питание шапка начало
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
                        'Разнообразное питание',
                        style: appHeadersTextStyle(fontSize: heightRatio(size: 22, context: context), fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                ), //разнообразное питание шапка конец
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
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(newRedDark),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
          //старая загрузка: а выше новая
          // return RedesSecondaryPage(
          //   upText: "diverseFoodOneLineText"
          //       .tr(),
          //   contentWidget: Center(
          //     child: CircularProgressIndicator(
          //       valueColor: new AlwaysStoppedAnimation<Color>(newRedDark),
          //     ),
          //   ),
          // );
        }
        if (state is DiverseFoodErrorState) {
          return RedesSecondaryPage(
              upText: "diverseFoodOneLineText".tr(),
              contentWidget: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: widthRatio(size: 20, context: context), right: widthRatio(size: 20, context: context)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                    topRight: Radius.circular(heightRatio(size: 15, context: context)),
                  ),
                ),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
                      decoration: BoxDecoration(
                        color: colorBlack03,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/netErrorIcon.svg',
                        color: Colors.white,
                        height: heightRatio(size: 30, context: context),
                      ),
                    ),
                    SizedBox(height: heightRatio(size: 15, context: context)),
                    Text("errorText".tr(), style: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500)),
                    SizedBox(height: heightRatio(size: 10, context: context)),
                    InkWell(
                        onTap: () {
                          _diverseFoodBloc.add(DiverseFoodLoadEvent());
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Text("tryAgainText".tr(), style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500)),
                        ))
                  ],
                )),
              ));
        }

        if (state is DiverseFoodLoadedState) {
          if (state.isNotRatedProductsList.meta.total > 3) {
            state.isNotRatedProductsList.data.length = 3;
          }
          if (state.diverseFoodFutureDiscountModel.data != null && state.diverseFoodPersentListModel.data != null && state.diverseFoodPersentListModel.data.isNotEmpty) {
            minDiscountPercent = state.diverseFoodFutureDiscountModel.data.discountPercent;
            for (var i = 0; i < state.diverseFoodPersentListModel.data.length; i++) {
              if (minDiscountPercent < state.diverseFoodPersentListModel.data[i].discountPercent) {
                minDiscountPercent = state.diverseFoodPersentListModel.data[i].discountPercent;
                futurePuchases = state.diverseFoodPersentListModel.data[i].countPurchases;
                futuretRating = state.diverseFoodPersentListModel.data[i].countRatingScores;
                break;
              }
            }
          } else if (state.diverseFoodPersentListModel.data != null && state.diverseFoodPersentListModel.data.isNotEmpty) {
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
                  //разнообразное питание шапка начало
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
                        'Разнообразное питание',
                        style: appHeadersTextStyle(fontSize: heightRatio(size: 22, context: context), fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                ), //разнообразное питание шапка конец
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
                            if (state.diverseFoodPresentDiscountModel.data.isEmpty)
                              Container(
                                padding: EdgeInsets.only(
                                  top: heightRatio(size: 25, context: context),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "youHaveNoDiscountOnText".tr() + getMonthName(month: DateTime.now().month),
                                  style: appLabelTextStyle(fontSize: heightRatio(size: 15, context: context), fontWeight: FontWeight.w400, color: newBlack),
                                ),
                              )
                            else
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${"yourDiscountForText".tr()} ${getMonthName(month: DateTime.now().month)}",
                                    style: appLabelTextStyle(fontSize: heightRatio(size: 15, context: context), fontWeight: FontWeight.w400, color: newBlack),
                                  ),
                                  SizedBox(width: widthRatio(size: 10, context: context)),
                                  redesRotatedBoxForDiscount("${state.diverseFoodPresentDiscountModel.data.first.discountPercent}", context)
                                ],
                              ),
                            SizedBox(height: heightRatio(size: 30, context: context)),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
                              padding: EdgeInsets.all(widthRatio(size: 21, context: context)),
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)),
                                boxShadow: [
                                  BoxShadow(
                                    color: newShadow,
                                    offset: Offset(12, 12),
                                    blurRadius: 24,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Сейчас вы копите скидку ",
                                          style: appHeadersTextStyle(
                                            fontSize: heightRatio(size: 16, context: context),
                                            fontWeight: FontWeight.w700,
                                            color: newBlack,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "to".tr() + " ",
                                          style: appHeadersTextStyle(
                                            fontSize: heightRatio(size: 16, context: context),
                                            fontWeight: FontWeight.w700,
                                            color: newBlack,
                                          ),
                                        ),
                                        TextSpan(
                                          text: getMonthName(month: DateTime.now().month == 12 ? 1 : DateTime.now().month + 1),
                                          style: appHeadersTextStyle(
                                            fontSize: heightRatio(size: 16, context: context),
                                            fontWeight: FontWeight.w700,
                                            color: newRedDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //квадратики с % - - - -
                                  redesDiverseFoodProgressBox(
                                    forMaim: false,
                                    context: context,
                                    state: state,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: heightRatio(size: 20, context: context)),
                            // как работает акция?:
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: widthRatio(size: 16, context: context),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HowWorkDiverseFoodScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(
                                    widthRatio(size: 10, context: context),
                                  ),
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
                                        width: widthRatio(
                                          size: 60,
                                          context: context,
                                        ),
                                        height: heightRatio(
                                          size: 60,
                                          context: context,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            heightRatio(
                                              size: 5,
                                              context: context,
                                            ),
                                          ),
                                          color: newIconBg,
                                        ),
                                        child: SvgPicture.asset(
                                          "assets/images/newPercent.svg",
                                          width: widthRatio(size: 34, context: context),
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                      SizedBox(width: widthRatio(size: 20, context: context)),
                                      Text(
                                        "howWorkDiscountText".tr() + "?",
                                        style: appHeadersTextStyle(
                                          fontSize: heightRatio(size: 16, context: context),
                                          color: newBlack,
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: newRedDark,
                                        size: heightRatio(size: 23, context: context),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: heightRatio(size: 20, context: context)),
                            //Если есть товары для оценки:
                            if (state.isNotRatedProductsList.meta.total > 0)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: widthRatio(size: 16, context: context),
                                ),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  SizedBox(height: heightRatio(size: 20, context: context)),
                                  // Text(
                                  //   "leftToRateText".tr(),
                                  //   style: appTextStyle(
                                  //       fontSize: widthRatio(
                                  //           size: 18, context: context),
                                  //       fontWeight: FontWeight.w700),
                                  // ),
                                  Text(
                                    "У вас есть ${state.isNotRatedProductsList.meta.total} товаров на оценку:",
                                    style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                                  ),
                                  SizedBox(height: heightRatio(size: 16, context: context)),
                                  ...state.isNotRatedProductsList.data.map((e) => RedesDiverseFoodAssortmentToRateCard(productModel: e)).toList(),
                                  SizedBox(height: heightRatio(size: 15, context: context)),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return RedesSecondaryPage(upText: "purchasesPerMonthText".tr(), contentWidget: RedesDiverseFoodAssortmnetsToRateContent());
                                        },
                                      ));
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(vertical: widthRatio(size: 16, context: context)),
                                      decoration: BoxDecoration(color: lightGreyColor, borderRadius: BorderRadius.circular(widthRatio(size: 5, context: context))),
                                      child: Text(
                                        "showAllYourPurchasedProductsText".tr(),
                                        style: appLabelTextStyle(fontSize: heightRatio(size: 13, context: context), color: newRedDark),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: heightRatio(size: 50, context: context)),
                                ]),
                              )
                            else
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: heightRatio(size: 30, context: context)),
                                  SvgPicture.asset('assets/images/variedNutrition.svg', width: widthRatio(size: 115, context: context)),
                                  SizedBox(height: heightRatio(size: 20, context: context)),
                                  Text(
                                    "noProductsToEvaluateYetText".tr(),
                                    textAlign: TextAlign.center,
                                    style: appHeadersTextStyle(
                                      fontSize: heightRatio(size: 16, context: context),
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
