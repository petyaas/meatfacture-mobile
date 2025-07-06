import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/shops_list_filters_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_event.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_state.dart';

// ignore: must_be_immutable
class HomeChooseStoreFilter extends StatefulWidget {
  bool hasParking;
  bool hasReadyMeals;
  bool hasAtms;
  bool isfavorite;
  bool isOpenNow;

  HomeChooseStoreFilter({@required this.hasParking, @required this.hasAtms, @required this.hasReadyMeals, @required this.isOpenNow, @required this.isfavorite});

  @override
  _HomeChooseStoreFilterState createState() => _HomeChooseStoreFilterState();
}

class _HomeChooseStoreFilterState extends State<HomeChooseStoreFilter> {
  @override
  Widget build(BuildContext context) {
    @override
    ShopsListFiltersBloc _shopsListFiltersBloc = BlocProvider.of<ShopsListFiltersBloc>(context);
    AddressesShopBloc _shopsBloc = BlocProvider.of<AddressesShopBloc>(context);

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
              style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context)),
            ),
            SizedBox(height: heightRatio(size: 25, context: context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("openNowText".tr(), style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack)),
                CupertinoSwitch(
                  value: widget.isOpenNow,
                  onChanged: (val) {
                    setState(() => widget.isOpenNow = val);
                  },
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("atmText".tr(), style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack)),
                CupertinoSwitch(
                  value: widget.hasAtms,
                  onChanged: (val) {
                    setState(() => widget.hasAtms = val);
                  },
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("readyMealText".tr(), style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack)),
                CupertinoSwitch(
                  value: widget.hasReadyMeals,
                  onChanged: (val) {
                    setState(() => widget.hasReadyMeals = val);
                  },
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("parkingText".tr(), style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack)),
                CupertinoSwitch(
                  value: widget.hasParking,
                  onChanged: (val) {
                    setState(() => widget.hasParking = val);
                  },
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("nlySelectText".tr(), style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack)),
                CupertinoSwitch(
                    value: widget.isfavorite,
                    onChanged: (val) {
                      setState(() {
                        widget.isfavorite = val;
                      });
                    })
              ],
            ),
            SizedBox(height: heightRatio(size: 30, context: context)),
            InkWell(
              onTap: () {
                if (_shopsBloc.state is LoadedAddressesShopState || _shopsBloc.state is LoadingAddressesShopState) {
                  _shopsBloc.add(ListAddressesShopEvent(
                    hasAtms: widget.hasAtms,
                    hasParking: widget.hasParking,
                    hasReadyMeals: widget.hasReadyMeals,
                    isOpenNow: widget.isOpenNow,
                    isFavorite: widget.isfavorite,
                  ));
                } else {
                  _shopsBloc.add(MapAddressesShopEvent(
                    hasAtms: widget.hasAtms,
                    hasParking: widget.hasParking,
                    hasReadyMeals: widget.hasReadyMeals,
                    isOpenNow: widget.isOpenNow,
                    isFavorite: widget.isfavorite,
                  ));
                }
                _shopsListFiltersBloc.add(ShopsListFiltersLoadEvent(hasAtms: widget.hasAtms, hasParking: widget.hasParking, hasReadyMeals: widget.hasReadyMeals, isOpenNow: widget.isOpenNow, isfavorite: widget.isfavorite));
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                child: Text(
                  "applyText".tr(),
                  style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                ),
              ),
            ),
            SizedBox(height: heightRatio(size: 25, context: context)),
          ],
        ),
      ),
    );
  }
}
