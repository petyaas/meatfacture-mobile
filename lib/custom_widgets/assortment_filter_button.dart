import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/bloc_files/assortment_filter_bloc.dart';
import 'package:smart/bloc_files/brands_bloc.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/custom_widgets/assortment_filter_bottom_sheet.dart';
import 'package:smart/custom_widgets/reg_or_login_warning_bottomSheet.dart';

class AssortmentFilterButton extends StatelessWidget {
  final String subcatalogUuid;
  final String catalogUuid;

  const AssortmentFilterButton({this.subcatalogUuid, this.catalogUuid});

  Future<String> loadToken() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    return _shared.getString(SharedKeys.token);
  }

  void loginOrRegWarning(BuildContext context) {
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
          return RegOrLoginWarningBottomSheet();
        }).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    BrandBloc _brandBloc = BlocProvider.of<BrandBloc>(context);
    // // ignore: close_sinks
    // AssortmentFiltersBloc _assortmentFiltersBloc =
    BlocProvider.of<AssortmentFiltersBloc>(context);
    void _openShopsFiltersBottomSheet({BuildContext context, bool isFavorite}) {
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
            return Wrap(
              children: [
                AssortmentFilterBottomSheet(subcatalogUuid: subcatalogUuid, catalogUuid: catalogUuid),
              ],
            );
          }).then((value) {});
    }

    // filter
    return BlocBuilder<AssortmentFiltersBloc, AssortmentFiltersEState>(
      builder: (context, state) {
        return InkWell(
          onTap: () async {
            if ("guest" != await loadToken()) {
              _brandBloc.add(BrandLoadEvent());

              // _assortmentFiltersBloc
              //     .add(AssortmentFiltersLoadEvent(isFavorite: false));
              if (state is AssortmentFiltersActiveState) {
                _openShopsFiltersBottomSheet(context: context, isFavorite: state.isFavorite);
              } else {
                _openShopsFiltersBottomSheet(context: context, isFavorite: false);
              }
            } else {
              loginOrRegWarning(context);
            }
          },
          child: Container(
            width: widthRatio(size: 36, context: context),
            height: heightRatio(size: 36, context: context),
            padding: EdgeInsets.only(
                top: heightRatio(size: 5, context: context), left: widthRatio(size: 10, context: context), right: widthRatio(size: 10, context: context)),
            decoration: BoxDecoration(color: white03, shape: BoxShape.circle),
            child: SvgPicture.asset('assets/images/newFilter.svg',
                color: whiteColor, height: heightRatio(size: 17, context: context), width: widthRatio(size: 17, context: context)),
          ),
        );
      },
    );
  }
}
