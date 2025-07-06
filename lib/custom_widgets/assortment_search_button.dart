import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/core/constants/source.dart';

class AssortmentSearchButton extends StatelessWidget {
  final VoidCallback onTap;
  const AssortmentSearchButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //поиск
      onTap: onTap,
      child: Container(
        width: widthRatio(size: 36, context: context),
        height: heightRatio(size: 36, context: context),
        padding: EdgeInsets.all(widthRatio(size: 8, context: context)),
        decoration: BoxDecoration(shape: BoxShape.circle, color: white03),
        child: SvgPicture.asset(
          'assets/images/searchIcon.svg',
          height: heightRatio(size: 20, context: context),
          color: whiteColor,
          width: widthRatio(size: 20, context: context),
        ),
      ),
    );
  }
}
