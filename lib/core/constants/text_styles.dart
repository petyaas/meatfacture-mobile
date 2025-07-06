import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart/core/constants/source.dart';

TextStyle appTextStyle({
  Color decorationColor = blackColor,
  Color color = Colors.black,
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.w400,
  TextDecoration decoration = TextDecoration.none,
}) =>
    GoogleFonts.roboto(decorationColor: decorationColor, color: color, fontSize: fontSize, fontWeight: fontWeight, decoration: decoration);

TextStyle appHeadersTextStyle({
  Color decorationColor = blackColor,
  Color color = Colors.black,
  double fontSize = 14,
  double height,
  FontWeight fontWeight = FontWeight.w700,
  TextDecoration decoration = TextDecoration.none,
}) =>
    TextStyle(
      fontFamily: "KabelCTT Medium",
      decorationColor: decorationColor,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: decoration,
      height: height,
    );

TextStyle appLabelTextStyle({
  Color decorationColor = blackColor,
  Color color = newGrey,
  double fontSize = 12,
  double height,
  FontWeight fontWeight = FontWeight.w400,
  TextDecoration decoration = TextDecoration.none,
}) =>
    TextStyle(
      fontFamily: "KabelCTT Medium",
      decorationColor: decorationColor,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: decoration,
      height: height,
    );
