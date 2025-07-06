import 'dart:async';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc_files/order_type_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/custom_widgets/assortment_filter_button.dart';
import 'package:smart/custom_widgets/assortment_search_button.dart';
import 'package:smart/features/addresses/addresses_change_selected_shop_bottom_sheet.dart';
import 'package:smart/custom_widgets/redesigned_widgets/to_free_delivery_widget.dart';
import 'package:smart/custom_widgets/shimmer_loader_for_catalog.dart';
import 'package:smart/features/catalog/bloc/assortments_list_bloc.dart';
import 'package:smart/features/catalog/bloc/catalogs_bloc.dart';
import 'package:smart/features/catalog/widgets/catalog_product_widget.dart';
import 'package:smart/main.dart';
import 'package:smart/models/assortments_list_model.dart';

// ignore: must_be_immutable
class SubcatalogScreen extends StatefulWidget {
  final String preCataloName;
  final String preCataloUuid;
  final uuidForAllProductsInCatalog;
  final List<String> brandName;
  String searchText;
  final bool isFavorite;
  final bool isSearchPage;
  final bool isPromoAssortment;
  final bool isRecommendations;
  final List<String> activeTagsList;
  List<String> tagsListFromCatalog = [];
  final bool isFinalLevel;
  final bool isFromFavCatalogsList;

  SubcatalogScreen({
    this.preCataloName,
    this.preCataloUuid,
    this.brandName,
    this.searchText,
    this.isFavorite,
    this.isRecommendations,
    this.activeTagsList,
    this.isSearchPage = false,
    this.uuidForAllProductsInCatalog,
    this.isPromoAssortment,
    this.tagsListFromCatalog,
    this.isFinalLevel = false,
    this.isFromFavCatalogsList = false,
  });

  @override
  State<SubcatalogScreen> createState() => _SubcatalogScreenState();
}

class _SubcatalogScreenState extends State<SubcatalogScreen> with AutomaticKeepAliveClientMixin {
  final TextEditingController _assortmentsSearchTextController = TextEditingController();

  void openShopDetailsBottomSheet(BuildContext context, SecondaryPageEvent secondaryPageEvent) {
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
        builder: (BuildContext bc) => AddressesChangeSelectedShopBottomSheet()).then(
      (value) {},
    );
  }

  FocusNode _focusNodeForSearch = new FocusNode();
  final ScrollController scrollController = ScrollController();
  AssortmentsListBloc assortmentsListBloc;
  bool isFirstStart = prefs.getBool(SharedKeys.isFirstStart);

  @override
  void initState() {
    super.initState();
    print('init one time');
    _focusNodeForSearch.requestFocus();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - scrollController.position.pixels < 450.0) {
        assortmentsListBloc.add(
          AssortmentsListNextPageEvent(
            isPromoAssortment: widget.isPromoAssortment,
            uuidForAllProductsInCatalog: widget.uuidForAllProductsInCatalog,
            activeTagsList: widget.activeTagsList,
            brandName: widget.brandName,
            isFavorite: widget.isFavorite,
            isRecommendations: widget.isRecommendations,
            searchText: widget.searchText,
            preCataloUuid: widget.preCataloUuid,
          ),
        );
      }
    });
  }

  Timer _timer;
  bool isLoading = true;
  String currentSubCatalogUuid;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AssortmentsListBloc()),
        BlocProvider(create: (context) => CatalogsBloc()..add(CatalogsLoadEvent(catalogUuid: widget.preCataloUuid))),
      ],
      child: BlocConsumer<CatalogsBloc, CatalogsState>(
        listener: (context, state) {
          if (state is CatalogsLoadedState) {
            print('loaded CatalogsLoadedState ${state.catalogsList.first.uuid}');
            currentSubCatalogUuid = state.catalogsList.first.uuid;
            if ((widget.isFavorite != null) &&
                (widget.isFavorite == false) &&
                (widget.isPromoAssortment != null) &&
                (widget.isPromoAssortment == false)) {
              print('НЕ ДОЛЖЕН тк widget.isFavorite == ${widget.isFavorite} и widget.isPromoAssortment = ${widget.isPromoAssortment}');
              print('uuidForAllProductsInCatalog = ${widget.uuidForAllProductsInCatalog}');
              print('preCataloUuid = ${widget.preCataloUuid}');
              assortmentsListBloc.add(
                AssortmentsListLoadEvent(
                  isPromoAssortment: widget.isPromoAssortment,
                  uuidForAllProductsInCatalog: widget.uuidForAllProductsInCatalog,
                  activeTagsList: widget.activeTagsList,
                  brandName: widget.brandName,
                  isFavorite: widget.isFavorite,
                  isRecommendations: widget.isRecommendations,
                  searchText: widget.searchText,
                  preCataloUuid: widget.preCataloUuid,
                  isAllSubcatalogsWithoutFavorite: widget.isFinalLevel == false ? true : false,
                  subcatalogUuid: currentSubCatalogUuid,
                ),
              );
            } else if (widget.isFinalLevel == false && widget.preCataloUuid != null) {
              print('НЕ понятно Должен или НЕТ - без него ошибка у избранного');
              print('uuidForAllProductsInCatalog = ${widget.uuidForAllProductsInCatalog}');
              print('widget.preCataloUuid = ${widget.preCataloUuid}');
              assortmentsListBloc.add(
                AssortmentsListLoadEvent(
                  isPromoAssortment: widget.isPromoAssortment,
                  uuidForAllProductsInCatalog: widget.uuidForAllProductsInCatalog,
                  activeTagsList: widget.activeTagsList,
                  brandName: widget.brandName,
                  isFavorite: widget.isFavorite,
                  isRecommendations: widget.isRecommendations,
                  searchText: widget.searchText,
                  preCataloUuid: widget.preCataloUuid,
                  isAllSubcatalogsWithoutFavorite: true,
                  subcatalogUuid: currentSubCatalogUuid,
                ),
              );
            }
          }
        },
        builder: (context, catalogsState) {
          return Stack(
            children: [
              BlocBuilder<AssortmentsListBloc, AssortmentsListState>(
                builder: (context, state) {
                  assortmentsListBloc = BlocProvider.of(context);
                  if (state is AssortmentsListInitState) {
                    print('AssortmentsListInitState one time');
                    if (widget.isFinalLevel ||
                        (widget.isFavorite != null && widget.isFavorite == true) ||
                        (widget.isPromoAssortment != null && widget.isPromoAssortment == true)) {
                      print('тут должен');
                      assortmentsListBloc.add(
                        AssortmentsListLoadEvent(
                          isPromoAssortment: widget.isPromoAssortment,
                          uuidForAllProductsInCatalog: widget.uuidForAllProductsInCatalog,
                          activeTagsList: widget.activeTagsList,
                          brandName: widget.brandName,
                          isFavorite: widget.isFavorite,
                          isRecommendations: widget.isRecommendations,
                          searchText: widget.searchText,
                          preCataloUuid: widget.preCataloUuid, //приходит родительская категория
                          subcatalogUuid: currentSubCatalogUuid,
                        ),
                      );
                    }
                  }
                  return Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: Container(
                      decoration: BoxDecoration(gradient: mainGradient),
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SafeArea(
                            child: Container(
                              margin: EdgeInsets.only(
                                bottom: heightRatio(size: 12, context: context),
                                right: widthRatio(size: 17, context: context),
                                left: widthRatio(size: 12, context: context),
                                top: heightRatio(size: 4, context: context),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: !widget.isSearchPage
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                      left: widthRatio(size: 2, context: context),
                                                      right: widthRatio(size: 5, context: context),
                                                    ),
                                                    color: Colors.transparent,
                                                    child: Icon(Icons.arrow_back_ios_new_rounded,
                                                        size: heightRatio(size: 22, context: context), color: whiteColor),
                                                  ),
                                                  onTap: () => Navigator.pop(context),
                                                ),
                                                SizedBox(width: widthRatio(size: 8, context: context)),
                                                Expanded(
                                                  child: Text(
                                                    //каталог уже товары тут наименование подкатегории
                                                    widget.isFavorite != null && widget.isFavorite == true
                                                        ? 'Избранные товары'
                                                        : widget.isPromoAssortment != null && widget.isPromoAssortment == true
                                                            ? 'Товары с желтыми ценниками'
                                                            : widget.preCataloName ?? "",
                                                    style: appLabelTextStyle(
                                                      color: Colors.white,
                                                      fontSize: heightRatio(size: 22, context: context),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  child: Container(
                                                    padding: EdgeInsets.only(left: 2, right: 5),
                                                    color: Colors.transparent,
                                                    child: Icon(
                                                      Icons.arrow_back_ios_new_rounded,
                                                      size: heightRatio(size: 22, context: context),
                                                      color: whiteColor,
                                                    ),
                                                  ),
                                                  onTap: () => Navigator.pop(context),
                                                ),
                                                SizedBox(width: widthRatio(size: 8, context: context)),
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: white04,
                                                      borderRadius: BorderRadius.circular(heightRatio(size: 50, context: context)),
                                                    ),
                                                    child: TextField(
                                                      focusNode: _focusNodeForSearch,
                                                      onChanged: (value) {
                                                        if (value.length > 1) {
                                                          setState(() {
                                                            if (value.isEmpty) {
                                                              widget.searchText = null;
                                                            } else {
                                                              widget.searchText = value;
                                                            }
                                                          });

                                                          if (_timer != null) {
                                                            _timer.cancel();
                                                          }
                                                          _timer = Timer(Duration(milliseconds: 600), () {
                                                            assortmentsListBloc.add(
                                                              AssortmentsListLoadEvent(
                                                                isPromoAssortment: widget.isPromoAssortment,
                                                                uuidForAllProductsInCatalog: widget.uuidForAllProductsInCatalog,
                                                                activeTagsList: widget.activeTagsList,
                                                                brandName: widget.brandName,
                                                                isFavorite: widget.isFavorite,
                                                                isRecommendations: widget.isRecommendations,
                                                                searchText: widget.searchText,
                                                                preCataloUuid: widget.preCataloUuid,
                                                              ),
                                                            );
                                                          });
                                                        }
                                                      },
                                                      controller: _assortmentsSearchTextController,
                                                      decoration: InputDecoration(
                                                        suffixIcon: GestureDetector(
                                                          onTap: () {
                                                            _assortmentsSearchTextController.text = "";
                                                            FocusScopeNode currentFocus = FocusScope.of(context);
                                                            currentFocus.unfocus();
                                                            widget.searchText = null;
                                                            assortmentsListBloc.add(
                                                              AssortmentsListLoadEvent(
                                                                isPromoAssortment: widget.isPromoAssortment,
                                                                uuidForAllProductsInCatalog: widget.uuidForAllProductsInCatalog,
                                                                activeTagsList: widget.activeTagsList,
                                                                brandName: widget.brandName,
                                                                isFavorite: widget.isFavorite,
                                                                isRecommendations: widget.isRecommendations,
                                                                searchText: widget.searchText,
                                                                preCataloUuid: widget.preCataloUuid,
                                                              ),
                                                            );
                                                          },
                                                          child: Icon(Icons.close, color: Colors.white),
                                                        ),
                                                        prefixIconConstraints: BoxConstraints(
                                                          maxHeight: heightRatio(size: 20, context: context),
                                                        ),
                                                        prefixIcon: Padding(
                                                          padding: EdgeInsets.only(
                                                            right: widthRatio(size: 5, context: context),
                                                            left: widthRatio(size: 10, context: context),
                                                          ),
                                                          child: SvgPicture.asset(
                                                            'assets/images/searchIcon.svg',
                                                            width: widthRatio(size: 15, context: context),
                                                            color: white03,
                                                            height: heightRatio(size: 15, context: context),
                                                          ),
                                                        ),
                                                        border: InputBorder.none,
                                                        hintText: 'findeProductText'.tr(),
                                                        hintStyle: appTextStyle(
                                                          color: white04,
                                                          fontSize: heightRatio(size: 14, context: context),
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      style: appTextStyle().copyWith(
                                                        color: Colors.white,
                                                        fontSize: heightRatio(size: 18, context: context),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                  !widget.isSearchPage
                                      ? widget.isRecommendations == null &&
                                                  widget.isRecommendations != false &&
                                                  widget.isFavorite == null ||
                                              widget.isFavorite != true &&
                                                  widget.isPromoAssortment == null &&
                                                  widget.isPromoAssortment != true
                                          ? Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                AssortmentSearchButton(
                                                  onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => SubcatalogScreen(isSearchPage: true)),
                                                  ),
                                                ),
                                                SizedBox(width: widthRatio(size: 6, context: context)),
                                                AssortmentFilterButton(catalogUuid: widget.preCataloUuid),
                                              ],
                                            )
                                          : SizedBox.shrink()
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ), //шапка завершение
                          Expanded(
                            // Подкаталог, тело начало
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(heightRatio(size: 15, context: context)),
                                topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                              ),
                              child: widget.isSearchPage && (widget.searchText == null || widget.searchText.isEmpty)
                                  ? Container(color: whiteColor)
                                  : Container(
                                      color: whiteColor,
                                      child: Column(
                                        children: [
                                          if (!widget.isFinalLevel &&
                                              !widget.isSearchPage &&
                                              (widget.isFavorite == null || widget.isFavorite == false) &&
                                              (widget.isPromoAssortment == null || widget.isPromoAssortment == false))
                                            Builder(
                                              builder: (context) {
                                                return catalogsState is CatalogsLoadingState
                                                    ? SizedBox.shrink()
                                                    : catalogsState is CatalogsLoadedState
                                                        ? SingleChildScrollView(
                                                            padding: const EdgeInsets.only(left: 18, right: 18, top: 16),
                                                            scrollDirection: Axis.horizontal,
                                                            child: Row(
                                                              children: catalogsState.catalogsList.map((podcatalog) {
                                                                return InkWell(
                                                                  onTap: () {
                                                                    currentSubCatalogUuid = podcatalog.uuid;
                                                                    assortmentsListBloc.add(
                                                                      AssortmentsListLoadEvent(
                                                                        isPromoAssortment: widget.isPromoAssortment,
                                                                        uuidForAllProductsInCatalog: widget.uuidForAllProductsInCatalog,
                                                                        activeTagsList: widget.activeTagsList,
                                                                        brandName: widget.brandName,
                                                                        isFavorite: widget.isFavorite,
                                                                        isRecommendations: widget.isRecommendations,
                                                                        searchText: widget.searchText,
                                                                        preCataloUuid: widget.preCataloUuid,
                                                                        isAllSubcatalogsWithoutFavorite: true,
                                                                        subcatalogUuid: currentSubCatalogUuid,
                                                                      ),
                                                                    );
                                                                    print('uuid = ${podcatalog.uuid}');
                                                                  },
                                                                  child: Container(
                                                                    height: 30,
                                                                    alignment: Alignment.center,
                                                                    decoration: BoxDecoration(
                                                                      color:
                                                                          currentSubCatalogUuid == podcatalog.uuid ? newRedDark : newBlack,
                                                                      borderRadius: BorderRadius.circular(25),
                                                                    ),
                                                                    margin: EdgeInsets.only(right: 6),
                                                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                                                    child: Text(
                                                                      podcatalog.name ?? '',
                                                                      style: appLabelTextStyle(
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w400,
                                                                        color: whiteColor,
                                                                        height: 1,
                                                                      ),
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ),
                                                          )
                                                        : SizedBox();
                                              },
                                            ),
                                          Expanded(
                                            child: Builder(
                                              builder: (context) {
                                                if (state is AssortmentsListLoadingState && state.assortmentsList.isEmpty) {
                                                  return Padding(
                                                    //шимер товаров без подкатологов  и с
                                                    padding: EdgeInsets.only(
                                                      top: heightRatio(size: 16, context: context),
                                                      left: widthRatio(size: 19, context: context),
                                                      right: widthRatio(size: 19, context: context),
                                                    ),
                                                    child: ShimmerLoaderForCatalog(
                                                      childAspectRatio: widget.isSearchPage || widget.isFinalLevel //высота элемента
                                                          ? 0.64
                                                          : screenWidth <= 385
                                                              ? screenWidth <= 34
                                                                  ? 0.75 //small phone там широко и расстяния по вертикали увеличены
                                                                  : 0.7 //samsung a54
                                                              : 0.61,
                                                      crossAxisSpacing: 16, // расстояние по горизонтали между элементами
                                                      crossAxisCount: 2,
                                                      spaceY: 32,
                                                    ),
                                                  );
                                                }

                                                if (state is AssortmentsListErrorState) {
                                                  return Container(
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.only(
                                                      left: widthRatio(size: 20, context: context),
                                                      right: widthRatio(size: 20, context: context),
                                                    ),
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
                                                              assortmentsListBloc.add(
                                                                AssortmentsListLoadEvent(
                                                                  isPromoAssortment: widget.isPromoAssortment,
                                                                  uuidForAllProductsInCatalog: widget.uuidForAllProductsInCatalog,
                                                                  activeTagsList: widget.activeTagsList,
                                                                  brandName: widget.brandName,
                                                                  isFavorite: widget.isFavorite,
                                                                  isRecommendations: widget.isRecommendations,
                                                                  searchText: widget.searchText,
                                                                  preCataloUuid: widget.preCataloUuid,
                                                                ),
                                                              );
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
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }

                                                if (state is AssortmentsListEmptyState) {
                                                  return Center(
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
                                                          style: appHeadersTextStyle(
                                                            fontSize: heightRatio(size: 18, context: context),
                                                            color: colorBlack08,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(height: heightRatio(size: 10, context: context)),
                                                        Text(
                                                          "tryagainOrChangeSerchText".tr(),
                                                          textAlign: TextAlign.center,
                                                          style: appLabelTextStyle(
                                                            fontSize: heightRatio(size: 14, context: context),
                                                            color: colorBlack06,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                                if (widget.isSearchPage == false) {
                                                  for (var catalog in catalogsState.catalogsList) {
                                                    if (state.assortmentsList.where((e) => e.catalogUuid == catalog.uuid).isNotEmpty) {
                                                      state.assortmentsList.where((e) => e.catalogUuid == catalog.uuid).first.isShow = true;
                                                    }

                                                    if (state.assortmentsList.where((e) => e.catalogUuid == catalog.uuid).length.isOdd) {
                                                      final index = state.assortmentsList
                                                          .indexOf(state.assortmentsList.where((e) => e.catalogUuid == catalog.uuid).last);
                                                      state.assortmentsList.insert(
                                                        index + 1,
                                                        AssortmentsListModel(isEmpty: true, catalogUuid: catalog.uuid),
                                                      );
                                                    }
                                                  }
                                                }

                                                return SingleChildScrollView(
                                                  controller: scrollController,
                                                  child: Column(
                                                    children: [
                                                      GridView.builder(
                                                        cacheExtent: 50,
                                                        padding: EdgeInsets.only(
                                                          top: heightRatio(size: 16, context: context),
                                                          left: widthRatio(size: 16, context: context),
                                                          right: widthRatio(size: 16, context: context),
                                                        ),
                                                        shrinkWrap: true,
                                                        physics: const BouncingScrollPhysics(),
                                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                          childAspectRatio: widget.isSearchPage || widget.isFinalLevel //высота элемента
                                                              ? 0.64
                                                              : screenWidth <= 385
                                                                  ? screenWidth <= 34
                                                                      ? 0.75 //small phone там широко и расстяния по вертикали увеличены
                                                                      : 0.64 //samsung a54
                                                                  : 0.61,
                                                          crossAxisSpacing: 12, // расстояние по горизонтали между элементами
                                                          crossAxisCount: 2,
                                                        ),
                                                        itemCount: state.assortmentsList.length,
                                                        itemBuilder: (context, index) {
                                                          return CatalogProductWidget(
                                                            isRecomendations: false,
                                                            assortmentsListModel: state.assortmentsList[index],
                                                            index: index,
                                                            isSearchPage: widget.isSearchPage,
                                                            isFinalLevel: widget.isFinalLevel,
                                                            isFromFavCatalogsList: widget.isFromFavCatalogsList,
                                                          );
                                                        },
                                                      ),
                                                      SizedBox(height: heightRatio(size: 15, context: context)),
                                                      if (state is AssortmentsListLoadingState && state.assortmentsList.isNotEmpty)
                                                        Padding(
                                                          padding: EdgeInsets.only(top: heightRatio(size: 20, context: context)),
                                                          child: Center(
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: 3.0,
                                                              valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                                                            ),
                                                          ),
                                                        ),
                                                      SizedBox(height: heightRatio(size: 100, context: context)),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              if (isFirstStart == null || isFirstStart == false)
                BlocBuilder<OrderTypeBloc, OrderTypeState>(
                  builder: (context, state) {
                    if (state is OrderTypeDeliveryState) {
                      return Positioned(bottom: 0, left: 0, right: 0, child: ToFreeDeliveryWidget());
                    } else {
                      return SizedBox();
                    }
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
