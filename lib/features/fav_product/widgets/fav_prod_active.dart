import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/favorite_product_bloc.dart';
import 'package:smart/features/fav_product/widgets/fav_prod_picker_catalog_bottom_sheet.dart';
import 'package:smart/features/fav_product/widgets/fav_product_card.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class FavProdActive extends StatelessWidget {
  final now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteProductBloc, FavoriteProductState>(
      builder: (context, state) {
        if (state is FavoriteProductLoadedState) {
          return Column(
            children: [
              SizedBox(height: heightRatio(size: 10, context: context)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                child: Text(
                  //"У вас выбран любимый\nпродукт на " + getMonthName(month: DateTime.now().month == 12 ? 1 : DateTime.now().month + 1),
                  "У вас выбран\nлюбимый продукт",
                  textAlign: TextAlign.center,
                  style: appLabelTextStyle(
                    fontSize: heightRatio(size: 22, context: context),
                    color: whiteColor,
                    height: 1.3,
                  ),
                ),
              ),
              SizedBox(height: heightRatio(size: 55, context: context)),
              if (state.favoriteProductModel.data.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                  child: Column(
                    children: [...state.favoriteProductModel.data.map((e) => FavProductCard(productModel: e))],
                  ),
                ),
              if ((state.favoriteProductModel.data.length == 1 && state.favoriteProductVariantUuidModel.data.isEmpty) ||
                  (state.favoriteProductModel.data.length == 1 &&
                      (state.favoriteProductVariantUuidModel.data.isNotEmpty &&
                          !dateTimeConverter(state.favoriteProductVariantUuidModel.data.first.canBeActivatedTill)
                              .isAtSameMomentAs(DateTime(now.year, now.month, now.day + 1)))))
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
                      builder: (BuildContext bc) => FavProdPickerCatalogBottomSheet(),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(color: newRedDark, borderRadius: BorderRadius.circular(heightRatio(size: 15, context: context))),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: heightRatio(size: 20, context: context)),
                    margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context), vertical: heightRatio(size: 15, context: context)),
                    child: Text(
                      "Изменить любимый продукт",
                      style: appLabelTextStyle(fontSize: heightRatio(size: heightRatio(size: 16, context: context), context: context), color: Colors.white),
                    ),
                  ),
                ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
