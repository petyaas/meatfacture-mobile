import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc_files/Basic_page_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/custom_widgets/assortment_filter_button.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/pages/redesigned_pages/redes_product_details_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

// ignore: must_be_immutable
class ShoppingListProductsItem extends StatefulWidget {
  String uuid;
  String name;
  String assortmentUnitId;
  String weight;
  double rating;
  String image;
  String thumbnail;
  int quantity;
  String currentPrice;
  double priceWithDiscount;
  bool isFavorite;
  bool hasYellowPrice;

  ShoppingListProductsItem({
    Key key,
    this.uuid,
    this.name,
    this.assortmentUnitId,
    this.weight,
    this.rating,
    this.image,
    this.thumbnail,
    this.quantity,
    this.currentPrice,
    this.priceWithDiscount,
    this.isFavorite,
    this.hasYellowPrice,
  }) : super(key: key);

  @override
  State<ShoppingListProductsItem> createState() => _ShoppingListProductsItemState();
}

class _ShoppingListProductsItemState extends State<ShoppingListProductsItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          new CupertinoPageRoute(
            builder: (context) => RedesProductDetailsPage(productUuid: widget.uuid),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 2.5, context: context), vertical: heightRatio(size: 2.5, context: context)),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(heightRatio(size: 14, context: context)),
        ),
        child: Column(
          // Товар из списка
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 161,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
                    color: widget.thumbnail.isNotEmpty ? Colors.transparent : newGrey2,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
                    child: Image(
                      image: widget.thumbnail.isNotEmpty ? NetworkImage(widget.thumbnail) : AssetImage("assets/images/notImage.png"),
                      fit: widget.thumbnail.isNotEmpty ? BoxFit.cover : BoxFit.contain,
                    ),
                  ),
                ),
                // избранное
                Positioned(
                  right: 8,
                  top: 8,
                  child: InkWell(
                    onTap: () async {
                      if (await AssortmentFilterButton().loadToken() != "guest") {
                        if (widget.isFavorite) {
                          setState(() {
                            widget.isFavorite = false;
                          });
                        } else {
                          setState(() {
                            widget.isFavorite = true;
                          });
                        }
                        var _likeResponse = await AddDeleteProductToFavoriteProvider(isLiked: !widget.isFavorite, productUuid: widget.uuid).getisAddProductTofavoriteResponse();
                        if (_likeResponse == "old token") {
                          AuthPageBloc authPageBloc = BlocProvider.of(context);
                          BlocProvider.of<BasicPageBloc>(context)?.add(ProfilePage.logout(regBloc: authPageBloc, basicPageBloc: BlocProvider.of(context)));
                        }
                      } else {
                        AssortmentFilterButton().loginOrRegWarning(context);
                      }
                    },
                    child: SvgPicture.asset(
                      (widget.isFavorite != null && widget.isFavorite) ? "assets/images/newHeartConturActive.svg" : "assets/images/newHeartContur.svg",
                      width: 18,
                      height: 16,
                    ),
                  ),
                ),
                if (widget.rating != null) //рейтинг
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(5)), color: whiteColor),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/images/newStar.svg",
                            height: heightRatio(size: 12, context: context),
                            width: widthRatio(size: 12, context: context),
                          ),
                          SizedBox(width: widthRatio(size: 3, context: context)),
                          Text(
                            widget.rating != null ? widget.rating.toString() : '',
                            style: appHeadersTextStyle(fontSize: 11, color: newGrey),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (widget.priceWithDiscount != null && widget.currentPrice != null)
                  Positioned(
                    top: heightRatio(size: heightRatio(size: 7, context: context), context: context),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: newYellow, borderRadius: BorderRadius.circular(2)),
                      child: Text(
                        // ( (Исходная цена − Цена со скидкой) / Исходная цена) * 100
                        '-' + (((widget.currentPrice.toDouble() - widget.priceWithDiscount) / widget.currentPrice.toDouble()) * 100).toInt().toString() + '%',
                        style: appLabelTextStyle(fontSize: 11, color: whiteColor),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: heightRatio(size: heightRatio(size: 8, context: context), context: context)),
            SizedBox(
              height: heightRatio(size: 33, context: context),
              child: Text(
                widget.name != null ? '${widget.name}' : "",
                // (isFavorite != null && isFavorite) ? 'true' : 'false',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newBlack),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                // color: widget.assortmentsListModel.discountTypeColor == null ? colorBlack03 : Color(int.parse("0xff${widget.assortmentsListModel.discountTypeColor}")),
                color: (widget.hasYellowPrice != null && widget.hasYellowPrice == true) ? newYellow : newRedDark,
                borderRadius: BorderRadius.circular(heightRatio(size: 4, context: context)),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      style: appHeadersTextStyle(color: whiteColor, fontSize: heightRatio(size: 12, context: context)),
                      text: widget.priceWithDiscount == null ? widget.currentPrice.toString() : widget.priceWithDiscount.toString(),
                    ),
                    TextSpan(
                      text: " ${"rubleSignText".tr()}",
                      style: appTextStyle(color: whiteColor, fontWeight: FontWeight.w700, fontSize: heightRatio(size: 12, context: context)),
                    ),
                    TextSpan(
                      style: appHeadersTextStyle(color: whiteColor, fontSize: heightRatio(size: 12, context: context)),
                      text: "/${getAssortmentUnitId(assortmentUnitId: widget.assortmentUnitId)[1]}",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
