// ignore: implementation_imports
import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc_files/assortment_filter_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/catalog/subcatalog_screen.dart';

// ignore: must_be_immutable
class AssortmentFilterBottomSheet extends StatefulWidget {
  final String subcatalogUuid;
  final String catalogUuid;

  const AssortmentFilterBottomSheet({this.subcatalogUuid, this.catalogUuid});

  @override
  _AssortmentFilterBottomSheetState createState() => _AssortmentFilterBottomSheetState();
}

class _AssortmentFilterBottomSheetState extends State<AssortmentFilterBottomSheet> {
  int i = 1;
  final TextEditingController searchTextController = TextEditingController();
  bool isFavorite = false;
  bool isYellowTags = false;
  @override
  Widget build(BuildContext context) {
    AssortmentFiltersBloc _assortmentFiltersBloc = BlocProvider.of<AssortmentFiltersBloc>(context);

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(heightRatio(size: 15, context: context)),
        topRight: Radius.circular(heightRatio(size: 15, context: context)),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: heightRatio(size: 25, context: context)),
            Text(
              'Укажите нужные фильтры',
              style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), color: newBlack),
            ),
            SizedBox(height: heightRatio(size: 30, context: context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      "assets/images/newHeart.svg",
                      height: heightRatio(size: 18, context: context),
                      width: widthRatio(size: 21, context: context),
                      fit: BoxFit.scaleDown,
                    ),
                    SizedBox(width: widthRatio(size: 15, context: context)),
                    Text(
                      "shosenProducts2".tr(),
                      style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                    ),
                  ],
                ),
                CupertinoSwitch(
                  value: isFavorite,
                  onChanged: (val) {
                    setState(() => isFavorite = val);
                  },
                ),
              ],
            ),
            Divider(),
            SizedBox(height: heightRatio(size: 10, context: context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      "assets/images/newYellowPrice.svg",
                      height: heightRatio(size: 18, context: context),
                      width: widthRatio(size: 21, context: context),
                      fit: BoxFit.scaleDown,
                    ),
                    SizedBox(width: widthRatio(size: 15, context: context)),
                    Text(
                      "yellowTagsText".tr(),
                      style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                    ),
                  ],
                ),
                CupertinoSwitch(
                  value: isYellowTags,
                  onChanged: (val) {
                    setState(() => isYellowTags = val);
                  },
                ),
              ],
            ),
            Divider(),
            SizedBox(height: heightRatio(size: 10, context: context)),
            SizedBox(height: heightRatio(size: 5, context: context)),
            InkWell(
              onTap: () {
                if (isFavorite == false && isYellowTags == false) {
                  Navigator.pop(context);
                  print('======================= IF  isFavorite == false && isYellowTags == false  ===============================');
                } else {
                  print('=======================  isFavorite == false && isYellowTags == false  ELSE ===============================');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubcatalogScreen(
                        preCataloUuid: widget.catalogUuid,
                        uuidForAllProductsInCatalog: widget.subcatalogUuid,
                        isSearchPage: false,
                        isFavorite: isFavorite,
                        isPromoAssortment: isYellowTags,
                        preCataloName: "",
                      ),
                    ),
                  );
                }
                log('isFavorite = $isFavorite');
                log('isYellowTags = $isYellowTags');
                _assortmentFiltersBloc.add(
                  AssortmentFiltersLoadEvent(
                    isFavorite: isFavorite,
                    isYellowTags: isYellowTags,
                  ),
                );
                print('+++++++++++ _assortmentFiltersBloc.add(AssortmentFiltersLoadEvent(isFavorite: isFavorite))');
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: heightRatio(size: 16, context: context)),
                alignment: Alignment.center,
                child: Text("Применить фильтры", style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: Colors.white)),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)), color: newRedDark),
              ),
            ),
            SizedBox(height: heightRatio(size: 35, context: context)),
          ],
        ),
      ),
    );
  }
}
