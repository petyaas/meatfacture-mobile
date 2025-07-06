import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/core/constants/source.dart';

class ShimmerHistoryCheckDeatilsLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100],
      highlightColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context), vertical: heightRatio(size: 22, context: context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              height: heightRatio(size: 14, context: context),
              width: widthRatio(size: 200, context: context),
              alignment: Alignment.center,
            ),
            SizedBox(height: heightRatio(size: 5, context: context)),
            Container(
              color: Colors.white,
              height: heightRatio(size: 22, context: context),
              width: widthRatio(size: 200, context: context),
              alignment: Alignment.center,
            ),
            SizedBox(height: heightRatio(size: 8, context: context)),
            Container(
              color: Colors.white,
              height: heightRatio(size: 14, context: context),
              width: widthRatio(size: 200, context: context),
              alignment: Alignment.center,
            ),
            SizedBox(height: heightRatio(size: 5, context: context)),
            Container(
              color: Colors.white,
              height: heightRatio(size: 22, context: context),
              width: widthRatio(size: 200, context: context),
              alignment: Alignment.center,
            ),
            SizedBox(height: heightRatio(size: 8, context: context)),
            Container(
              color: Colors.white,
              height: heightRatio(size: 14, context: context),
              width: widthRatio(size: 200, context: context),
              alignment: Alignment.center,
            ),
            SizedBox(height: heightRatio(size: 5, context: context)),
            Container(
              color: Colors.white,
              height: heightRatio(size: 22, context: context),
              width: widthRatio(size: 200, context: context),
              alignment: Alignment.center,
            ),
            SizedBox(height: heightRatio(size: 26, context: context)),
            Container(
              color: Colors.white,
              height: heightRatio(size: 46, context: context),
              width: widthRatio(size: 160, context: context),
              alignment: Alignment.center,
            ),
            SizedBox(height: heightRatio(size: 20, context: context)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: heightRatio(size: 20, context: context)),
                  height: heightRatio(size: 100, context: context),
                  width: widthRatio(size: 90, context: context),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(heightRatio(size: 20, context: context))),
                ),
                Expanded(
                  child: SizedBox(
                    height: heightRatio(size: 100, context: context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
                          color: Colors.white,
                          height: heightRatio(size: 20, context: context),
                          alignment: Alignment.center,
                        ),
                        SizedBox(height: heightRatio(size: 10, context: context)),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
                          color: Colors.white,
                          height: heightRatio(size: 20, context: context),
                          alignment: Alignment.center,
                        ),
                        SizedBox(height: heightRatio(size: 10, context: context)),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
                          color: Colors.white,
                          height: heightRatio(size: 20, context: context),
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
