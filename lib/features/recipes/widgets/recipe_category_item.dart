import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RecipeCategoryItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final Function(String) onTap;
  const RecipeCategoryItem({
    key,
    Key,
    @required this.title,
    @required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap(title);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 6, context: context)),
        decoration: BoxDecoration(
          color: isActive ? newRedDark : newGrey2,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.only(
          left: widthRatio(size: 20, context: context),
          right: widthRatio(size: 20, context: context),
          top: heightRatio(size: 7, context: context),
          bottom: heightRatio(size: 8, context: context),
        ),
        child: Text(
          title,
          style: appLabelTextStyle(fontSize: 12, color: isActive ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
