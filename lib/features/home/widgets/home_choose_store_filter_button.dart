import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/bloc_files/shops_list_filters_bloc.dart';
import 'package:smart/features/home/widgets/home_choose_store_filter.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';

import '../../../custom_widgets/assortment_filter_button.dart';

class HomeChooseStoreFilterButton extends StatefulWidget {
  @override
  _HomeChooseStoreFilterButtonState createState() => _HomeChooseStoreFilterButtonState();
}

class _HomeChooseStoreFilterButtonState extends State<HomeChooseStoreFilterButton> {
  void _openShopsFiltersBottomSheet({BuildContext context, bool hasParking, bool hasAtms, bool hasReadyMeals, bool isOpenNow, bool isfavorite}) {
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
              HomeChooseStoreFilter(
                hasAtms: hasAtms,
                hasParking: hasParking,
                hasReadyMeals: hasReadyMeals,
                isOpenNow: isOpenNow,
                isfavorite: isfavorite,
              ),
            ],
          );
        }).then(
      (value) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopsListFiltersBloc, ShopsListFiltersEState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            if (await loadToken() != "guest") {
              if (state is ShopsListFiltersActiveState) {
                _openShopsFiltersBottomSheet(
                  context: context,
                  hasAtms: state.hasAtms,
                  hasParking: state.hasParking,
                  hasReadyMeals: state.hasReadyMeals,
                  isOpenNow: state.isOpenNow,
                  isfavorite: state.isfavorite,
                );
              } else {
                _openShopsFiltersBottomSheet(
                  context: context,
                  hasAtms: false,
                  hasParking: false,
                  hasReadyMeals: false,
                  isOpenNow: false,
                  isfavorite: false,
                );
              }
            } else {
              AssortmentFilterButton().loginOrRegWarning(context);
            }
          },
          child: Container(
            width: widthRatio(size: 36, context: context),
            height: heightRatio(size: 36, context: context),
            padding: EdgeInsets.only(
                top: heightRatio(size: 5, context: context), left: widthRatio(size: 10, context: context), right: widthRatio(size: 10, context: context)),
            decoration: BoxDecoration(color: white03, shape: BoxShape.circle),
            child: SvgPicture.asset(
              'assets/images/newFilter.svg',
              color: whiteColor,
              height: heightRatio(size: 17, context: context),
              width: widthRatio(size: 17, context: context),
            ),
          ),
        );
      },
    );
  }
}
