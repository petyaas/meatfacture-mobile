import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RedesProductDetailsButton extends StatelessWidget {
  final bool isActive;
  final String text;
  final String icon;
  final VoidCallback onTapCallback;

  const RedesProductDetailsButton({
    @required this.isActive,
    @required this.text,
    @required this.icon,
    @required this.onTapCallback,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapCallback,
      child: Column(
        children: [
          Container(
            height: screenWidth(context) / 8,
            width: screenWidth(context) / 8,
            padding: EdgeInsets.all(widthRatio(size: 10, context: context)),
            decoration: BoxDecoration(
              color: isActive ? newRedDark : newIconBg,
              borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context)),
            ),
            child: SvgPicture.asset(
              icon,
              color: isActive ? whiteColor : newRedDark,
            ),
          ),
          SizedBox(height: heightRatio(size: 8, context: context)),
          Text(
            text,
            textAlign: TextAlign.center,
            style: appLabelTextStyle(fontSize: heightRatio(size: 11, context: context), color: newBlack),
          ),
        ],
      ),
    );
  }
}
