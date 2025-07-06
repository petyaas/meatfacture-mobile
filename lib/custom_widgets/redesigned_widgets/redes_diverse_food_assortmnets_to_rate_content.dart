import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:smart/bloc_files/diverse_food_bloc.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_diverse_food_assortment_to_rate_card.dart';
import 'package:smart/custom_widgets/shimmer_loader_for_catalog.dart';
import 'package:smart/models/diverse_food_assortment_list_model.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RedesDiverseFoodAssortmnetsToRateContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DiverseFoodBloc _diverseFoodBloc = BlocProvider.of(context);

    return BlocBuilder<DiverseFoodBloc, DiverseFoodState>(builder: (context, state) {
      if (state is DiverseFoodLoadedState) {
        return DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                  padding: EdgeInsets.all(widthRatio(size: 5, context: context)),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(widthRatio(size: 12, context: context)), color: lightGreyColor),
                  child: TabBar(
                      indicator: BoxDecoration(borderRadius: BorderRadius.circular(widthRatio(size: 8, context: context)), color: whiteColor),
                      labelColor: blackColor,
                      unselectedLabelColor: colorBlack04,
                      labelStyle: appTextStyle(fontSize: heightRatio(size: 13, context: context), fontWeight: FontWeight.w600),
                      unselectedLabelStyle: appTextStyle(fontSize: heightRatio(size: 13, context: context), fontWeight: FontWeight.w600),
                      tabs: [
                        //1
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: widthRatio(size: 8, context: context)),
                          child: Text(
                            "${"leftToRateText".tr()} ${state is DiverseFoodLoadedState ? state.isNotRatedProductsList.meta.total : "0"}",
                          ),
                        ),
                        //2
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: widthRatio(size: 8, context: context)),
                          child: Text(
                            "${"olreadyRateText".tr()} ${state is DiverseFoodLoadedState ? state.isRatedProductsList.meta.total : "0"}",
                          ),
                        )
                      ])),
              Expanded(
                child: TabBarView(
                  children: [
                    AssortmnetnViewWidget(isRated: false),
                    AssortmnetnViewWidget(isRated: true),
                  ],
                ),
              )
            ],
          ),
        );
      }
      if (state is DiverseFoodErrorState) {
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
              Text("errorText".tr(), style: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500)),
              SizedBox(height: heightRatio(size: 10, context: context)),
              InkWell(
                  onTap: () {
                    _diverseFoodBloc.add(DiverseFoodLoadEvent());
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Text("tryAgainText".tr(), style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500)),
                  ))
            ],
          )),
        );
      }
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
        ),
      );
    });
  }
}

class AssortmnetnViewWidget extends StatefulWidget {
  final bool isRated;
  AssortmnetnViewWidget({this.isRated});
  @override
  State<AssortmnetnViewWidget> createState() => _AssortmnetnViewWidgetState();
}

class _AssortmnetnViewWidgetState extends State<AssortmnetnViewWidget> with AutomaticKeepAliveClientMixin {
  int i = 1;
  GlobalKey<PaginationViewState> _assortmnetPaginationViewkey = GlobalKey<PaginationViewState>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PaginationView<DiverseFoodAssortmentListDataModel>(
        initialLoader: ShimmerLoaderForCatalog(),
        padding: EdgeInsets.only(left: widthRatio(size: 12, context: context), right: widthRatio(size: 12, context: context), top: widthRatio(size: 15, context: context)),
        paginationViewType: PaginationViewType.listView,
        // preloadedItems: state.catalogsModel.data,
        itemBuilder: (BuildContext context, DiverseFoodAssortmentListDataModel listDataModel, int index) => RedesDiverseFoodAssortmentToRateCard(productModel: listDataModel),
        pageFetch: (currentListSize) async {
          DiverseFoodAssortmentListModel fechedPage = await DiverseFoodProvider().diverseFoodAssortmentListResponse(
            isRated: widget.isRated,
            page: i,
          );
          i++;
          return fechedPage.data;
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
          ],
        )),
        bottomLoader: Center(
          child: Center(
              child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
          )),
        ),
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
                        i = 1;
                      });
                      if (_assortmnetPaginationViewkey.currentState != null) {
                        _assortmnetPaginationViewkey.currentState.refresh();
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Text("tryAgainText".tr(), style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500)),
                    ))
              ],
            ))));
  }

  @override
  bool get wantKeepAlive => true;
}
