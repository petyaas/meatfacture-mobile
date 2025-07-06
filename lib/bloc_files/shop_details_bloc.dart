import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_model.dart';
import 'package:smart/repositories/shops_details_repository.dart';

//Events
abstract class ShopDetailsEvent {}

class ShopDetailsDisableEvent extends ShopDetailsEvent {}

class ShopDetailsEnableEvent extends ShopDetailsEvent {
  final String lat;
  final String lon;

  String storeUuid;
  ShopDetailsEnableEvent({@required this.storeUuid, @required this.lat, @required this.lon}) : assert(storeUuid != null);
}

//states

abstract class ShopDetailsState {}

class ShopDetailLoadingState extends ShopDetailsState {}

class ShopDetailLoadedgState extends ShopDetailsState {
  final String lat;
  final String lon;
  AddressesShopModel shopDetailsLoadedModel;
  ShopDetailLoadedgState({@required this.lat, @required this.lon, @required this.shopDetailsLoadedModel}) : assert(shopDetailsLoadedModel != null);
}

class ShopDetailsErrorState extends ShopDetailsState {}

class ShopDetailsDisableState extends ShopDetailsState {}

class ShopDetailsBloc extends Bloc<ShopDetailsEvent, ShopDetailsState> {
  ShopDetailsBloc() : super(ShopDetailsDisableState());

  @override
  Stream<ShopDetailsState> mapEventToState(ShopDetailsEvent event) async* {
    if (event is ShopDetailsEnableEvent) {
      yield ShopDetailLoadingState();
      try {
        final AddressesShopModel _loadedShopDetails = await ShopDetailRepository(uuid: event.storeUuid).getShopDetailsFromRepository();
        yield ShopDetailLoadedgState(lat: event.lat, lon: event.lon, shopDetailsLoadedModel: _loadedShopDetails);
      } catch (_) {
        yield (ShopDetailsErrorState());
      }
    } else if (event is ShopDetailsDisableEvent) {
      yield ShopDetailsDisableState();
    }
  }
}
