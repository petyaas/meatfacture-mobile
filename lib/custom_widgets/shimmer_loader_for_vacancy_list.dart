import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/core/constants/source.dart';

class ShimmerLoaderForVacancyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200],
      highlightColor: Colors.white,
      child: GridView.builder(
        itemCount: 10,
        padding: EdgeInsets.only(left: widthRatio(size: 15, context: context), right: widthRatio(size: 15, context: context), top: heightRatio(size: 5, context: context), bottom: heightRatio(size: 15, context: context)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1, crossAxisCount: 1, mainAxisSpacing: 10),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 10),
                blurRadius: 20,
              )
            ],
            borderRadius: BorderRadius.circular(heightRatio(size: 20, context: context)),
          ),
        ),
      ),
    );
  }
}
