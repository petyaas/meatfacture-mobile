import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart/core/constants/text_styles.dart';

const String playMarketAppUrl = "https://play.google.com/store/apps/details?id=com.smartshopapp.android";
const String appStoreAppUrl =
    "https://apps.apple.com/ru/app/s-mart-%D0%B4%D0%BE%D1%81%D1%82%D0%B0%D0%B2%D0%BA%D0%B0-%D0%BF%D1%80%D0%BE%D0%B4%D1%83%D0%BA%D1%82%D0%BE%D0%B2/id1590156795";
//***** redesigne colors ******

LinearGradient mainGradient = LinearGradient(
  colors: [firstGradientMainColor, secondGradientMainColor],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

BoxShadow shadowwithBlack03 = BoxShadow(
  color: colorBlack03,
  spreadRadius: 0,
  blurRadius: 10,
  offset: Offset(0, 0),
);

const Color screenBackgrountGreyColor = Color(0xFFF4F4F9);
const Color lightGreyColor = Color(0xFFF3F3FA);
const Color blackColor = Colors.black;
const Color firstGradientMainColor = Color(0xFFC90512);
const Color secondGradientMainColor = Color(0xFFE0424D);
const Color greamMainColor = Color(0xFFFFEFDF);

final Color shadowGrayColor006 = Colors.black.withOpacity(0.06);
const Color grey04 = Color(0xFFE6E6E6);
const Color colorRed = Color(0xFFC90512);
const Color colorDarkRed = Color(0xFF8b0000);

const Color yellowForPromo = Color(0xFFF3E531);
const Color greenForPromo = Color(0xFF70D665);
const Color blueGrey = Color(0xFF88A9BC);

const red015 = Color.fromRGBO(230, 42, 55, 0.15);
const black05 = Color.fromRGBO(0, 0, 0, 0.5);
const black04 = Color.fromRGBO(0, 0, 0, 0.4);

//****Colors****
var darkcGray = Color.fromRGBO(51, 51, 51, 1);
var asdtestColor = Color(0xFF9163);
int sdsf = int.parse("0xFF9163");

const mainColor = const Color(0xFFC90512);
const redE60D2E = const Color(0xFFE60D2E);
const mainColorDisable = Color.fromRGBO(230, 42, 55, 1);
const greyForTegs = Color.fromRGBO(236, 236, 237, 1);

const white03 = Color.fromRGBO(255, 255, 255, 0.3);
const white04 = Color.fromRGBO(255, 255, 255, 0.4);
const white06 = Color.fromRGBO(255, 255, 255, 0.6);
const white08 = Color.fromRGBO(255, 255, 255, 0.8);

const greencolor = Color.fromRGBO(97, 204, 108, 1);
const whiteColor = Colors.white;
const instagramIconBgColor = Color.fromRGBO(187, 107, 217, 1);
const vkIconBgColor = Color.fromRGBO(45, 156, 219, 1);
const faceBookIconBgColor = Color.fromRGBO(47, 128, 237, 1);
const telegramIconBgColor = Color.fromRGBO(86, 204, 242, 1);

const firstOrangeToGradient = Color.fromRGBO(201, 5, 18, 1);
const secondOrengeToGradient = Color.fromRGBO(178, 0, 12, 1);
const colorwhite04 = Color.fromRGBO(255, 255, 255, 0.4);
const colorwhite03 = Color.fromRGBO(255, 255, 255, 0.3);

const colorBlack04 = Color.fromRGBO(0, 0, 0, 0.4);
const colorBlack05 = Color.fromRGBO(0, 0, 0, 0.5);
const colorBlack06 = Color.fromRGBO(0, 0, 0, 0.6);
const colorBlack08 = Color.fromRGBO(0, 0, 0, 0.8);

const colorBlack03 = Color.fromRGBO(0, 0, 0, 0.1);
const colorGreen = Color.fromRGBO(97, 204, 108, 1);

// -------------------- new colors -----------------------------
const newRedDark = const Color(0xFFC02425);
const newGrey = const Color(0xFFB7BAC0);
const newGrey2 = const Color(0xFFF3F4F9);
const newGrey3 = const Color(0xFF99A2B5);
const newGrey4 = const Color(0xFF959595);
const newGrey5 = const Color(0xFFEFEFEF);
const newGrey6 = const Color(0xFFA6A6A6);
const grey6D6D6D = const Color(0xFF6D6D6D);
const newGrey6B6B6B = const Color(0xFF6B6B6B);
const newGrey979797 = const Color(0xFF979797);
const newGreyECECEC = const Color(0xFFECECEC);
const newBlack = const Color(0xFF2B3141);
const newBlack595F6E = const Color(0xFF595F6E);
const newBlack212121 = const Color(0xFF212121);
const newBlack2 = const Color(0xFF333847);
const newBlue = const Color(0xFF27A3E2);
const newIconBg = const Color(0xFFF4F3F9);
const newIconBg2 = const Color(0xFFD9D9D9);
const newShadow = const Color(0xFFEEEEEE);
const newBlackLight = const Color(0xFF6B6F7A);
const newYellow = const Color(0xFFf5a623);
const newGreen27B568 = const Color(0xFF27B568);
const newGreen32D74B = const Color(0xFF32D74B);

// button gradien colors

var firstColorButtonsOrangeGradient = Color.fromRGBO(178, 0, 12, 1);
var secondColorButtonsOrangeGradient = Color.fromRGBO(201, 5, 18, 1);
var firstColorButtonDisableOrangeGradient = Color.fromRGBO(201, 5, 18, 0.2);
var secondColorButtonDisableOrangeGradient = Color.fromRGBO(201, 5, 18, 0.2);

// button gradien colors

var firstColorButtonsForInstagrammGradient = Color.fromRGBO(237, 161, 93, 1);
var secondColorButtonsInstagrammGradient = Color.fromRGBO(180, 61, 142, 1);

//second item colors in home page

var imInShopElipsColor = Color.fromRGBO(178, 0, 12, 0.67);
var sharesElipsColor = Color.fromRGBO(201, 5, 18, 0.74);
var subscriptionsElipsColor = Color.fromRGBO(136, 124, 124, 1);

//big two cards ellips colors

var foodEllipsColor = Color.fromRGBO(157, 211, 115, 0.83);
var favoriteellipsColor = Color.fromRGBO(249, 132, 175, 0.76);

var orangeTextColor = Color.fromRGBO(178, 0, 12, 0.67);

//****textStyles****

var profileGreyTextStyle = appTextStyle(color: Colors.grey, fontSize: 14);
var notEmptyHintTextStyle = appTextStyle(color: blackColor, fontSize: 18);
var notEmptyHintTextStyleForNumbers = TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300);
var hintTextStyle = appTextStyle(color: Color.fromRGBO(0, 0, 0, 0.1), fontSize: 18);
var hintTextStyleForNumbers = TextStyle(color: Color.fromRGBO(0, 0, 0, 0.1), fontSize: 18);
var profileOrangeText = appTextStyle(color: orangeTextColor, fontWeight: FontWeight.w500, fontSize: 14);

//TEXT

//***********screen size***********
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
//***********1 poin of size***********

double pointOfHeght(BuildContext context, int points) => 667 / (MediaQuery.of(context).size.height) * points;

double pointOfWidth(BuildContext context, int points) => (9375 / MediaQuery.of(context).size.width) * points;

List<String> getAssortmentUnitId({@required String assortmentUnitId}) {
  switch (assortmentUnitId) {
    case "package":
      return ["Упаковка", "упак"];
      break;
    case "piece":
      return ["Штука", "шт"];
      break;
    case "roll":
      return ["Рулон", "рул"];
      break;
    case "set":
      return ["Набор", "набор"];
      break;
    case "kilogram":
      return ["Килограмм", "кг"];
      break;
    default:
      return ["", ""];
  }
}

DateTime dateTimeConverter(String date) {
  return DateTime.parse(date.replaceAll("+0300", "+0000"));
}

String getMonthName({int month, bool isOfMode}) {
  if (isOfMode == null || isOfMode == false) {
    switch (month) {
      case 1:
        return "januaryText".tr().toLowerCase();
        break;

      case 2:
        return "februaryText".tr().toLowerCase();
        break;

      case 3:
        return "marchText".tr().toLowerCase();
        break;

      case 4:
        return "aprilText".tr().toLowerCase();
        break;

      case 5:
        return "mayText".tr().toLowerCase();
        break;

      case 6:
        return "juneText".tr().toLowerCase();
        break;

      case 7:
        return "julyText".tr().toLowerCase();
        break;

      case 8:
        return "augustText".tr().toLowerCase();
        break;

      case 9:
        return "septemberText".tr().toLowerCase();
        break;

      case 10:
        return "octoberText".tr().toLowerCase();
        break;

      case 11:
        return "novemberText".tr().toLowerCase();
        break;
      case 12:
        return "decemberText".tr().toLowerCase();
        break;
      default:
        return "";
    }
  } else {
    switch (month) {
      case 1:
        return "ofJanuaryText".tr().toLowerCase();
        break;

      case 2:
        return "ofFebruaryText".tr().toLowerCase();
        break;

      case 3:
        return "ofMarchText".tr().toLowerCase();
        break;

      case 4:
        return "ofAprilText".tr().toLowerCase();
        break;

      case 5:
        return "ofMayText".tr().toLowerCase();
        break;

      case 6:
        return "ofJuneText".tr().toLowerCase();
        break;

      case 7:
        return "ofJulyText".tr().toLowerCase();
        break;

      case 8:
        return "ofAugustText".tr().toLowerCase();
        break;

      case 9:
        return "ofSeptemberText".tr().toLowerCase();
        break;

      case 10:
        return "ofOctoberText".tr().toLowerCase();
        break;

      case 11:
        return "ofNovemberText".tr().toLowerCase();
        break;
      case 12:
        return "ofDecemberText".tr().toLowerCase();
        break;
      default:
        return "";
    }
  }
}

//Height and width with ratio by device sizes
double widthRatio({@required double size, @required BuildContext context}) {
  return (screenWidth(context) / (375 / size));
}

double heightRatio({@required double size, @required BuildContext context}) {
  return (screenHeight(context) / (800 / size));
}

// class for romove scroll glow
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

// quick extension for convert sctring to double
extension StringToDouble on String {
  double toDouble() {
    return double.tryParse(this);
  }

  // DateTime toDateTime{
  //   return DateTime.
  // }

  int toInt() {
    return int.tryParse(this);
  }
}

extension removeNulles on double {
  num removeAfterPointNulles() {
    if (this != null) {
      if (this % 1 == 0)
        return this.toInt();
      else
        return this;
    } else {
      return null;
    }
  }
}

extension ToFormatedDate on DateTime {
  String toFormatedDate() {
    return "${this.day < 10 ? "0${this.day}" : this.day}.${this.month < 10 ? "0${this.month}" : this.month}.${this.year}";
  }

  String toFormatedTime() {
    return "${this.hour < 10 ? "0${this.hour}" : this.hour}:${this.minute < 10 ? "0${this.minute}" : this.minute}";
  }
}
