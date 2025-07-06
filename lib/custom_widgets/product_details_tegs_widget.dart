import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class ProductDetailsTegsWidget extends StatelessWidget {
  final List<String> tagsList;
  const ProductDetailsTegsWidget({@required this.tagsList});

  @override
  Widget build(BuildContext context) {
    if (tagsList.isEmpty) {
      return Container(
        margin: EdgeInsets.only(left: widthRatio(size: 15, context: context)),
        height: heightRatio(size: 30, context: context),
        alignment: Alignment.centerLeft,
        child: Text(
          '',
          // style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(left: widthRatio(size: 15, context: context)),
      alignment: Alignment.centerLeft,
      height: heightRatio(size: 30, context: context),
      child: Center(
          child: ListView.builder(
              itemCount: tagsList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(
                    right: widthRatio(size: 10, context: context),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 10, context: context)),
                  decoration: BoxDecoration(color: greyForTegs, borderRadius: BorderRadius.circular(heightRatio(size: 50, context: context))),
                  alignment: Alignment.center,
                  child: Text(
                    tagsList[index],
                    style: appTextStyle(fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w400),
                  ),
                );
              })),
    );
  }
}
