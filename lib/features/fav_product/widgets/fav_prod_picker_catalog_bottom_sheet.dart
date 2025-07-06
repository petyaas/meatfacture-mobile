import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/fav_product/widgets/fav_catalogs_list.dart';
import 'package:smart/features/catalog/subcatalog_screen.dart';

class FavProdPickerCatalogBottomSheet extends StatefulWidget {
  @override
  State<FavProdPickerCatalogBottomSheet> createState() => _FavProdPickerCatalogBottomSheetState();
}

class _FavProdPickerCatalogBottomSheetState extends State<FavProdPickerCatalogBottomSheet> {
  int currentPage = 1;
  bool isloading = true;
  GlobalKey<PaginationViewState> paginationViewkey = GlobalKey<PaginationViewState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      height: screenHeight(context) * 0.8,
      width: screenWidth(context),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(heightRatio(size: 15, context: context)),
          topRight: Radius.circular(heightRatio(size: 15, context: context)),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: heightRatio(size: 25, context: context)),
          Text(
            "Выберите товар из каталога",
            style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), color: newBlack),
          ),
          InkWell(
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SubcatalogScreen(isSearchPage: true)));
            },
            child: Container(
              height: heightRatio(size: 50, context: context),
              margin: EdgeInsets.only(left: widthRatio(size: 15, context: context), right: widthRatio(size: 15, context: context), top: heightRatio(size: 20, context: context)),
              padding: EdgeInsets.only(left: widthRatio(size: 15, context: context), top: heightRatio(size: 10, context: context), bottom: heightRatio(size: 10, context: context)),
              decoration: BoxDecoration(color: newGrey2, borderRadius: BorderRadius.circular(heightRatio(size: 50, context: context))),
              child: Row(
                children: [
                  SvgPicture.asset("assets/images/searchIcon.svg", color: colorBlack04),
                  SizedBox(width: widthRatio(size: 15, context: context)),
                  Text(
                    "findeProductText".tr(),
                    style: appLabelTextStyle(color: colorBlack04, fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: heightRatio(size: 2, context: context)),
          Expanded(
            child: FavCatalogsList(),
          ),
        ],
      ),
    );
  }
}
