import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

Widget redesRotatedBoxForDiscount(String discText, BuildContext context) => Transform.rotate(
      angle: 0.10,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: widthRatio(size: 4, context: context), horizontal: widthRatio(size: 4, context: context)),
        decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(heightRatio(size: 6, context: context))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.circle,
              color: mainColor,
              size: heightRatio(size: 6, context: context),
            ),
            SizedBox(width: widthRatio(size: 4, context: context)),
            Text(
              discText + "%",
              style: appTextStyle(fontSize: heightRatio(size: 15, context: context), fontWeight: FontWeight.w700, color: mainColor),
            ),
          ],
        ),
      ),
    );
