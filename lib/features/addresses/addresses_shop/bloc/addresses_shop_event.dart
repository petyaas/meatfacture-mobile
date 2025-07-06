import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_list_model.dart';
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_model.dart';

abstract class AddressesShopEvent {}

// Список магазинов в виде списка // ShopsAsListEvent
class ListAddressesShopEvent extends AddressesShopEvent {
  final AddressesShopListModel loadedModel;
  final LocationData myLocation;
  final AddressesShopModel nearestStore;
  final String searchText;
  final bool hasParking;
  final bool hasReadyMeals;
  final bool hasAtms;
  final bool isFavorite;
  final bool isOpenNow;
  final bool notNeedToAskLocationAgain;
  final bool isSetNearestAsSelected;

  ListAddressesShopEvent({
    this.loadedModel,
    this.myLocation,
    this.nearestStore,
    this.searchText,
    this.hasParking,
    this.hasReadyMeals,
    this.hasAtms,
    this.isFavorite,
    this.isOpenNow,
    this.notNeedToAskLocationAgain = false,
    this.isSetNearestAsSelected = false,
  });
}

// Загрузка списка магазинов для карты // ShopsAsMapPointsEvent
class MapAddressesShopEvent extends AddressesShopEvent {
  final AddressesShopListModel loadedModel;
  final LocationData myLocation;
  final AddressesShopModel nearestStore;
  final String searchText;
  final bool hasParking;
  final bool hasReadyMeals;
  final bool hasAtms;
  final bool isFavorite;
  final bool isOpenNow;

  MapAddressesShopEvent({
    this.loadedModel,
    this.myLocation,
    this.nearestStore,
    this.searchText,
    this.hasParking,
    this.hasReadyMeals,
    this.hasAtms,
    this.isFavorite,
    this.isOpenNow,
  });
}

// Выбор конкретного магазина
class SelectAddressShopEvent extends AddressesShopEvent {
  final String shopUuid;
  SelectAddressShopEvent({@required this.shopUuid});
}

// Очистка списка магазинов
class EmptyAddressesShopEvent extends AddressesShopEvent {} //ShopsListEmptyEvent
