import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/bloc_files/assortment_recommendations_bloc.dart';
import 'package:smart/features/catalog/bloc/catalogs_bloc.dart';
import 'package:smart/bloc_files/tags_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/catalog/widgets/catalog_levels_widget.dart';
import 'package:smart/features/fav_product/widgets/fav_catalog_list_shimmer.dart';

class FavCatalogsList extends StatefulWidget {
  @override
  State<FavCatalogsList> createState() => _FavCatalogsListState();
}

class _FavCatalogsListState extends State<FavCatalogsList> {
  final ScrollController scrollController = ScrollController();

  CatalogsBloc catalogsBloc;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        catalogsBloc.add(CatalogstNextPageEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    catalogsBloc = BlocProvider.of(context);
    TagsBloc _tagsBloc = BlocProvider.of(context);
    AssortmentRecommendationBloc _assortmentRecommendationBloc = BlocProvider.of<AssortmentRecommendationBloc>(context);

    return RefreshIndicator(
      color: newRedDark,
      onRefresh: () async {
        catalogsBloc.add(CatalogsLoadEvent());
      },
      child: BlocBuilder<CatalogsBloc, CatalogsState>(
        builder: (context, state) {
          if (state is CatalogsInitState) {
            catalogsBloc.add(CatalogsLoadEvent());
          }
          if (state is CatalogsLoadingState) {
            return FavCatalogsListShimmer();
          }
          if (state is CatalogsErrorState) {
            return Center(
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
                      _assortmentRecommendationBloc.add(AssortmentRecommendationsLoadEvent());
                      _tagsBloc.add(TagsloadEvent());
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Text("tryAgainText".tr(), style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            );
          }
          state.catalogsList.removeWhere((element) => element.name == "Упаковка");
          return ListView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            children: state.catalogsList.map<Widget>((catalog) {
              return CatalogLevelsWidget(
                isFromFavCatalogsList: true,
                catalogListModel: catalog,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
