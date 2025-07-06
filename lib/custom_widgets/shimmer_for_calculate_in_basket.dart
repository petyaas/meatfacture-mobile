import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/core/constants/source.dart';

class ShimmerforCalculateInBasket extends StatelessWidget {
  final int countStr;

  const ShimmerforCalculateInBasket({Key key, @required this.countStr}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Container(
          //       height: heightRatio(height: 20, context: context),
          //       width: MediaQuery.of(context).size.width / 3,
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(
          //               heightRatio(height: 20, context: context))),
          //       alignment: Alignment.center,
          //     ),
          //     Container(
          //       height: heightRatio(height: 20, context: context),
          //       width: widthRatio(width: 40, context: context),
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(
          //               heightRatio(height: 20, context: context))),
          //       alignment: Alignment.center,
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   height: heightRatio(height: 20, context: context),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Container(
          //       height: heightRatio(height: 20, context: context),
          //       width: MediaQuery.of(context).size.width / 3,
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(
          //               heightRatio(height: 20, context: context))),
          //       alignment: Alignment.center,
          //     ),
          //     Container(
          //       height: heightRatio(height: 20, context: context),
          //       width: widthRatio(width: 40, context: context),
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(
          //               heightRatio(height: 20, context: context))),
          //       alignment: Alignment.center,
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   height: heightRatio(height: 20, context: context),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(height: heightRatio(size: 18, context: context), width: MediaQuery.of(context).size.width / 3, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(heightRatio(size: 18, context: context))), alignment: Alignment.center),
              Container(height: heightRatio(size: 18, context: context), width: widthRatio(size: 40, context: context), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(heightRatio(size: 18, context: context))), alignment: Alignment.center),
            ],
          ),
          SizedBox(height: heightRatio(size: 17, context: context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(height: heightRatio(size: 18, context: context), width: MediaQuery.of(context).size.width / 3, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(heightRatio(size: 18, context: context))), alignment: Alignment.center),
              Container(height: heightRatio(size: 18, context: context), width: widthRatio(size: 40, context: context), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(heightRatio(size: 18, context: context))), alignment: Alignment.center),
            ],
          ),
          if (countStr == 3) SizedBox(height: heightRatio(size: 17, context: context)),
          if (countStr == 3)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height: heightRatio(size: 18, context: context), width: MediaQuery.of(context).size.width / 3, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(heightRatio(size: 18, context: context))), alignment: Alignment.center),
                Container(height: heightRatio(size: 18, context: context), width: widthRatio(size: 40, context: context), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(heightRatio(size: 18, context: context))), alignment: Alignment.center),
              ],
            ),
          SizedBox(height: heightRatio(size: 13, context: context)),
        ],
      ),
      baseColor: Colors.grey[200],
      highlightColor: Colors.white,
    );
  }
}
