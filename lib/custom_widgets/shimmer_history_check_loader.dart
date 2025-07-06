import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/core/constants/source.dart';

class ShimmerHistoryCheckLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[200],
        highlightColor: whiteColor,
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) => ListTile(
            title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                color: whiteColor,
                height: heightRatio(size: 10, context: context),
                width: widthRatio(size: 100, context: context),
                alignment: Alignment.center,
              ),
              SizedBox(height: heightRatio(size: 10, context: context)),
              Container(
                color: whiteColor,
                height: heightRatio(size: 12, context: context),
                width: widthRatio(size: 200, context: context),
                alignment: Alignment.center,
              ),
              SizedBox(height: heightRatio(size: 10, context: context)),
            ]),
            subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                height: heightRatio(size: 10, context: context),
                color: whiteColor,
                width: widthRatio(size: 100, context: context),
                alignment: Alignment.center,
              ),
              Container(
                height: heightRatio(size: 20, context: context),
                color: whiteColor,
                width: widthRatio(size: 100, context: context),
                alignment: Alignment.center,
              ),
            ]),
          ),
        ));
  }
}
