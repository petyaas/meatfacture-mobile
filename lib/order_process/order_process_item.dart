import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class OrderProcessItem extends StatelessWidget {
  final String title;
  final String icon;
  final bool isActive;

  const OrderProcessItem({Key key, this.title, this.icon, this.isActive}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthRatio(size: 70, context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: widthRatio(size: 54, context: context),
            height: heightRatio(size: 54, context: context),
            decoration: BoxDecoration(
              color: isActive ? newRedDark : newGrey5,
              borderRadius: BorderRadius.circular(30),
            ),
            child: SvgPicture.asset(
              icon,
              height: heightRatio(size: 18, context: context),
              width: widthRatio(size: 21, context: context),
              fit: BoxFit.scaleDown,
              color: isActive ? Colors.white : newGrey6,
            ),
          ),
          SizedBox(height: heightRatio(size: 10, context: context)),
          Text(
            title,
            style: appLabelTextStyle(fontSize: 12, color: isActive ? newBlack : newGrey6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
