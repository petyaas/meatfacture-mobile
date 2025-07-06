import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_fav_prod_picker_products_bottom_sheet.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_fav_prod_search_products_bottom_sheet.dart';
import 'package:smart/custom_widgets/shimmer_loader_for_catalog.dart';
import 'package:smart/features/catalog/models/catalog_list_model.dart';
import 'package:smart/features/catalog/repositories/catalogs_repository.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class FavProdPickerSubcatalogBottomSheet extends StatelessWidget {
  final String preCataloName;
  final String preCataloUuid;
  const FavProdPickerSubcatalogBottomSheet({@required this.preCataloName, @required this.preCataloUuid});

  @override
  Widget build(BuildContext context) {
    int currentPage = 1;
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
            Padding(
              padding: EdgeInsets.only(
                top: heightRatio(size: 20, context: context),
                left: widthRatio(size: 15, context: context),
                right: widthRatio(size: 15, context: context),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: widthRatio(size: 10, context: context)),
                      color: Colors.transparent,
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: heightRatio(size: 25, context: context),
                        color: blackColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      preCataloName,
                      textAlign: TextAlign.start,
                      style: appTextStyle(fontSize: heightRatio(size: 20, context: context), fontWeight: FontWeight.w800),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        padding: EdgeInsets.all(widthRatio(size: 10, context: context)),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: colorBlack03),
                        child: SvgPicture.asset(
                          "assets/images/ close_icon.svg",
                          color: colorBlack04,
                        )),
                  )
                ],
              ),
            ),
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
                      return FavProdSearchProductsBottomSheet();
                    });
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: widthRatio(size: 15, context: context), right: widthRatio(size: 15, context: context), top: heightRatio(size: 20, context: context)),
                padding: EdgeInsets.only(
                    left: widthRatio(size: 15, context: context),
                    top: heightRatio(size: 10, context: context),
                    bottom: heightRatio(size: 10, context: context)),
                decoration: BoxDecoration(color: grey04, borderRadius: BorderRadius.circular(heightRatio(size: 50, context: context))),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/searchIcon.svg",
                    ),
                    SizedBox(width: widthRatio(size: 10, context: context)),
                    Text(
                      "findeProductText".tr(),
                      style: appTextStyle(color: colorBlack04, fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: PaginationView<CatalogListModel>(
              header: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: heightRatio(size: 5, context: context)),
                    child: InkWell(
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
                              return FavProdPickerProductsBottomSheet(
                                uuidForAllProductsInCatalog: preCataloUuid,
                                name: preCataloName,
                              );
                            });
                      },
                      child: ListTile(
                        title: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/listIcon.svg',
                              color: Colors.black,
                            ),
                            SizedBox(width: widthRatio(size: 10, context: context)),
                            Text(
                              "Все товары",
                              style: appTextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.w500,
                                fontSize: heightRatio(size: 17, context: context),
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: colorBlack03,
                          size: heightRatio(size: 20, context: context),
                        ),
                      ),
                    ),
                  ),
                  Divider()
                ],
              ),

              initialLoader: ShimmerLoaderForCatalog(),
              padding: EdgeInsets.only(
                  left: widthRatio(size: 5, context: context), right: widthRatio(size: 5, context: context), top: heightRatio(size: 5, context: context)),
              paginationViewType: PaginationViewType.listView,
              // preloadedItems: state.catalogsModel.data,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.3,
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, CatalogListModel subcatalogListModel, int index) => InkWell(
                  onTap: () {
                    if (subcatalogListModel.isFinalLevel) {
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
                            return FavProdPickerProductsBottomSheet(
                              uuid: subcatalogListModel.uuid,
                              name: subcatalogListModel.name,
                            );
                          });
                    } else {
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
                            return FavProdPickerSubcatalogBottomSheet(preCataloName: subcatalogListModel.name, preCataloUuid: subcatalogListModel.uuid);
                          });
                    }
                  },
                  child: Container(
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${subcatalogListModel.name}  ",
                                  style: appTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: heightRatio(size: 17, context: context),
                                  ),
                                ),
                              ),
                              Text("${subcatalogListModel.assortmentsCountInStore ?? ""}",
                                  style: appTextStyle(color: colorBlack04, fontSize: heightRatio(size: 14, context: context))),
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: colorBlack03,
                            size: heightRatio(size: 20, context: context),
                          ),
                        ),
                        Divider()
                      ],
                    ),
                  )),
              pageFetch: (currentListSize) async {
                List<CatalogListModel> fechedPage =
                    await CatalogsRepository(currentPage: currentPage, catalogUuid: preCataloUuid).getCatalogsFromRepositoryforPagination();
                currentPage++;
                return fechedPage;
              },
              onEmpty: Center(
                child: Text('emptyText'.tr()),
              ),
              bottomLoader: Center(
                // optional
                child: Center(child: CircularProgressIndicator()),
              ),
              onError: (dynamic error) => Center(
                child: Text('errorText'.tr()),
              ),
            )),
          ],
        ));
  }
}
