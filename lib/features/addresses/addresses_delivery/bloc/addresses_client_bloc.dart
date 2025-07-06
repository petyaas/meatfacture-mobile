//events
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/features/addresses/addresses_delivery/models/address_client_model.dart';
import 'package:smart/services/services.dart';

abstract class AddressesClientEvent {}

class LoadedAddressesClientEvent extends AddressesClientEvent {}

class SelectAddressesClientEvent extends AddressesClientEvent {
  final String addressUuid;
  SelectAddressesClientEvent(this.addressUuid);
}

//states

abstract class ClientAddressState {}

class InitialClientAddressState extends ClientAddressState {}

class ErrorClientAddressState extends ClientAddressState {}

class LoadingClientAddressState extends ClientAddressState {}

class LoadedClientAddressState extends ClientAddressState {
  final List<AddressClientModel> clientAddressModelList;
  final AddressClientModel selectedAddress;

  LoadedClientAddressState({
    @required this.clientAddressModelList,
    this.selectedAddress,
  });

  LoadedClientAddressState copyWith({
    List<AddressClientModel> addresses,
    AddressClientModel selectedAddress,
  }) {
    return LoadedClientAddressState(
      clientAddressModelList: addresses ?? this.clientAddressModelList,
      selectedAddress: selectedAddress ?? this.selectedAddress,
    );
  }
}

class AddressesClientBloc extends Bloc<AddressesClientEvent, ClientAddressState> {
  final SharedPreferences prefs;
  final AddressesClientProvider addressProvider;

  AddressesClientBloc({
    @required this.prefs,
    @required this.addressProvider,
  }) : super(InitialClientAddressState());

  @override
  Stream<ClientAddressState> mapEventToState(
    AddressesClientEvent event,
  ) async* {
    if (event is LoadedAddressesClientEvent) {
      yield* _mapLoadAddressesToState();
    } else if (event is SelectAddressesClientEvent) {
      yield* _mapSelectAddressToState(event);
    }
  }

  Stream<ClientAddressState> _mapLoadAddressesToState() async* {
    yield LoadingClientAddressState();

    try {
      final response = await addressProvider.clientAddressResponse();
      final addresses = response.data;

      final savedUuid = prefs.getString(SharedKeys.myAddressUuid);
      final selected = addresses.firstWhere(
        (a) => a.uuid == savedUuid,
        orElse: () => addresses.isNotEmpty ? addresses.first : null,
      );

      yield LoadedClientAddressState(
        clientAddressModelList: addresses,
        selectedAddress: selected,
      );
    } catch (e, stackTrace) {
      log("Address loading failed", error: e, stackTrace: stackTrace);
      yield ErrorClientAddressState();
    }
  }

  Stream<ClientAddressState> _mapSelectAddressToState(
    SelectAddressesClientEvent event,
  ) async* {
    if (state is LoadedClientAddressState) {
      final currentState = state as LoadedClientAddressState;

      final newSelected = currentState.clientAddressModelList.firstWhere(
        (a) => a.uuid == event.addressUuid,
        orElse: () => null,
      );

      if (newSelected != null) {
        log('💾 setString myAddressUuid: ${event.addressUuid} / newSelected: $newSelected');
        await prefs.setString(SharedKeys.myAddressUuid, event.addressUuid);
        yield currentState.copyWith(selectedAddress: newSelected);
      }
    }
  }

  Future<void> refreshAddresses() async {
    add(LoadedAddressesClientEvent());
  }
}
