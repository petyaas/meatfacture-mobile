import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc_files/basic_page_bloc.dart';
import 'package:smart/bloc_files/favorite_product_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/features/fav_product/widgets/fav_prod_picker_catalog_bottom_sheet.dart';
import 'package:smart/features/fav_product/widgets/fav_product_card.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/features/fav_product/fav_product_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class FavProductCardButton extends StatelessWidget {
  final now = DateTime.now();
  // любимые продукты
  @override
  Widget build(BuildContext context) {
    BasicPageBloc _basicPageBloc = BlocProvider.of(context);
    AuthPageBloc _authPageBloc = BlocProvider.of(context);
    FavoriteProductBloc _favoriteProductbloc = BlocProvider.of<FavoriteProductBloc>(context);
    return BlocConsumer<FavoriteProductBloc, FavoriteProductState>(
      listener: (context, state) {
        if (state is FavoriteProductOldTokenState) {
          ProfilePage.logout(regBloc: _authPageBloc, basicPageBloc: _basicPageBloc);
        }
      },
      builder: (context, state) {
        return InkWell(
          onTap: () async {
            if (state is FavoriteProductLoadedState) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FavProductPage()));
            } else {
              _favoriteProductbloc.add(FavoriteProductLoadEvent());
              Navigator.push(context, MaterialPageRoute(builder: (context) => FavProductPage()));
            }
          },
          child: Container(
            padding: EdgeInsets.all(widthRatio(size: 10, context: context)),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)),
              boxShadow: [BoxShadow(color: newShadow, offset: Offset(12, 12), blurRadius: 24, spreadRadius: 0)],
              // Тень
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)), color: newIconBg),
                      child: SvgPicture.asset("assets/images/newHeart.svg",
                          height: heightRatio(size: 28, context: context), width: widthRatio(size: 32, context: context), fit: BoxFit.scaleDown),
                    ),
                    SizedBox(width: widthRatio(size: 15, context: context)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Любимые продукты",
                            style: appHeadersTextStyle(fontSize: heightRatio(size: 15, context: context), color: newBlack),
                          ),
                          SizedBox(height: heightRatio(size: 5, context: context)),
                          Text(
                            state is FavoriteProductLoadedState &&
                                    (state.favoriteProductModel.data.isNotEmpty || state.favoriteProductVariantUuidModel.data.isNotEmpty)
                                ? "discontForAnyProductText".tr()
                                : "favoriteProdSubTitleText".tr(),
                            textAlign: TextAlign.start,
                            style: appLabelTextStyle(fontSize: heightRatio(size: 13, context: context), fontWeight: FontWeight.w400, color: newBlackLight),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: widthRatio(size: 10, context: context)),
                    Icon(Icons.arrow_forward_ios_rounded, color: newRedDark, size: heightRatio(size: 23, context: context)),
                  ],
                ),
                if (state is FavoriteProductLoadedState && state.favoriteProductModel.data.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: heightRatio(size: 15, context: context)),
                    child: Column(
                      children: [...state.favoriteProductModel.data.map((e) => FavProductCard(productModel: e))],
                    ),
                  ),
                if (state is FavoriteProductLoadedState && state.favoriteProductVariantUuidModel.data.isNotEmpty && state.favoriteProductModel.data.isEmpty)
                  InkWell(
                    onTap: () {
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
                          return FavProdPickerCatalogBottomSheet();
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: lightGreyColor,
                        borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: heightRatio(size: 15, context: context)),
                      margin: EdgeInsets.only(top: heightRatio(size: 15, context: context)),
                      child: Text(
                        "Выбрать любимый продукт",
                        style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newRedDark),
                      ),
                    ),
                  )
                else if (state is FavoriteProductLoadedState &&
                    state.favoriteProductVariantUuidModel.data.isNotEmpty &&
                    state.favoriteProductModel.data.length == 1 &&
                    !dateTimeConverter(state.favoriteProductVariantUuidModel.data.first.canBeActivatedTill).isAtSameMomentAs(
                      DateTime(now.year, now.month, now.day + 1),
                    ))
                  InkWell(
                    onTap: () {
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
                          return FavProdPickerCatalogBottomSheet();
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: lightGreyColor,
                        borderRadius: BorderRadius.circular(heightRatio(size: 15, context: context)),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: heightRatio(size: 15, context: context)),
                      margin: EdgeInsets.only(top: heightRatio(size: 15, context: context)),
                      child: Text(
                        "Изменить любимый продукт",
                        style: appLabelTextStyle(
                          fontSize: heightRatio(size: heightRatio(size: 14, context: context), context: context),
                          color: colorBlack06,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
