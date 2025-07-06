import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:smart/bloc_files/shop_details_bloc.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/custom_widgets/shimmer_loader_for_map.dart';
import 'package:smart/custom_widgets/shimmer_loader_for_shop_list.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_event.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_state.dart';
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_model.dart';
import 'package:smart/features/home/widgets/home_choose_store_map_details.dart';
import 'package:smart/features/home/widgets/home_choose_store_list.dart';
import 'package:smart/core/constants/source.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class HomeChooseStoreMap extends StatefulWidget {
  @override
  State<HomeChooseStoreMap> createState() => _HomeChooseStoreMapState();
}

class _HomeChooseStoreMapState extends State<HomeChooseStoreMap> {
  YandexMapController yandexMapController2;

  @override
  Widget build(BuildContext context) {
    ShopDetailsBloc _shopDetailsBloc = BlocProvider.of<ShopDetailsBloc>(context);

    void openShopDetailsBottomSheet({BuildContext context, String uuid, String lat, String lon}) {
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
              children: [HomeChooseStoreMapDetails()],
            );
          }).then(
        (value) {
          _shopDetailsBloc.add(ShopDetailsDisableEvent());
        },
      );
    }

    return BlocBuilder<AddressesShopBloc, AddressesShopState>(
      builder: (context, state) {
        if (state is OnMapEmptyAddressesShopState) {
          return Container(alignment: Alignment.center, color: Colors.white);
        }

        if (state is LoadedMapAddressesShopState) {
          return Stack(
            children: [
              YandexMap(
                mapObjects: [
                  ...state.loadedShopsList.data.map((e) => PlacemarkMapObject(
                      onTap: (mapObject, point) async {
                        if (_shopDetailsBloc.state is ShopDetailsDisableState) {
                          _shopDetailsBloc.add(ShopDetailsEnableEvent(lat: e.addressLatitude ?? "0", lon: e.addressLongitude ?? "0", storeUuid: e.uuid));
                          openShopDetailsBottomSheet(lat: e.addressLatitude ?? "0", lon: e.addressLongitude ?? "0", context: context, uuid: e.uuid);
                        }
                      },
                      opacity: 1,
                      icon: PlacemarkIcon.single(
                        PlacemarkIconStyle(
                          anchor: const Offset(0.5, 0.8),
                          scale: 0.25,
                          // image: BitmapDescriptor.fromAssetImage("assets/images/mapPointIcon.png"),
                          image: BitmapDescriptor.fromAssetImage("assets/images/newShopPoint.png"),
                        ),
                      ),
                      point: Point(latitude: double.parse(e.addressLatitude ?? "0"), longitude: double.parse(e.addressLongitude ?? "0")),
                      mapId: MapObjectId(e.uuid))),
                  if (state.myLocation != null)
                    PlacemarkMapObject(
                      opacity: 1,
                      icon: PlacemarkIcon.single(
                        PlacemarkIconStyle(
                          scale: 1.5,
                          image: BitmapDescriptor.fromAssetImage("assets/images/mapPointImage.png"),
                        ),
                      ),
                      mapId: MapObjectId("myPoint"),
                      point: Point(latitude: state.myLocation.latitude, longitude: state.myLocation.longitude),
                    ),
                ],
                onMapCreated: (YandexMapController yandexMapController) async {
                  setState(() => yandexMapController2 = yandexMapController);

                  // if (state.nearestStore != null && state.myLocation != null) {
                  // yandexMapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition())
                  // } else
                  if (state.loadedShopsList.data.isNotEmpty) {
                    yandexMapController.moveCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          zoom: 10.5,
                          target: Point(
                            latitude: double.parse(state.loadedShopsList.data.first.addressLatitude ?? "0"),
                            longitude: double.parse(state.loadedShopsList.data.first.addressLongitude ?? "0"),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              Positioned(
                right: widthRatio(size: 16, context: context),
                bottom: heightRatio(size: 20, context: context),
                child: InkWell(
                  onTap: () async {
                    await moveToMyPosition(state);
                  },
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, color: newRedDark),
                    padding: EdgeInsets.all(heightRatio(size: 16, context: context)),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      "assets/images/myLocationIcon.svg",
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: widthRatio(size: 16, context: context),
                right: widthRatio(size: 16, context: context),
                top: heightRatio(size: 25, context: context),
                child: Container(
                  decoration: BoxDecoration(color: grey04, borderRadius: BorderRadius.circular(12)),
                  height: heightRatio(size: 40, context: context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (state is LoadedMapAddressesShopState) {
                              BlocProvider.of<AddressesShopBloc>(context).add(
                                ListAddressesShopEvent(
                                  nearestStore: state.nearestStore,
                                  loadedModel: state.loadedShopsList,
                                  searchText: state.searchText,
                                  hasAtms: state.hasAtms,
                                  hasParking: state.hasParking,
                                  hasReadyMeals: state.hasReadyMeals,
                                  isOpenNow: state.isOpenNow,
                                  isFavorite: state.isFavorite,
                                ),
                              );
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context))),
                            child: Text(
                              'Списком',
                              style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context)),
                            color: newRedDark,
                          ),
                          child: Text(
                            'На карте',
                            style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: whiteColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        if (state is LoadingMapAddressesShopState) {
          return ShimmerLoaderForMap();
        }
        if (state is LoadingAddressesShopState) {
          return ShimmerLoaderForShopList();
        }
        if (state is ErrorAddressesShopState) {
          return Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Center(child: Text("errorText".tr())),
          );
        }
        if (state is LoadedAddressesShopState) {
          List<AddressesShopModel> _shopsList = state.loadedShopsList.data;
          return HomeChooseStoreList(shopsList: _shopsList);
        }
        return SizedBox();
      },
    );
  }

  moveToMyPosition(LoadedMapAddressesShopState state) async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    LocationData myLocation = state.myLocation;
    if (state.myLocation == null) {
      myLocation = await location.getLocation();
    }
    yandexMapController2.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 17,
          target: Point(
            latitude: state.myLocation != null ? state.myLocation.latitude : myLocation.latitude,
            longitude: state.myLocation != null ? state.myLocation.longitude : myLocation.longitude,
          ),
        ),
      ),
      animation: const MapAnimation(duration: 1),
    );
  }
}
