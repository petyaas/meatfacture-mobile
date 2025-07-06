import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

Widget redesRotatedBoxForFavProdDiscount(String discText, BuildContext context) => Transform.rotate(
      angle: 0.25,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: heightRatio(size: 2, context: context), horizontal: widthRatio(size: 5, context: context)),
        decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context))),
        child: Text(
          "-" + discText + "%",
          style: appTextStyle(fontSize: heightRatio(size: 12, context: context), fontWeight: FontWeight.w700, color: whiteColor),
        ),
      ),
    );
