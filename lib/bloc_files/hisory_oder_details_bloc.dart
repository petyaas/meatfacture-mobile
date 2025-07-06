//events

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/order_calculate_response_model.dart';
import 'package:smart/services/services.dart';

abstract class HistoryOrderDetailsEvent {}

class HistoryOrderDetailsLoadEvent extends HistoryOrderDetailsEvent {
  final String orderId;

  HistoryOrderDetailsLoadEvent({@required this.orderId});
}

//states

abstract class HistoryOrderDetailsState {}

class HistoryOrderDetailsEmptyState extends HistoryOrderDetailsState {}

class HistoryOrderDetailsLoadingState extends HistoryOrderDetailsState {}

class HistoryOrderDetailsErrorState extends HistoryOrderDetailsState {}

class HistoryOrderDetailsLoadedState extends HistoryOrderDetailsState {
  final OrderDetailsAndCalculateResponseModel
      orderDetailsAndCalculateResponseModel;

  HistoryOrderDetailsLoadedState({this.orderDetailsAndCalculateResponseModel});
}

//bloc class
class HistoryOrdertDetailsBloc
    extends Bloc<HistoryOrderDetailsEvent, HistoryOrderDetailsState> {
  HistoryOrdertDetailsBloc() : super(HistoryOrderDetailsEmptyState());

  @override
  Stream<HistoryOrderDetailsState> mapEventToState(
      HistoryOrderDetailsEvent event) async* {
    if (event is HistoryOrderDetailsLoadEvent) {
      yield HistoryOrderDetailsLoadingState();
      try {
        final OrderDetailsAndCalculateResponseModel
            _orderDetailsAndCalculateResponseModel =
            await OrderProvider().orderDetailseResponse(orderId: event.orderId);
        yield HistoryOrderDetailsLoadedState(
            orderDetailsAndCalculateResponseModel:
                _orderDetailsAndCalculateResponseModel);
      } catch (_) {
        yield HistoryOrderDetailsErrorState();
      }
    }
  }
}
