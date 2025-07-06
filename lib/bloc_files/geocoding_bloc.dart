//events

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/geocoding_model.dart';
import 'package:smart/services/services.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

abstract class GeocodingEvent {}

class GeocodingLoadEvent extends GeocodingEvent {
  final String address;
  final Point latLngOfAddress;
  GeocodingLoadEvent({this.address, this.latLngOfAddress});
}

//satates
abstract class GeocodingState {}

class GeocodingLoadingState extends GeocodingState {}

class GeocodingEmptyState extends GeocodingState {}

class GeocodingErrorState extends GeocodingState {}

class GeocodingTooFarState extends GeocodingState {}

class GeocodingLoadedState extends GeocodingState {
  final GeocodingModel geocodingModel;
  final bool isReverse;

  GeocodingLoadedState({
    @required this.isReverse,
    @required this.geocodingModel,
  });
}

class Geocodingbloc extends Bloc<GeocodingEvent, GeocodingState> {
  Geocodingbloc() : super(GeocodingEmptyState());

  @override
  Stream<GeocodingState> mapEventToState(GeocodingEvent event) async* {
    if (event is GeocodingLoadEvent) {
      yield GeocodingLoadingState();
      try {
        GeocodingModel _geocodingModel;
        if (event.address != null) {
          _geocodingModel = await GeocodingProvider()
              .getGeocodingResponse(address: event.address);
        } else {
          _geocodingModel = await GeocodingProvider()
              .getGeocodingReverseResponse(latLng: event.latLngOfAddress);
        }

        if (_geocodingModel.data.isEmpty) {
          yield GeocodingTooFarState();
        } else {
          yield GeocodingLoadedState(
              isReverse: event.latLngOfAddress != null,
              geocodingModel: _geocodingModel);
        }
      } catch (error) {
        yield GeocodingErrorState();
      }
    }
  }
}
