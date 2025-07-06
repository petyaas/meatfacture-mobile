import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/features/home/widgets/home_diverse_food_card_button_shimmer_square.dart';

class HomeDiverseFoodCardButtonShimmer extends StatelessWidget {
  const HomeDiverseFoodCardButtonShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100],
      highlightColor: Colors.white,
      child: Column(
        children: [
          SizedBox(height: heightRatio(size: 21, context: context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HomeDiverseFoodCardButtonShimmerSquare(),
              HomeDiverseFoodCardButtonShimmerSquare(),
              HomeDiverseFoodCardButtonShimmerSquare(),
              HomeDiverseFoodCardButtonShimmerSquare(),
              HomeDiverseFoodCardButtonShimmerSquare(),
            ],
          ),
          SizedBox(height: heightRatio(size: 24, context: context)),
          Center(
            child: Container(
              width: widthRatio(size: 236, context: context),
              height: heightRatio(size: 16, context: context),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
              ),
            ),
          ),
          SizedBox(height: heightRatio(size: 13, context: context)),
        ],
      ),
    );
  }
}
