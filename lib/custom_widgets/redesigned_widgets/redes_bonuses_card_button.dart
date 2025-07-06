import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_has_bonuses_content.dart';
import 'package:smart/pages/redesigned_pages/redes_secondary_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

import '../../pages/redesigned_pages/redes_bonuses_instruction_page.dart';

class RedesBonusesCardButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RedesSecondaryPage(upText: "historyOfPointsText".tr(), contentWidget: Container(color: screenBackgrountGreyColor, child: RedesHasBonusesContent())),
                ));
          },
          child: Container(
            padding: EdgeInsets.only(left: widthRatio(size: 15, context: context), right: widthRatio(size: 15, context: context), bottom: heightRatio(size: 10, context: context), top: heightRatio(size: 15, context: context)),
            decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(heightRatio(size: 15, context: context))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 15, context: context)), color: lightGreyColor),
                            child: Container(
                              width: widthRatio(size: 50, context: context),
                              height: heightRatio(size: 50, context: context),
                              child: SvgPicture.asset('assets/images/bonuses_main_icon.svg', width: widthRatio(size: 50, context: context), height: heightRatio(size: 50, context: context)),
                            ),
                          ),
                          SizedBox(width: widthRatio(size: 20, context: context)),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("bonusesText".tr() + " Мясофактура",
                                    style: appHeadersTextStyle(
                                      fontSize: heightRatio(size: 17, context: context),
                                      fontWeight: FontWeight.w700,
                                    )),
                                SizedBox(height: heightRatio(size: 5, context: context)),
                                state is ProfileLoadedState && state.profileModel.data.bonusBalance != 0
                                    ? Text(state.profileModel.data.bonusBalance.toString(), style: appTextStyle(fontSize: heightRatio(size: 20, context: context), fontWeight: FontWeight.w800, color: mainColor))
                                    : state is! ProfileLoadedState
                                        ? Text("", style: appTextStyle(fontSize: heightRatio(size: 12, context: context), fontWeight: FontWeight.w500))
                                        : Text("youHaveNoBonusesYetText".tr() + "  :(", style: appTextStyle(fontSize: heightRatio(size: 12, context: context), fontWeight: FontWeight.w500, color: colorBlack06)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: widthRatio(size: 20, context: context)),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: colorBlack06,
                    )
                  ],
                ),
                SizedBox(height: heightRatio(size: 10, context: context)),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => redesBonusesInstructionPage(context: context, headerText: ""),
                        ));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: heightRatio(size: 5, context: context)),
                    color: Colors.transparent,
                    child: Text(
                      state is ProfileLoadedState && state.profileModel.data.bonusBalance != null && state.profileModel.data.bonusBalance != 0 ? "FindOutHowToSaveMoreText".tr() : "collectHowToStartCopyingText".tr(),
                      style: appTextStyle(fontSize: heightRatio(size: 12, context: context), fontWeight: FontWeight.w600, color: colorDarkRed),
                    ),
                  ),
                )
              ],
            ),
          ));
    });
  }
}
