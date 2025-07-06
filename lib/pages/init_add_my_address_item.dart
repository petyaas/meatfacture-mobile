import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class InitAddMyAddressItem extends StatelessWidget {
  final bool isActive;
  final String address;

  const InitAddMyAddressItem({Key key, @required this.isActive, @required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: isActive ? newRedDark : Colors.transparent),
        color: whiteColor,
        borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
        boxShadow: [BoxShadow(color: newShadow, offset: Offset(2, 2), blurRadius: 4, spreadRadius: 0)],
      ),
      margin: EdgeInsets.only(top: heightRatio(size: 20, context: context)),
      padding: EdgeInsets.only(
        top: heightRatio(size: 15, context: context),
        bottom: heightRatio(size: 15, context: context),
        left: widthRatio(size: 20, context: context),
        right: widthRatio(size: 16, context: context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              address,
              style: appLabelTextStyle(
                fontSize: heightRatio(size: 13, context: context),
                color: newBlack,
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/images/newEdit3.svg',
            height: heightRatio(size: 26, context: context),
            width: widthRatio(size: 26, context: context),
          ),
        ],
      ),
    );
  }
}
