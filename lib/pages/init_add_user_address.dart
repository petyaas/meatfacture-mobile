import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:smart/features/addresses/addresses_delivery/bloc/addresses_client_bloc.dart';
import 'package:smart/bloc_files/geocoding_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_event.dart';
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_model.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/custom_widgets/too_far_address_bottom_sheet.dart';
import 'package:smart/main.dart';
import 'package:smart/features/addresses/addresses_delivery/models/address_client_model.dart';
import 'package:smart/models/geocoding_model.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class InitAddUserAddress extends StatefulWidget {
  final bool isNewAddress;
  final double heightOfBottomNavBar;
  final AddressClientModel clientAddressDataModel;

  const InitAddUserAddress({@required this.heightOfBottomNavBar, this.clientAddressDataModel, this.isNewAddress = true});

  @override
  _InitAddUserAddressState createState() => _InitAddUserAddressState();
}

class _InitAddUserAddressState extends State<InitAddUserAddress> {
  Completer<YandexMapController> _completer = Completer();
  final double bottomAreaHeight = 180;
  final TextEditingController _addAddressTextController = TextEditingController();
  Point myPosition;
  GeocodingDataModel finalPositionToGo;
  bool addressListVisible = false;
  Timer _timer;
  bool isInit = true;
  List<MapObject> myPositionPoint = [];

  @override
  void initState() {
    if (!widget.isNewAddress && widget.clientAddressDataModel != null) {
      _addAddressTextController.text = "${widget.clientAddressDataModel.city}, ${widget.clientAddressDataModel.street} ${widget.clientAddressDataModel.house}";
    } else {
      _addAddressTextController.clear();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AddressesClientBloc _clientAddressBloc = BlocProvider.of<AddressesClientBloc>(context);
    SecondaryPageBloc _secondaryPageBloc = BlocProvider.of(context);
    ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
    Geocodingbloc _geocodingbloc = BlocProvider.of(context);

    void getmyPosition() async {
      var location = new Location();
      var mylocation = await location.getLocation();
      setState(() {
        addressListVisible = true;
        myPosition = Point(latitude: mylocation.latitude, longitude: mylocation.longitude);
        _geocodingbloc.add(GeocodingLoadEvent(latLngOfAddress: Point(latitude: mylocation.latitude, longitude: mylocation.longitude)));
      });

      YandexMapController controller = await _completer.future;
      controller.moveCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
            zoom: 17,
            target: Point(latitude: myPosition.latitude, longitude: myPosition.longitude),
          )),
          animation: const MapAnimation(duration: 1));

      setState(() {
        myPositionPoint = [
          PlacemarkMapObject(
            opacity: 1,
            icon: PlacemarkIcon.single(PlacemarkIconStyle(
              scale: 0.5,
              image: BitmapDescriptor.fromAssetImage("assets/images/mapPointImage.png"),
            )),
            point: Point(latitude: myPosition.latitude, longitude: myPosition.longitude),
            mapId: MapObjectId("myPoint"),
          )
        ];
      });
    }

    return BlocBuilder<Geocodingbloc, GeocodingState>(builder: (context, state) {
      if (state is GeocodingLoadedState && state.isReverse && state.geocodingModel.data.isNotEmpty) {
        finalPositionToGo = state.geocodingModel.data.first;
        _addAddressTextController.text =
            "${state.geocodingModel.data.first.country} ${state.geocodingModel.data.first.locality ?? ""}  ${state.geocodingModel.data.first.streetName ?? state.geocodingModel.data.first.subLocality ?? ""} ${state.geocodingModel.data.first.streetNumber ?? ""}";
        myAddress =
            "${state.geocodingModel.data.first.locality ?? ""}, ${state.geocodingModel.data.first.streetName ?? state.geocodingModel.data.first.subLocality ?? ""} ${state.geocodingModel.data.first.streetNumber ?? ""}";
      }
      if (widget.clientAddressDataModel != null && isInit && state is GeocodingLoadedState) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          getAddressFromText(geocodingbloc: _geocodingbloc, milliseconds: 10);
          isInit = false;
          addressListVisible = true;
          setState(() {
            myPosition = Point(latitude: state.geocodingModel.data.first.latitude, longitude: state.geocodingModel.data.first.longitude);
          });
          finalPositionToGo = state.geocodingModel.data.first;
        });
      }
      return WillPopScope(
        onWillPop: () async {
          if (prefs.getString(SharedKeys.myAddress) != null &&
              prefs.getString(SharedKeys.myAddress).isNotEmpty &&
              prefs.getString(SharedKeys.myAddress) != '') {
            return true;
          } else {
            return false;
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: YandexMap(
                    mapObjects: myPositionPoint,
                    onMapTap: (argument) async {
                      YandexMapController _controller = await _completer.future;
                      _controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(zoom: 17, target: argument)),
                          animation: const MapAnimation(duration: 1));
                      setState(
                        () {
                          _addAddressTextController.clear();
                          addressListVisible = true;

                          myPositionPoint = [
                            PlacemarkMapObject(
                              opacity: 1,
                              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                                scale: 0.5,
                                image: BitmapDescriptor.fromAssetImage("assets/images/mapPointImage.png"),
                              )),
                              point: Point(latitude: argument.latitude, longitude: argument.longitude),
                              mapId: MapObjectId("myPoint"),
                            )
                          ];
                        },
                      );
                      _geocodingbloc.add(GeocodingLoadEvent(latLngOfAddress: Point(latitude: argument.latitude, longitude: argument.longitude)));
                    },
                    onMapCreated: (YandexMapController yandexMapController) async {
                      if (!_completer.isCompleted) {
                        _completer.complete(yandexMapController);
                      }

                      yandexMapController.moveCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(zoom: 12, target: Point(latitude: 45.03100863206145, longitude: 41.94367899999998)),
                      ));
                    },
                  ),
                ),
                Positioned(
                    bottom: MediaQuery.of(context).viewInsets.bottom == 0
                        ? 0
                        : widget.heightOfBottomNavBar == null
                            ? MediaQuery.of(context).viewInsets.bottom
                            : Platform.isIOS
                                ? MediaQuery.of(context).viewInsets.bottom - widget.heightOfBottomNavBar - 30
                                : MediaQuery.of(context).viewInsets.bottom - widget.heightOfBottomNavBar,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        state is GeocodingLoadedState && addressListVisible
                            ? ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: screenWidth(context) / 2,
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(top: heightRatio(size: 8, context: context)),
                                  clipBehavior: Clip.hardEdge,
                                  height: state is GeocodingLoadedState
                                      ? (state.geocodingModel.data.length * heightRatio(size: 40, context: context)).toDouble()
                                      : 0, ////////////////////////+
                                  // height: state is GeocodingLoadedState ? (state.geocodingModel.data.length * heightRatio(size: 65, context: context)).toDouble() : 0,
                                  width: screenWidth(context),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                                      topRight: Radius.circular(heightRatio(size: 15, context: context)),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: ListView.builder(
                                    itemCount: state.geocodingModel.data.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () async {
                                          setState(() {
                                            finalPositionToGo = state.geocodingModel.data[index];
                                            addressListVisible = false;
                                            FocusScopeNode currentFocus = FocusScope.of(context);
                                            currentFocus.unfocus();

                                            _addAddressTextController.text =
                                                "${state.geocodingModel.data[index].country} ${state.geocodingModel.data[index].locality ?? ""}  ${state.geocodingModel.data[index].streetName ?? state.geocodingModel.data[index].subLocality ?? ""} ${state.geocodingModel.data[index].streetNumber ?? ""}";
                                          });

                                          YandexMapController controller = await _completer.future;
                                          controller.moveCamera(
                                            CameraUpdate.newCameraPosition(CameraPosition(
                                              zoom: 12,
                                              target: Point(
                                                  latitude: state.geocodingModel.data[index].latitude, longitude: state.geocodingModel.data[index].longitude),
                                            )),
                                            animation: MapAnimation(duration: 1),
                                          );

                                          setState(() {
                                            myPositionPoint = [
                                              PlacemarkMapObject(
                                                opacity: 1,
                                                icon: PlacemarkIcon.single(PlacemarkIconStyle(
                                                  scale: 0.5,
                                                  image: BitmapDescriptor.fromAssetImage("assets/images/mapPointImage.png"),
                                                )),
                                                point: Point(
                                                    latitude: state.geocodingModel.data[index].latitude, longitude: state.geocodingModel.data[index].longitude),
                                                mapId: MapObjectId("myPoint"),
                                              )
                                            ];
                                          });
                                        },
                                        child: Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: heightRatio(size: 12, context: context)),
                                                    Text(
                                                        "${state.geocodingModel.data[index].country} ${state.geocodingModel.data[index].locality ?? ""}  ${state.geocodingModel.data[index].streetName ?? state.geocodingModel.data[index].subLocality ?? ""} ${state.geocodingModel.data[index].streetNumber ?? ""}"),
                                                    SizedBox(height: heightRatio(size: 12, context: context)),
                                                    index != state.geocodingModel.data.length - 1 ? Divider(height: 0) : const SizedBox(width: double.infinity),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : state is GeocodingLoadingState
                                ? Container(
                                    height: heightRatio(size: 53, context: context),
                                    width: widthRatio(size: 53, context: context),
                                    margin: EdgeInsets.only(bottom: heightRatio(size: 17, context: context)),
                                    color: Colors.transparent,
                                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(mainColor)),
                                  )
                                : SizedBox(),
                        Container(
                            padding: EdgeInsets.only(
                                left: widthRatio(size: 16, context: context),
                                right: widthRatio(size: 16, context: context),
                                top: heightRatio(size: 24, context: context)),
                            child: Column(
                              children: [
                                Container(
                                  child: TextField(
                                    onChanged: (value) async {
                                      setState(() {
                                        finalPositionToGo = null;
                                        addressListVisible = true;
                                      });
                                      getAddressFromText(geocodingbloc: _geocodingbloc, milliseconds: 1500);
                                    },
                                    controller: _addAddressTextController,
                                    cursorColor: mainColor,
                                    style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                                    decoration: InputDecoration(
                                      suffixIcon: _addAddressTextController.text.isNotEmpty
                                          ? InkWell(
                                              onTap: () async {
                                                setState(
                                                  () {
                                                    addressListVisible = false;
                                                    _addAddressTextController.text = '';
                                                    finalPositionToGo = null;
                                                    if (state is GeocodingLoadedState) {
                                                      state.geocodingModel.data.clear();
                                                    }
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 6),
                                                child: SvgPicture.asset(
                                                  'assets/images/closeCircleIcon.svg',
                                                  width: widthRatio(size: 16, context: context),
                                                  height: heightRatio(size: 16, context: context),
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerRight,
                                                ),
                                              ),
                                            )
                                          : null,
                                      suffixIconConstraints: BoxConstraints.loose(Size(24, 24)),
                                      contentPadding: EdgeInsets.only(left: widthRatio(size: 10, context: context)),
                                      hintText: 'Выберите адрес на карте или введите его',
                                      hintStyle: appLabelTextStyle(),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(heightRatio(size: 2, context: context)),
                                        borderSide: BorderSide(color: newRedDark, width: widthRatio(size: 1, context: context)),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(heightRatio(size: 2, context: context)),
                                        borderSide: BorderSide(color: newRedDark, width: widthRatio(size: 1, context: context)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: heightRatio(size: 20, context: context)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (prefs.getString(SharedKeys.myAddress) != null &&
                                        prefs.getString(SharedKeys.myAddress).isNotEmpty &&
                                        prefs.getString(SharedKeys.myAddress) != '')
                                      Expanded(
                                        child: InkWell(
                                          onTap: () => Navigator.pop(context),
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding:
                                                EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
                                            margin: EdgeInsets.only(right: widthRatio(size: 12, context: context)),
                                            child: Text(
                                              'Назад',
                                              style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          setClientAddress(
                                              clientAddressBloc: _clientAddressBloc, profileBloc: _profileBloc, secondaryPageBloc: _secondaryPageBloc);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding:
                                              EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                                          child: Text(
                                            'Подтвердить',
                                            style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: heightRatio(size: 20, context: context)),
                              ],
                            ),
                            width: screenWidth(context),
                            alignment: Alignment.center,
                            color: Colors.white),
                      ],
                    )),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: widthRatio(size: 20, context: context),
                        bottom: heightRatio(size: 10, context: context),
                        top: heightRatio(size: 15, context: context)),
                    alignment: Alignment.centerLeft,
                    color: Colors.white,
                    // Укажите адрес доставки
                    child: Text(
                      widget.clientAddressDataModel == null ? "Укажите адрес доставки" : "changeDeliveryAddress".tr(),
                      style: appLabelTextStyle(color: newBlack, fontSize: heightRatio(size: 18, context: context)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Container(
            margin: EdgeInsets.only(
                bottom: heightRatio(
                    size: MediaQuery.of(context).viewInsets.bottom == 0
                        ? bottomAreaHeight - 10
                        : widget.heightOfBottomNavBar == null
                            ? MediaQuery.of(context).viewInsets.bottom + bottomAreaHeight - 10
                            : Platform.isIOS
                                ? MediaQuery.of(context).viewInsets.bottom - widget.heightOfBottomNavBar - 50 + bottomAreaHeight - 10
                                : MediaQuery.of(context).viewInsets.bottom - widget.heightOfBottomNavBar + bottomAreaHeight - 10,
                    context: context)),
            child: FloatingActionButton(
              backgroundColor: mainColor,
              child: Container(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  "assets/images/myLocationIcon.svg",
                  color: whiteColor,
                ),
                decoration: BoxDecoration(shape: BoxShape.circle, color: mainColor),
              ),
              onPressed: () async {
                getmyPosition();
              },
            ),
          ),
        ),
      );
    });
  }

  void getAddressFromText({@required Geocodingbloc geocodingbloc, @required int milliseconds}) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), () {
      geocodingbloc.add(GeocodingLoadEvent(address: _addAddressTextController.text));
    });
  }

  String myAddress = "";

  setClientAddress({
    @required SecondaryPageBloc secondaryPageBloc,
    @required ProfileBloc profileBloc,
    @required AddressesClientBloc clientAddressBloc,
  }) async {
    final AddressesShopBloc addressesShopBloc = BlocProvider.of<AddressesShopBloc>(context);
    AddressesShopModel nearestStore = null;

    if (finalPositionToGo != null) {
      log('finalPositionToGo:::::::::::: 📍latitude: ${finalPositionToGo.latitude}, 📍longitude: ${finalPositionToGo.longitude}');
      Fluttertoast.showToast(msg: "Подождите...");
      nearestStore = await ShopsListProvider().getNearbyStoreModel(
        position: Point(latitude: finalPositionToGo.latitude, longitude: finalPositionToGo.longitude),
      );
      print('📍 nearestStore======= ' + nearestStore.uuid);
    } else {
      Fluttertoast.showToast(msg: "Выберите адрес из списка");
    }

    if (nearestStore.uuid == null) {
      showModalBottomSheet<dynamic>(
        context: context,
        useSafeArea: true,
        builder: (context) => TooFarAddressBottomSheet(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(heightRatio(size: 25, context: context)),
            topRight: Radius.circular(heightRatio(size: 25, context: context)),
          ),
        ),
      );
    } else {
      // Обновляем адрес клиента
      if (widget.clientAddressDataModel != null) {
        log('Обновляем адрес клиента::::::::::: changeClientAddressResponse');
        await AddressesClientProvider().changeClientAddressResponse(
          addressUuid: widget.clientAddressDataModel.uuid,
          city: finalPositionToGo.locality,
          house: finalPositionToGo.streetNumber ?? "",
          title: "${finalPositionToGo.locality}, ${finalPositionToGo.streetName ?? finalPositionToGo.subLocality} ${finalPositionToGo.streetNumber ?? ""}",
          street: finalPositionToGo.streetName ?? finalPositionToGo.subLocality,
        );
      } else {
        log('Сохраняем адрес клиента::::::::::: addClientAddressResponse');
        await AddressesClientProvider().addClientAddressResponse(
          house: finalPositionToGo.streetNumber,
          city: finalPositionToGo.locality,
          title: "${finalPositionToGo.locality}, ${finalPositionToGo.streetName ?? finalPositionToGo.subLocality} ${finalPositionToGo.streetNumber ?? ""}",
          street: finalPositionToGo.streetName ?? finalPositionToGo.subLocality ?? '',
        );
      }

      // Сохраняем выбранным ближайший магазин
      addressesShopBloc.add(SelectAddressShopEvent(shopUuid: nearestStore.uuid));
      log('Сохраняем выбранным ближайший магазин: 📍 ${nearestStore.uuid}');
      profileBloc.add(ProfileUpdateDataEvent(selectedStoreUserUuid: nearestStore.uuid));
      // }
      profileBloc.add(ProfileLoadEvent());
      clientAddressBloc.add(LoadedAddressesClientEvent());
      Navigator.pop(context);
    }
  }
}
