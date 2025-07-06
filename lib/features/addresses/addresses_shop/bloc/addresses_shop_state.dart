import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_list_model.dart';
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_model.dart';

abstract class AddressesShopState {} // ShopsListState

class ErrorAddressesShopState extends AddressesShopState {} // ShopsListErrorState

class OnMapEmptyAddressesShopState extends AddressesShopState {} // ShopsListOnMapEmptyState

// Загрузка списком // ShopsListAsListLoadingState
class LoadingAddressesShopState extends AddressesShopState {}

// Загрузка на карту // ShopsListAsMapPointsLoadingState
class LoadingMapAddressesShopState extends AddressesShopState {}

// Загруженный список магазинов на карте // ShopsAsMapPointsLoadedState
class LoadedMapAddressesShopState extends AddressesShopState {
  final AddressesShopListModel loadedShopsList;
  final LocationData myLocation;
  final AddressesShopModel nearestStore;
  final bool hasParking;
  final bool hasReadyMeals;
  final bool hasAtms;
  final bool isFavorite;
  final bool isOpenNow;
  final String searchText;

  LoadedMapAddressesShopState({
    @required this.loadedShopsList,
    this.myLocation,
    this.nearestStore,
    this.hasParking,
    this.hasReadyMeals,
    this.hasAtms,
    this.isFavorite,
    this.isOpenNow,
    this.searchText,
  });

  LoadedMapAddressesShopState copyWith({
    AddressesShopListModel loadedShopsList,
    AddressesShopModel nearestStore,
  }) {
    return LoadedMapAddressesShopState(
      loadedShopsList: loadedShopsList ?? this.loadedShopsList,
      myLocation: this.myLocation,
      nearestStore: nearestStore ?? this.nearestStore,
      hasParking: this.hasParking,
      hasReadyMeals: this.hasReadyMeals,
      hasAtms: this.hasAtms,
      isFavorite: this.isFavorite,
      isOpenNow: this.isOpenNow,
      searchText: this.searchText,
    );
  }
}

// Загруженный список магазинов // ShopsListAsListLoadedState
class LoadedAddressesShopState extends AddressesShopState {
  final String searchText;
  final LocationData myLocation;
  final bool hasParking;
  final bool hasReadyMeals;
  final bool hasAtms;
  final bool isFavorite;
  final AddressesShopModel nearestStore;
  final bool isOpenNow;
  final AddressesShopListModel loadedShopsList;
  final AddressesShopModel selectedShop;

  LoadedAddressesShopState({
    this.searchText,
    this.myLocation,
    this.hasParking,
    this.hasReadyMeals,
    this.hasAtms,
    this.isFavorite,
    this.nearestStore,
    this.isOpenNow,
    @required this.loadedShopsList,
    this.selectedShop,
  });

  LoadedAddressesShopState copyWith({
    AddressesShopListModel loadedShopsList,
    AddressesShopModel selectedShop,
  }) {
    return LoadedAddressesShopState(
      searchText: this.searchText,
      myLocation: this.myLocation,
      hasParking: this.hasParking,
      hasReadyMeals: this.hasReadyMeals,
      hasAtms: this.hasAtms,
      isFavorite: this.isFavorite,
      nearestStore: this.nearestStore,
      isOpenNow: this.isOpenNow,
      loadedShopsList: loadedShopsList ?? this.loadedShopsList,
      selectedShop: selectedShop ?? this.selectedShop,
    );
  }
}
