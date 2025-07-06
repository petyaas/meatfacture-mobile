// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_assortment_comments_in_product_details_widget.dart';
import 'package:smart/models/product_details_model.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RedesProductDetailsMiddleContent extends StatelessWidget {
  final ProductDetailsModel productDetailsModel;

  const RedesProductDetailsMiddleContent({@required this.productDetailsModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("О продукте:", style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context))),
          SizedBox(height: heightRatio(size: 15, context: context)),
          Text(
            productDetailsModel.data.description ?? "",
            style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack),
          ),
          if (productDetailsModel.data.ingredients != null) SizedBox(height: heightRatio(size: 25, context: context)),
          if (productDetailsModel.data.ingredients != null) Text("Состав:", style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context))),
          if (productDetailsModel.data.ingredients != null) SizedBox(height: heightRatio(size: 15, context: context)),
          if (productDetailsModel.data.ingredients != null)
            Text(
              productDetailsModel.data.ingredients ?? "",
              style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack),
            ),
          SizedBox(height: heightRatio(size: 25, context: context)),
          RedesAssortmentCommentsInProductDetailsWidget(),
        ],
      ),
    );
  }

  String getDayOrDays(int shelfLife) {
    if (shelfLife % 10 == 1) {
      return "dayText1".tr();
    } else {
      return "daysText".tr();
    }
  }
}
