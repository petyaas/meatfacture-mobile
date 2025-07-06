//events
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SelectedPayCardAndAddressForOrderEvent {}

class SelectedPayCardAndAddressForOrderLoadEvent extends SelectedPayCardAndAddressForOrderEvent {
  final String cardUuid;
  final String addressForDelivery;
  final int floor;
  final int entrance;
  final int apartmentNumber;
  final String intercomCode;
  final String orderType;
  final int addressindex;
  final String payType;
  final String payCardNumber;

  SelectedPayCardAndAddressForOrderLoadEvent({
    this.payType,
    @required this.payCardNumber,
    this.addressindex,
    this.cardUuid,
    this.addressForDelivery,
    this.floor,
    this.entrance,
    this.apartmentNumber,
    this.intercomCode,
    this.orderType,
  });
}

abstract class SelectedPayCardAndAddressForOrderState {}

class SelectedPayCardAndAddressForOrderInitState extends SelectedPayCardAndAddressForOrderState {}

class SelectedPayCardAndAddressForOrderLoadedState extends SelectedPayCardAndAddressForOrderState {
  String cardUuid;
  final String addressForDelivery;
  int addressindex;
  final String payType;
  final int floor;
  final int entrance;
  final int apartmentNumber;
  final String intercomCode;
  final String orderType;
  final String emailAddress;
  String payCardNumber;

  SelectedPayCardAndAddressForOrderLoadedState({
    this.emailAddress,
    @required this.payCardNumber,
    this.payType,
    this.cardUuid,
    this.addressindex,
    this.orderType,
    this.addressForDelivery,
    this.floor,
    this.entrance,
    this.apartmentNumber,
    this.intercomCode,
  });
}

//bloc class
class SelectedPayCardAndAddressForOrderBloc extends Bloc<SelectedPayCardAndAddressForOrderEvent, SelectedPayCardAndAddressForOrderState> {
  SelectedPayCardAndAddressForOrderBloc() : super(SelectedPayCardAndAddressForOrderLoadedState(payCardNumber: null));

  @override
  Stream<SelectedPayCardAndAddressForOrderState> mapEventToState(SelectedPayCardAndAddressForOrderEvent event) async* {
    if (event is SelectedPayCardAndAddressForOrderLoadEvent) {
      yield SelectedPayCardAndAddressForOrderLoadedState(
        addressForDelivery: event.addressForDelivery,
        apartmentNumber: event.apartmentNumber,
        cardUuid: event.cardUuid,
        entrance: event.entrance,
        orderType: event.orderType,
        addressindex: event.addressindex,
        payType: event.payType,
        floor: event.floor,
        intercomCode: event.intercomCode,
        payCardNumber: event.payCardNumber,
      );
    }
  }
}
