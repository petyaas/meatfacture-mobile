import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:smart/bloc_files/assortment_filter_bloc.dart';
import 'package:smart/features/catalog/bloc/catalogs_bloc.dart';
import 'package:smart/custom_widgets/assortment_filter_button.dart';
import 'package:smart/features/addresses/addresses_change_selected_shop_bottom_sheet.dart';
import 'package:smart/features/catalog/subcatalog_screen.dart';
import 'package:smart/models/assortments_model.dart';
import 'package:smart/pages/redesigned_pages/redes_product_details_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/bloc_files/order_type_bloc.dart';
import 'package:smart/custom_widgets/redesigned_widgets/to_free_delivery_widget.dart';
import 'package:smart/custom_widgets/shimmer_loader_for_catalog.dart';

class SubcatalogsListPage extends StatefulWidget {
  final String preCataloName;
  final String preCataloUuid;

  const SubcatalogsListPage({@required this.preCataloName, @required this.preCataloUuid});

  @override
  State<SubcatalogsListPage> createState() => _SubcatalogsListPageState();
}

class _SubcatalogsListPageState extends State<SubcatalogsListPage> with AutomaticKeepAliveClientMixin {
  GlobalKey<PaginationViewState> subCatalogPaginationViewkey = GlobalKey<PaginationViewState>();

  void openShopDetailsBottomSheet(BuildContext context) {
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
          return AddressesChangeSelectedShopBottomSheet();
        }).then((value) {});
  }

  int i = 1;

  final ScrollController scrollController = ScrollController();

  CatalogsBloc catalogsBloc;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        catalogsBloc.add(CatalogstNextPageEvent(catalogUuid: widget.preCataloUuid));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AssortmentFiltersBloc _assortmentFiltersBloc = BlocProvider.of<AssortmentFiltersBloc>(context);
    _assortmentFiltersBloc.add(AssortmentFiltersLoadEvent(isFavorite: false));
    return BlocProvider(
      create: (context) => CatalogsBloc(),
      child: BlocBuilder<CatalogsBloc, CatalogsState>(
        builder: (context, state) {
          catalogsBloc = BlocProvider.of(context);

          if (state is CatalogsInitState) {
            catalogsBloc.add(CatalogsLoadEvent(catalogUuid: widget.preCataloUuid));
          }
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              color: mainColor,
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SafeArea(
                      child: Container(
                          margin: EdgeInsets.only(right: widthRatio(size: 15, context: context), left: widthRatio(size: 15, context: context)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          InkWell(
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Icon(Icons.arrow_back_ios_new_rounded, size: heightRatio(size: 25, context: context), color: whiteColor),
                                            ),
                                            onTap: () => Navigator.pop(context),
                                          ),
                                          SizedBox(width: widthRatio(size: 10, context: context)),
                                          Expanded(
                                              child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              'widget.preCataloName',
                                              style: appHeadersTextStyle(color: whiteColor, fontSize: heightRatio(size: 22, context: context)),
                                            ),
                                          )),
                                          SizedBox(width: widthRatio(size: 5, context: context))
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: widthRatio(size: 15, context: context)),
                                  AssortmentFilterButton(subcatalogUuid: widget.preCataloUuid),
                                  SizedBox(width: widthRatio(size: 15, context: context)),
                                  InkWell(
                                    onTap: () async {
                                      var scanOptions = ScanOptions(strings: {
                                        "cancel": "cancelText".tr(),
                                        "flash_on": "flashOnText".tr(),
                                        "flash_off": "flashoffText".tr(),
                                      });
                                      var result = await BarcodeScanner.scan(options: scanOptions);
                                      AssortmentsModel _assortmentsModel =
                                          await AssortmentsProvider(isRecommendations: null, currentPage: 1, barcodes: result.rawContent).getAssortments();

                                      if (_assortmentsModel.data.isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          new CupertinoPageRoute(builder: (context) => RedesProductDetailsPage(productUuid: _assortmentsModel.data[0].uuid)),
                                        );
                                      } else {
                                        Fluttertoast.showToast(msg: "cantFindProduct".tr());
                                      }
                                    },
                                    child: Container(
                                        width: widthRatio(size: 40, context: context),
                                        height: heightRatio(size: 40, context: context),
                                        padding: EdgeInsets.all(widthRatio(size: 11, context: context)),
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: white03),
                                        child: SvgPicture.asset(
                                          'assets/images/qrCodeIcon.svg',
                                          height: heightRatio(size: 20, context: context),
                                          width: widthRatio(size: 20, context: context),
                                        )),
                                  )
                                ],
                              ),
                              SizedBox(height: heightRatio(size: 20, context: context))
                            ],
                          )),
                    ),
                    Expanded(
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                            topRight: Radius.circular(heightRatio(size: 15, context: context)),
                          ),
                          color: whiteColor,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  if (state is CatalogsLoadingState && state.catalogsList.isEmpty) {
                                    return ShimmerLoaderForCatalog();
                                  }
                                  if (state is CatalogsErrorState) {
                                    return Container(
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
                                              style: appTextStyle(
                                                fontSize: heightRatio(size: 18, context: context),
                                                color: colorBlack06,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: heightRatio(size: 10, context: context)),
                                            InkWell(
                                              onTap: () {
                                                setState(() => i = 1);
                                                subCatalogPaginationViewkey.currentState.refresh();
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Text(
                                                  "tryAgainText".tr(),
                                                  style: appTextStyle(
                                                    fontSize: heightRatio(size: 14, context: context),
                                                    color: mainColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return Stack(
                                    children: [
                                      SingleChildScrollView(
                                        controller: scrollController,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: heightRatio(size: 55, context: context),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(),
                                                    Padding(
                                                      padding: EdgeInsets.only(top: heightRatio(size: 5, context: context)),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => SubcatalogScreen(
                                                                uuidForAllProductsInCatalog: widget.preCataloUuid,
                                                                isSearchPage: false,
                                                                preCataloName: widget.preCataloName,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                SvgPicture.asset('assets/images/listIcon.svg', color: Colors.black),
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
                                                            Icon(Icons.arrow_forward_ios, color: colorBlack03, size: 20),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Divider(height: 0),
                                                  ],
                                                ),
                                              ),
                                              ListView.builder(
                                                padding: EdgeInsets.zero,
                                                itemCount: state.catalogsList.length,
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) => InkWell(
                                                    onTap: () {
                                                      if (state.catalogsList[index].isFinalLevel) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => SubcatalogScreen(
                                                              isSearchPage: false,
                                                              tagsListFromCatalog: state.catalogsList[index].assortmentsTagsInStore,
                                                              preCataloName: state.catalogsList[index].name,
                                                              preCataloUuid: state.catalogsList[index].uuid,
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => SubcatalogsListPage(
                                                              preCataloName: state.catalogsList[index].name,
                                                              preCataloUuid: state.catalogsList[index].uuid,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      height: heightRatio(size: 55, context: context),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Expanded(
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Text(
                                                                          "${state.catalogsList[index].name}  ",
                                                                          style: appTextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: heightRatio(size: 17, context: context),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        "${state.catalogsList[index].assortmentsCountInStore ?? ""}",
                                                                        style: appTextStyle(color: colorBlack04),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Icon(Icons.arrow_forward_ios, color: colorBlack03, size: 20),
                                                              ],
                                                            ),
                                                          ),
                                                          Divider(height: 0)
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                              if (state is CatalogsLoadingState && state.catalogsList.isNotEmpty)
                                                Padding(
                                                  padding: EdgeInsets.only(top: heightRatio(size: 20, context: context)),
                                                  child: Center(
                                                    child: CircularProgressIndicator(strokeWidth: 3.0, valueColor: AlwaysStoppedAnimation<Color>(mainColor)),
                                                  ),
                                                ),
                                              SizedBox(height: heightRatio(size: 100, context: context)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      BlocBuilder<OrderTypeBloc, OrderTypeState>(
                                        builder: (context, state) {
                                          if (state is OrderTypeDeliveryState) {
                                            return Positioned(bottom: 0, left: 0, right: 0, child: ToFreeDeliveryWidget());
                                          } else {
                                            return SizedBox();
                                          }
                                        },
                                      )
                                    ],
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // ))
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
