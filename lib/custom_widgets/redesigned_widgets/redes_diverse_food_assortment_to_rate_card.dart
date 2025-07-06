import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/custom_widgets/send_mark_for_product_bottom_sheet.dart';
import 'package:smart/models/diverse_food_assortment_list_model.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/utils/custom_cache_manager.dart';

class RedesDiverseFoodAssortmentToRateCard extends StatelessWidget {
  final DiverseFoodAssortmentListDataModel productModel;

  const RedesDiverseFoodAssortmentToRateCard({@required this.productModel});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: widthRatio(size: 8, context: context), bottom: widthRatio(size: 10, context: context), left: widthRatio(size: 10, context: context)),
      margin: EdgeInsets.only(bottom: heightRatio(size: 10, context: context)),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)),
        boxShadow: [BoxShadow(color: newShadow, offset: Offset(12, 12), blurRadius: 24, spreadRadius: 0)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)),
              color: whiteColor,
            ),
            child: productModel.assortment.images.length > 0
                ? CachedNetworkImage(
                    imageUrl: productModel.assortment.images[0].thumbnails.the1000X1000,
                    cacheManager: CustomCacheManager(),
                    fit: BoxFit.cover,
                    useOldImageOnUrlChange: true,
                    width: widthRatio(size: 90, context: context),
                    height: heightRatio(size: 100, context: context),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/notImage.png",
                      fit: BoxFit.contain,
                      width: widthRatio(size: 90, context: context),
                      height: heightRatio(size: 100, context: context),
                    ),
                  )
                : Container(
                    height: heightRatio(size: 100, context: context),
                    width: widthRatio(size: 90, context: context),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 20, context: context))),
                    child: Image.asset("assets/images/notImage.png", fit: BoxFit.scaleDown),
                  ),
          ),
          SizedBox(width: widthRatio(size: 16, context: context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productModel.assortment.name,
                  maxLines: 2,
                  style: appLabelTextStyle(
                    fontSize: heightRatio(size: 14, context: context),
                    color: newBlack,
                  ),
                ),
                SizedBox(height: heightRatio(size: 10, context: context)),
                InkWell(
                  onTap: (() {
                    opentRateBottomSheet(context: context);
                  }),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _getRateStar(currentRate: 1, rating: productModel.rating ?? 0, context: context),
                          _getRateStar(currentRate: 2, rating: productModel.rating ?? 0, context: context),
                          _getRateStar(currentRate: 3, rating: productModel.rating ?? 0, context: context),
                          _getRateStar(currentRate: 4, rating: productModel.rating ?? 0, context: context),
                          _getRateStar(currentRate: 5, rating: productModel.rating ?? 0, context: context),
                        ],
                      ),
                      SizedBox(height: heightRatio(size: 10, context: context)),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: widthRatio(size: 10, context: context), horizontal: widthRatio(size: 23, context: context)),
                        decoration: BoxDecoration(
                            color: productModel.rating == null ? newRedDark : greamMainColor,
                            borderRadius: BorderRadius.circular(widthRatio(size: 10, context: context))),
                        child: Text(
                          productModel.rating == null ? "WriteCommentText".tr() : "readCommentText".tr(),
                          style: appLabelTextStyle(
                              fontSize: heightRatio(size: 11, context: context), color: productModel.rating == null ? whiteColor : newRedDark),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _getRateStar({int currentRate, double rating, @required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(right: widthRatio(size: 8, context: context)),
      child: SvgPicture.asset(
        rating < currentRate ? "assets/images/redes_star_big.svg" : "assets/images/redes_star_big_active.svg",
        height: heightRatio(size: 30, context: context),
        width: widthRatio(size: 30, context: context),
      ),
    );
  }

  opentRateBottomSheet({@required BuildContext context}) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(heightRatio(size: 25, context: context)),
            topRight: Radius.circular(heightRatio(size: 25, context: context)),
          ),
        ),
        builder: (BuildContext bc) {
          return Wrap(
            children: [
              SendMarkForProductBottomSheet(
                orderOrCheck: productModel.source,
                checkLineUuid: productModel.sourceLineId,
                comment: productModel.ratingComment,
                rating: productModel.rating,
                checkUuid: productModel.sourceId,
              ),
            ],
          );
        });
  }
}
