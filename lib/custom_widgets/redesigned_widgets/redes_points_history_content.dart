import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RedesEmptyBonusesHitoryContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  child: SvgPicture.asset(
                    "assets/images/bonuses_big.svg",
                    width: screenWidth(context) / 2,
                  ),
                ),
                Positioned(
                  right: -78,
                  top: -48,
                  child: SvgPicture.asset(
                    "assets/images/bonuses_small.svg",
                    width: screenWidth(context) / 6,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: heightRatio(size: 42, context: context)),
          Text(
            "youHaveNoBonusesYetText".tr() + " :(",
            style: appHeadersTextStyle(fontSize: heightRatio(size: 22, context: context)).copyWith(height: heightRatio(size: 1.36, context: context)),
          )
        ],
      ),
    );
  }
}
