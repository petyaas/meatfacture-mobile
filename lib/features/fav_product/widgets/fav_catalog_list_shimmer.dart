import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/core/constants/source.dart';

class FavCatalogsListShimmer extends StatelessWidget {
  final double childAspectRatio;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double height;
  final double spaceY;

  const FavCatalogsListShimmer({Key key, this.crossAxisCount = 3, this.childAspectRatio = 0.67, this.crossAxisSpacing = 11, this.height = 136, this.spaceY = 4}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        padding: EdgeInsets.only(top: 34, bottom: 12),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.8,
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 32,
        ),
        itemCount: 4,
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey[50],
          highlightColor: Colors.white,
          child: Container(
            height: heightRatio(size: height, context: context),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
            ),
          ),
        ),
      ),
    );
  }
}
