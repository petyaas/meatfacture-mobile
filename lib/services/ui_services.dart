import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showSnackBar(
  BuildContext context,
  String text,
) {
  showTopSnackBar(
    context,
    Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(widthRatio(size: 16, context: context))),
          boxShadow: [shadowwithBlack03],
        ),
        padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context), vertical: heightRatio(size: 12, context: context)),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/images/MFIcon.svg",
              height: heightRatio(size: 30, context: context),
              width: widthRatio(size: 30, context: context),
            ),
            SizedBox(width: widthRatio(size: 12, context: context)),
            Flexible(
              child: Text(
                text,
                style: appTextStyle(fontSize: heightRatio(size: 14, context: context)),
              ),
            ),
          ],
        ),
      ),
    ),
    displayDuration: Duration(milliseconds: 2000),
  );
}
