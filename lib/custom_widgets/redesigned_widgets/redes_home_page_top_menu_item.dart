import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

Widget homePageTopMenuItem({
  @required String text,
  String imagePath,
  @required BuildContext context,
}) {
  return Column(
    children: [
      Container(
        width: widthRatio(size: 40, context: context),
        height: heightRatio(size: 40, context: context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            heightRatio(size: 5, context: context),
          ),
          color: newIconBg,
        ),
        child: SvgPicture.asset(
          imagePath,
          width: widthRatio(size: 22, context: context),
          fit: BoxFit.scaleDown,
        ),
      ),
      SizedBox(height: heightRatio(size: 5, context: context)),
      Text(
        text,
        style: appHeadersTextStyle(
          fontSize: heightRatio(
            size: 12,
            context: context,
          ),
          color: newBlack,
        ),
      )
    ],
  );
}
