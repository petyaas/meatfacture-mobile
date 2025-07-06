import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/diverse_food_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

import '../../bloc_files/favorite_product_bloc.dart';
import '../../bloc_files/product_details_bloc.dart';

class DiscountTitleText extends StatelessWidget {
  final ProductDetailsLoadedState pDState;
  const DiscountTitleText({Key key, this.pDState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pDState.productDetailsModel.data.discountType.contains("FavoriteAssortment")) {
      return BlocBuilder<FavoriteProductBloc, FavoriteProductState>(
        builder: (context, favProdstate) {
          num percent = null;
          if (favProdstate is FavoriteProductLoadedState) {
            favProdstate.favoriteProductModel.data.forEach(
              (favProd) {
                if (favProd.assortmentUuid == pDState.productDetailsModel.data.uuid) {
                  percent = favProd.discountPercent.toDouble();
                }
              },
            );
            return titleText(context: context, percent: percent);
          }
          return titleText(context: context);
        },
      );
    }
    if (pDState.productDetailsModel.data.discountType.contains("diverse")) {
      return BlocBuilder<DiverseFoodBloc, DiverseFoodState>(
        builder: (context, diverseState) {
          if (diverseState is DiverseFoodLoadedState) {
            return titleText(context: context, percent: diverseState.diverseFoodPresentDiscountModel.data.first.discountPercent);
          }
          return titleText(context: context);
        },
      );
    }
    return titleText(context: context);
  }

  Widget titleText({num percent, @required BuildContext context}) {
    return Text(
      pDState.productDetailsModel.data.discountTypeName == null
          ? ""
          : "${pDState.productDetailsModel.data.discountTypeName}${percent != null ? ". ${"discount".tr()} ${percent.isNaN ? percent : percent.toInt()}% " : ""} ${pDState.productDetailsModel.data.discountActiveTill != null && pDState.productDetailsModel.data.discountActiveTill.isNotEmpty ? "${"validForText".tr().toLowerCase()} ${pDState.productDetailsModel.data.discountActiveTill[8]}${pDState.productDetailsModel.data.discountActiveTill[9]}.${pDState.productDetailsModel.data.discountActiveTill[5]}${pDState.productDetailsModel.data.discountActiveTill[6]}" : ""}",
      textAlign: TextAlign.center,
      style: appTextStyle(color: colorBlack04, fontWeight: FontWeight.w500, fontSize: heightRatio(size: 12, context: context)),
    );
  }
}
