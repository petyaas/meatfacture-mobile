import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/bloc_files/shop_details_bloc.dart';
import 'package:smart/custom_widgets/assortment_filter_button.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_event.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_state.dart';
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_model.dart';
import 'package:smart/features/home/widgets/home_choose_store_map_details.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class HomeChooseStoreList extends StatefulWidget {
  final List<AddressesShopModel> shopsList;

  const HomeChooseStoreList({@required this.shopsList});

  @override
  _HomeChooseStoreListState createState() => _HomeChooseStoreListState();
}

class _HomeChooseStoreListState extends State<HomeChooseStoreList> {
  @override
  Widget build(BuildContext context) {
    ShopDetailsBloc _shopDetailsBloc = BlocProvider.of<ShopDetailsBloc>(context);

    return BlocBuilder<AddressesShopBloc, AddressesShopState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(height: heightRatio(size: 25, context: context)),
            Container(
              margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
              decoration: BoxDecoration(color: grey04, borderRadius: BorderRadius.circular(12)),
              height: heightRatio(size: 40, context: context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context)),
                        color: newRedDark,
                      ),
                      child: Text(
                        'Списком',
                        style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: whiteColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (state is LoadedAddressesShopState) {
                          BlocProvider.of<AddressesShopBloc>(context).add(MapAddressesShopEvent(
                            loadedModel: state.loadedShopsList,
                            searchText: state.searchText,
                            nearestStore: state.nearestStore,
                            hasAtms: state.hasAtms,
                            hasParking: state.hasParking,
                            hasReadyMeals: state.hasReadyMeals,
                            isOpenNow: state.isOpenNow,
                            isFavorite: state.isFavorite,
                          ));
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context))),
                        child: Text(
                          'На карте',
                          style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: heightRatio(size: 25, context: context)),
                itemCount: widget.shopsList.length,
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: GestureDetector(
                    onTap: () async {
                      if (widget.shopsList[index].isFavorite == true) {
                      } else {}
                      _shopDetailsBloc.add(ShopDetailsEnableEvent(
                          lat: widget.shopsList[index].addressLatitude,
                          lon: widget.shopsList[index].addressLongitude,
                          storeUuid: widget.shopsList[index].uuid));
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
                        builder: (BuildContext bc) => Wrap(children: [HomeChooseStoreMapDetails()]),
                      ).then((value) => _shopDetailsBloc.add(ShopDetailsDisableEvent()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [BoxShadow(color: newShadow, offset: Offset(2, 2), blurRadius: 6, spreadRadius: 0)],
                      ),
                      margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context), vertical: heightRatio(size: 6, context: context)),
                      padding: EdgeInsets.only(
                        left: widthRatio(size: 12, context: context),
                        top: heightRatio(size: 3, context: context),
                        bottom: heightRatio(size: 3, context: context),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        trailing: IconButton(
                          icon: widget.shopsList[index].isFavorite
                              ? SvgPicture.asset('assets/images/active_tape_icon.svg', height: heightRatio(size: 20, context: context))
                              : SvgPicture.asset('assets/images/not_active_tape_icon.svg', height: heightRatio(size: 20, context: context), color: newRedDark),
                          onPressed: () async {
                            if (await loadToken() != "guest") {
                              if (widget.shopsList[index].isFavorite) {
                                setState(() {
                                  widget.shopsList[index].isFavorite = false;
                                });
                                if (!await DeleteShopToFavoriteProvider(storeUuid: widget.shopsList[index].uuid).getisDeleteShopTofavoriteresponse()) {
                                  Fluttertoast.showToast(msg: "errorText".tr());
                                }
                              } else {
                                setState(() {
                                  widget.shopsList[index].isFavorite = true;
                                });
                                if (!await AddShopToFavoriteProvider(storeUuid: widget.shopsList[index].uuid).getisAddShopTofavoriteresponse()) {
                                  Fluttertoast.showToast(msg: "errorText".tr());
                                }
                              }
                            } else {
                              AssortmentFilterButton().loginOrRegWarning(context);
                            }
                          },
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            widget.shopsList[index].image != null
                                ? SizedBox(
                                    height: heightRatio(size: 40, context: context),
                                    width: widthRatio(size: 50, context: context),
                                    child: Image.network(widget.shopsList[index].image.path, fit: BoxFit.cover),
                                  )
                                : SizedBox.shrink(),
                            SizedBox(width: widthRatio(size: 7, context: context)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.shopsList[index].address ?? "",
                                  style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newBlack),
                                ),
                                SizedBox(height: heightRatio(size: 4, context: context)),
                                Text(
                                  widget.shopsList[index].workHoursFrom == null || widget.shopsList[index].workHoursTill == null
                                      ? ""
                                      : widget.shopsList[index].workHoursFrom + " - " + widget.shopsList[index].workHoursTill,
                                  style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newRedDark),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
