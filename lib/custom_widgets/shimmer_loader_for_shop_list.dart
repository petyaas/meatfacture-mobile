import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class ShimmerLoaderForShopList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: heightRatio(size: 25, context: context)),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(color: grey04, borderRadius: BorderRadius.circular(12)),
          height: heightRatio(size: 40, context: context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context))),
                  child: Text(
                    'Списком',
                    style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context)),
                    color: newRedDark,
                  ),
                  child: Text(
                    'На карте',
                    style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: whiteColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: heightRatio(size: 56, context: context)),
        Shimmer.fromColors(
          baseColor: Colors.grey[200],
          highlightColor: whiteColor,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                height: heightRatio(size: 60, context: context),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
