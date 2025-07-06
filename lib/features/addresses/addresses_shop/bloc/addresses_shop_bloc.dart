import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_list_model.dart';
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_model.dart';
import 'package:smart/features/addresses/addresses_shop/repositories/addresses_shop_repo.dart';

import 'addresses_shop_event.dart';
import 'addresses_shop_state.dart';

// ShopsBloc
class AddressesShopBloc extends Bloc<AddressesShopEvent, AddressesShopState> {
  final SharedPreferences prefs;

  AddressesShopBloc({@required this.prefs}) : super(OnMapEmptyAddressesShopState());

  @override
  Stream<AddressesShopState> mapEventToState(AddressesShopEvent event) async* {
    if (event is ListAddressesShopEvent) {
      yield* _mapLoadShopsToState(event);
    } else if (event is MapAddressesShopEvent) {
      yield* _mapLoadShopsForMapToState(event);
    } else if (event is SelectAddressShopEvent) {
      yield* _mapSelectShopToState(event);
    } else if (event is EmptyAddressesShopEvent) {
      yield OnMapEmptyAddressesShopState();
    }
  }

  // Получение текущей геолокации пользователя
  Future<LocationData> getMyLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    return await location.getLocation();
  }

  // Поиск ближайшего магазина
  Future<AddressesShopModel> getNearestStore(LocationData myLocation, AddressesShopListModel loadedShops) async {
    final Distance distance = Distance();
    double minDistance;
    AddressesShopModel nearestStore;
    try {
      if (myLocation == null || loadedShops.data.isEmpty) return null;
      for (var shop in loadedShops.data) {
        double currentDistance = distance(
          LatLng(myLocation.latitude, myLocation.longitude),
          LatLng(double.tryParse(shop.addressLatitude), double.tryParse(shop.addressLongitude)),
        );

        if (minDistance == null || currentDistance < minDistance) {
          minDistance = currentDistance;
          nearestStore = shop;
        }
      }
    } catch (e) {
      log("Ошибка определения ближайшего магазина", error: e);
      return null;
    }
    return nearestStore;
  }

  // Обработка события загрузки магазинов
  Stream<AddressesShopState> _mapLoadShopsToState(ListAddressesShopEvent event) async* {
    yield LoadingAddressesShopState();
    try {
      AddressesShopListModel loadedShops = event.loadedModel ??
          await AddressesShopRepo(
            searchText: event.searchText,
            hasAtms: event.hasAtms,
            hasParking: event.hasParking,
            hasReadyMeals: event.hasReadyMeals,
            isOpenNow: event.isOpenNow,
            isfavorite: event.isFavorite,
          ).getAllShops();

      // Если notNeedToAskLocationAgain = true, то не запрашиваем геолокацию
      LocationData myLocation = null;
      AddressesShopModel nearestStore = null;
      if (event.notNeedToAskLocationAgain == false) {
        print('event.myLocation = ${event.myLocation}');
        myLocation = event.myLocation ?? await getMyLocation();
        nearestStore = await getNearestStore(myLocation, loadedShops);
      }

      final savedShopUuid = prefs.getString(SharedKeys.shopUuid);
      log('🔍 savedShopUuid из SharedPreferences: $savedShopUuid');
      AddressesShopModel selectedShop = loadedShops.data.firstWhere(
        (shop) {
          log('➡️ Проверяем: shop.uuid == savedShopUuid: ${shop.uuid} == $savedShopUuid');
          return shop.uuid == savedShopUuid;
        },
        orElse: () {
          if (event.isSetNearestAsSelected && nearestStore != null) {
            log('✅ Выбираем ближайший магазин: ${nearestStore.uuid}');
            return nearestStore;
          } else {
            log('✅ Выбираем первый магазин из списка: ${loadedShops.data[0].uuid}');
            return loadedShops.data[0];
          }
        },
      );

      if (savedShopUuid != selectedShop.uuid) {
        log('🏪💾 Итоговый выбранный магазин setString shopUuid: ${selectedShop.uuid}');
        await prefs.setString(SharedKeys.shopUuid, selectedShop.uuid);
        await prefs.setString(SharedKeys.shopAddress, selectedShop.address);
        await prefs.setString(SharedKeys.shopLogo, selectedShop.image.thumbnails.the1000X1000);
      }

      if (nearestStore != null) {
        log('nearestStore: 📍 ${nearestStore.uuid}, ${nearestStore.address}');
      }

      yield LoadedAddressesShopState(
        hasAtms: event.hasAtms,
        hasParking: event.hasParking,
        hasReadyMeals: event.hasReadyMeals,
        isOpenNow: event.isOpenNow,
        isFavorite: event.isFavorite,
        loadedShopsList: loadedShops,
        myLocation: myLocation, // Может быть null
        searchText: event.searchText,
        nearestStore: nearestStore,
        selectedShop: selectedShop,
      );
    } catch (e) {
      log("Ошибка загрузки магазинов", error: e);
      yield ErrorAddressesShopState();
    }
  }

  // Обработка загрузки магазинов для карты
  Stream<AddressesShopState> _mapLoadShopsForMapToState(MapAddressesShopEvent event) async* {
    yield LoadingMapAddressesShopState();

    try {
      AddressesShopListModel loadedShops = event.loadedModel ?? await AddressesShopRepo().getAllShops();
      LocationData myLocation = event.myLocation ?? await getMyLocation();
      AddressesShopModel nearestStore = await getNearestStore(myLocation, loadedShops);

      yield LoadedAddressesShopState(
        hasAtms: event.hasAtms,
        hasParking: event.hasParking,
        hasReadyMeals: event.hasReadyMeals,
        isOpenNow: event.isOpenNow,
        isFavorite: event.isFavorite,
        loadedShopsList: loadedShops,
        myLocation: myLocation,
        searchText: event.searchText,
        nearestStore: nearestStore,
      );
    } catch (e) {
      log("Ошибка загрузки магазинов на карту", error: e);
      yield ErrorAddressesShopState();
    }
  }

  // Обработка выбора магазина
  Stream<AddressesShopState> _mapSelectShopToState(SelectAddressShopEvent event) async* {
    if (state is LoadedAddressesShopState) {
      final currentState = state as LoadedAddressesShopState;
      final newSelectedShop = currentState.loadedShopsList.data.firstWhere(
        (shop) => shop.uuid == event.shopUuid,
        orElse: () => null,
      );

      if (newSelectedShop != null) {
        log('💾 setString shopUuid: ${event.shopUuid} / newSelectedShop: $newSelectedShop');
        await prefs.setString(SharedKeys.shopUuid, event.shopUuid);
        yield currentState.copyWith(selectedShop: newSelectedShop);
      }
    }
  }
}
