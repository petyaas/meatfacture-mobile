import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class FavProductChooseBtn extends StatelessWidget {
  const FavProductChooseBtn();
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: heightRatio(size: 8, context: context)),
      padding: EdgeInsets.all(widthRatio(size: 12, context: context)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(heightRatio(size: 15, context: context)),
        color: Colors.white,
        boxShadow: [BoxShadow(color: shadowGrayColor006, spreadRadius: 5, blurRadius: 7, offset: Offset(0, 0))],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)), color: newIconBg),
            child: SvgPicture.asset("assets/images/newHeart.svg", height: heightRatio(size: 28, context: context), width: widthRatio(size: 32, context: context), fit: BoxFit.scaleDown),
          ),
          SizedBox(width: widthRatio(size: 15, context: context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Выберите продукт',
                  style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'Чтобы получить скидку',
                  style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlackLight),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: newRedDark),
            padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
            child: SvgPicture.asset("assets/images/redes_cart_icon.svg"),
          ),
        ],
      ),
    );
  }
}
