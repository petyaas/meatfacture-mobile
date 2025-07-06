import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

Widget redesBonusesInstructionPage({@required String headerText, @required BuildContext context}) => Scaffold(
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                "assets/images/ellipse_for_bonuses_instruction.png",
                fit: BoxFit.fitWidth,
              ),
              Positioned(
                bottom: -60,
                child: Image.asset(
                  "assets/images/warning_for_bonuses_instr_image.png",
                  fit: BoxFit.fitWidth,
                  width: screenWidth(context) / 3 * 2,
                ),
              ),
              Positioned(
                top: 6,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        child: InkWell(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.only(left: widthRatio(size: 15, context: context)),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: heightRatio(size: 25, context: context),
                              color: whiteColor,
                            ),
                          ),
                          onTap: () {
                            // _bottomNavBloc.add(HomeEvent());
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(width: widthRatio(size: 10, context: context)),
                      Text(
                        headerText,
                        style: appTextStyle(fontSize: heightRatio(size: 16, context: context), fontWeight: FontWeight.w700, color: whiteColor),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: heightRatio(size: 60, context: context)),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.only(left: widthRatio(size: 15, context: context), right: widthRatio(size: 15, context: context), bottom: heightRatio(size: 20, context: context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "howToSavePointsText".tr() + "?",
                      style: appTextStyle(fontWeight: FontWeight.w800, fontSize: heightRatio(size: 28, context: context)),
                    ),
                    SizedBox(height: heightRatio(size: 20, context: context)),
                    Text(
                      "getCashbackText".tr(),
                      style: appTextStyle(fontWeight: FontWeight.w700, fontSize: heightRatio(size: 18, context: context)),
                    ),
                    SizedBox(height: heightRatio(size: 20, context: context)),
                    Text(
                      "getCashbackDescriptionText".tr(),
                      style: appTextStyle(fontWeight: FontWeight.w500, fontSize: heightRatio(size: 14, context: context), color: colorBlack08),
                    ),
                    SizedBox(height: heightRatio(size: 15, context: context)),
                    Text(
                      "toDoTasksText".tr(),
                      style: appTextStyle(fontWeight: FontWeight.w700, fontSize: heightRatio(size: 18, context: context)),
                    ),
                    SizedBox(height: heightRatio(size: 10, context: context)),
                    Text(
                      "toDoTasksDescriptionText".tr(),
                      style: appTextStyle(fontWeight: FontWeight.w500, fontSize: heightRatio(size: 14, context: context), color: colorBlack08),
                    ),
                    SizedBox(height: heightRatio(size: 15, context: context)),
                    Text(
                      "followActivitiesText".tr(),
                      style: appTextStyle(fontWeight: FontWeight.w700, fontSize: heightRatio(size: 18, context: context)),
                    ),
                    SizedBox(height: heightRatio(size: 10, context: context)),
                    Text(
                      "followActivitiesDescriptionText".tr(),
                      style: appTextStyle(fontWeight: FontWeight.w500, fontSize: heightRatio(size: 14, context: context), color: colorBlack08),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
