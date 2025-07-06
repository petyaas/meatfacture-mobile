import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';

class HomeDiverseFoodCardButtonShimmerSquare extends StatelessWidget {
  const HomeDiverseFoodCardButtonShimmerSquare();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthRatio(size: 45, context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: widthRatio(size: 35, context: context),
            height: heightRatio(size: 35, context: context),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: newIconBg,
              borderRadius: BorderRadius.all(
                Radius.circular(widthRatio(size: 5, context: context)),
              ),
            ),
          ),
          SizedBox(height: heightRatio(size: 15, context: context)),
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(heightRatio(size: 25, context: context)),
              color: newIconBg2,
            ),
            height: heightRatio(size: 5, context: context),
            child: Row(
              children: [
                Expanded(
                  flex: 1, //0
                  child: Container(
                    height: heightRatio(size: 15, context: context),
                    decoration: BoxDecoration(color: newIconBg2),
                  ),
                ),
                Expanded(
                  flex: 1, // 0
                  child: Container(
                    height: heightRatio(size: 15, context: context),
                    decoration: BoxDecoration(color: newIconBg2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
