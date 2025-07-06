import 'dart:async';

// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/product_in_shop_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class ProductInShopContent extends StatefulWidget {
  @override
  _ProductInShopContentState createState() => _ProductInShopContentState();
}

class _ProductInShopContentState extends State<ProductInShopContent> {
  Completer<YandexMapController> _completer = Completer();

  String quantityUnit = "";
  String selectedAddress = "";
  double selectedStoreproductsQuantity = 0;

  Widget getWidgetForStoreQuantity() {
    return Container(
        // alignment: Alignment.center,
        // height: 53,
        // width: 100,
        padding: EdgeInsets.only(top: heightRatio(size: 3, context: context)),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 50, context: context)), color: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/mapPointIcon.png',
              height: heightRatio(size: 50, context: context),
              width: widthRatio(size: 50, context: context),
            ),
            SizedBox(width: widthRatio(size: 5, context: context)),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${"reminderText".tr()} ${selectedStoreproductsQuantity.toStringAsFixed(0)} ${getAssortmentUnitId(assortmentUnitId: quantityUnit)[1]}.",
                  style: appTextStyle(fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w600),
                ),
                SizedBox(height: heightRatio(size: 3, context: context)),
                Text(
                  "$selectedAddress",
                  style: appTextStyle(fontSize: heightRatio(size: 12, context: context), color: colorBlack04, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(width: widthRatio(size: 15, context: context))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductInShopBloc, ProductInShopState>(
      builder: (context, state) {
        if (state is ProductInShopAsMapState) {
          return Stack(
            alignment: Alignment.center,
            fit: StackFit.passthrough,
            children: [
              Container(
                child: YandexMap(
                    mapObjects: [
                      ...state.storesListModel
                          .map((e) => PlacemarkMapObject(
                              onTap: (mapObject, point) async {
                                YandexMapController mapController = await _completer.future;

                                mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                                  zoom: 10.5,
                                  target: Point(latitude: double.parse(e.addressLatitude), longitude: double.parse(e.addressLongitude)),
                                )));

                                setState(() {
                                  e.isSelected = true;
                                  e.address;
                                  selectedStoreproductsQuantity = e.productsQuantity != null ? double.parse(e.productsQuantity.toString()) : e.productsQuantity;
                                  quantityUnit = state.assortmentUnitId;
                                });
                              },
                              opacity: 0.9,
                              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                                anchor: const Offset(0.5, 0.8),
                                scale: 0.7,
                                image: BitmapDescriptor.fromAssetImage(
                                  "assets/images/mapPointIcon.png",
                                ),
                              )),
                              point: Point(latitude: double.parse(e.addressLatitude ?? "0"), longitude: double.parse(e.addressLongitude ?? "0")),
                              mapId: MapObjectId(e.uuid)))
                          .toList(),
                    ],
                    onMapCreated: (YandexMapController yandexMapController) async {
                      if (!_completer.isCompleted) {
                        selectedAddress = "";

                        _completer.complete(yandexMapController);
                      }
                      if (state.storesListModel.isNotEmpty) {
                        yandexMapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                          target: Point(latitude: double.parse(state.storesListModel.first.addressLatitude ?? "0"), longitude: double.parse(state.storesListModel.first.addressLongitude ?? "0")),
                          zoom: 12,
                        )));
                      }
                      // for (int i = 0; i < state.storesListModel.length; i++) {
                      //   yandexMapController.addPlacemark(Placemark(
                      //       point: Point(
                      //           latitude: double.parse(
                      //               state.storesListModel[i].addressLatitude),
                      //           longitude: double.parse(
                      //               state.storesListModel[i].addressLongitude)),
                      //       onTap: (p) {
                      //         yandexMapController.moveCamera(
                      //             CameraUpdate.newCameraPosition(CameraPosition(
                      //           zoom: 10.5,
                      //           target: Point(
                      //               latitude: double.parse(state
                      //                   .storesListModel[i].addressLatitude),
                      //               longitude: double.parse(state
                      //                   .storesListModel[i].addressLongitude)),
                      //         )));

                      //         // yandexMapController.move(
                      //         //   point: Point(
                      //         //       latitude: double.parse(
                      //         //           state.storesListModel[i].addressLatitude),
                      //         //       longitude: double.parse(
                      //         //           state.storesListModel[i].addressLongitude)),
                      //         //   animation: MapAnimation(duration: 0.5),
                      //         // );
                      //         setState(() {
                      //           state.storesListModel[i].isSelected = true;
                      //           selectedAddress =
                      //               state.storesListModel[i].address;
                      //           selectedStoreproductsQuantity = state
                      //                       .storesListModel[i]
                      //                       .productsQuantity !=
                      //                   null
                      //               ? double.parse(state
                      //                   .storesListModel[i].productsQuantity
                      //                   .toString())
                      //               : state.storesListModel[i].productsQuantity;
                      //           quantityUnit = state.assortmentUnitId;
                      //         });
                      //       },
                      //       iconName: 'assets/images/mapPointIcon.png',
                      //       opacity: 0.9,
                      //       scale: 0.7));
                      // }
                    }),
              ),
              if (selectedAddress.isNotEmpty) getWidgetForStoreQuantity()
            ],
          );
        }

        if (state is ProductInShopAsListState) {
          return Container(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              child: ListView.builder(
                padding: EdgeInsets.only(top: heightRatio(size: 10, context: context)),
                itemCount: state.storesListModel.length,
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                  child: Column(children: [
                    ListTile(
                      title: Text(state.storesListModel[index].address, style: appTextStyle(fontSize: widthRatio(size: 16, context: context))),
                      trailing: Text(state.storesListModel[index].productsQuantity.toString() + " " + getAssortmentUnitId(assortmentUnitId: state.assortmentUnitId)[1], style: appTextStyle(fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(height: heightRatio(size: 10, context: context)),
                    Divider()
                  ]),
                ),
              ),
            ),
          );
        }

        return SizedBox();
      },
    );
  }
}
