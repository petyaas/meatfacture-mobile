import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:smart/features/catalog/widgets/catalog_product_widget.dart';
import 'package:smart/custom_widgets/shimmer_loader_for_catalog.dart';
import 'package:smart/models/assortments_list_model.dart';
import 'package:smart/repositories/assortments_repository.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class FavProdSearchProductsBottomSheet extends StatefulWidget {
  @override
  State<FavProdSearchProductsBottomSheet> createState() => _FavProdSearchProductsBottomSheetState();
}

class _FavProdSearchProductsBottomSheetState extends State<FavProdSearchProductsBottomSheet> {
  GlobalKey<PaginationViewState> assormentsPaginationViewkey = GlobalKey<PaginationViewState>();

  bool isLoading = true;
  final TextEditingController _assortmentsSearchTextController = TextEditingController();
  Timer _timer;
  FocusNode _focusNodeForSearch = new FocusNode();
  String searchText;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _focusNodeForSearch.requestFocus();
  }

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
                      "searchingText".tr(),
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
            Container(
              margin: EdgeInsets.only(left: widthRatio(size: 15, context: context), right: widthRatio(size: 15, context: context), top: heightRatio(size: 20, context: context)),
              padding: EdgeInsets.only(left: widthRatio(size: 15, context: context), top: heightRatio(size: 10, context: context), bottom: heightRatio(size: 10, context: context)),
              decoration: BoxDecoration(color: grey04, borderRadius: BorderRadius.circular(heightRatio(size: 50, context: context))),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/searchIcon.svg",
                  ),
                  SizedBox(width: widthRatio(size: 10, context: context)),
                  Expanded(
                    child: TextField(
                        focusNode: _focusNodeForSearch,
                        onChanged: (value) {
                          setState(() {
                            currentPage = 1;
                            if (value.isEmpty) {
                              searchText = null;
                            } else {
                              searchText = value;
                            }
                          });
                          if (assormentsPaginationViewkey.currentState != null) {
                            if (_timer != null) {
                              _timer.cancel();
                            }
                            _timer = Timer(Duration(milliseconds: 600), () {
                              if (assormentsPaginationViewkey.currentState != null) {
                                assormentsPaginationViewkey.currentState.refresh();
                              }
                            });
                          }
                        },
                        controller: _assortmentsSearchTextController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          isDense: true,
                          // suffixIcon: GestureDetector(
                          //   onTap: () {
                          //     _assortmentsSearchTextController.text = "";
                          //     FocusScopeNode currentFocus =
                          //         FocusScope.of(context);
                          //     currentFocus.unfocus();
                          //     searchText = null;
                          //     if (assormentsPaginationViewkey.currentState !=
                          //         null) {
                          //       assormentsPaginationViewkey.currentState
                          //           .refresh();
                          //     }
                          //   },
                          //   child: Icon(
                          //     Icons.close,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          border: InputBorder.none,
                          hintText: 'findeProductText'.tr(),
                          hintStyle: appTextStyle(color: colorBlack04, fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w500),
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
                child: searchText == null || searchText.isEmpty
                    ? Container(color: Colors.white)
                    : PaginationView<AssortmentsListModel>(
                        key: assormentsPaginationViewkey,
                        initialLoader: ShimmerLoaderForCatalog(),
                        padding: EdgeInsets.only(left: widthRatio(size: 15, context: context), right: widthRatio(size: 15, context: context), top: heightRatio(size: 20, context: context)),
                        paginationViewType: PaginationViewType.gridView,
                        // preloadedItems: state.catalogsModel.data,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1.35,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, AssortmentsListModel assortmentsListModel, int index) => CatalogProductWidget(
                          isRecomendations: false,
                          isFavoriteProdiuctPicking: true,
                          assortmentsListModel: assortmentsListModel,
                        ),
                        pageFetch: (currentListSize) async {
                          List<AssortmentsListModel> fechedPage = await AssortmentsRepository(
                            //*********************  ПОИСК ******************/
                            searchText: searchText,
                            currentPage: currentPage++,
                          ).getAssortmentsFromRepositoryForPagination();
                          // state.catalogsModel.data += fechedPage;
                          if (fechedPage.isEmpty) {
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            isLoading = true;
                          }
                          return fechedPage;
                        },
                        onEmpty: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              color: colorBlack03,
                              size: heightRatio(size: 70, context: context),
                            ),
                            SizedBox(height: heightRatio(size: 10, context: context)),
                            Text(
                              "nothingFoundText".tr(),
                              style: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack08, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: heightRatio(size: 10, context: context)),
                            Text(
                              "tryagainOrChangeSerchText".tr(),
                              textAlign: TextAlign.center,
                              style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: colorBlack06, fontWeight: FontWeight.w500),
                            ),
                          ],
                        )),
                        bottomLoader: SizedBox(),
                        onError: (dynamic error) => Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: widthRatio(size: 20, context: context), right: widthRatio(size: 20, context: context)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                              topRight: Radius.circular(heightRatio(size: 15, context: context)),
                            ),
                          ),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
                                decoration: BoxDecoration(color: colorBlack03, shape: BoxShape.circle),
                                child: SvgPicture.asset(
                                  'assets/images/netErrorIcon.svg',
                                  color: Colors.white,
                                  height: heightRatio(size: 30, context: context),
                                ),
                              ),
                              SizedBox(height: heightRatio(size: 15, context: context)),
                              Text(
                                "errorText".tr(),
                                style: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: heightRatio(size: 10, context: context)),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentPage = 1;
                                    });
                                    if (assormentsPaginationViewkey.currentState != null) {
                                      assormentsPaginationViewkey.currentState.refresh();
                                    }
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Text("tryAgainText".tr(), style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500)),
                                  ))
                            ],
                          )),
                        ),
                        footer: isLoading
                            ? Container(
                                padding: EdgeInsets.symmetric(vertical: heightRatio(size: 15, context: context)),
                                width: screenHeight(context),
                                child: Center(
                                  // optional
                                  child: Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor))),
                                ),
                              )
                            : SizedBox(),
                      )),
          ],
        ));
  }
}
