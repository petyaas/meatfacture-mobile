//events
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/create_order_response_model.dart';
import 'package:smart/models/product_model_for_order_request.dart';
import 'package:smart/services/services.dart';

abstract class OrderCreatedEvent {}

class OrderCreatedLoadEvent extends OrderCreatedEvent {
  final String clientCreditCardUuid;
  final String address;
  final String clientComment;
  final String clientEmail;
  final int floor;
  final int entrance;
  final int apartmentNumber;
  final String intercomCode;
  final String plannedDeliveryDatetimeFrom;
  final String plannedDeliveryDatetimeTo;
  final String orderDeliveryTypeId;
  final String orderPaymentTypeId;
  final List<ProductModelForOrderRequest> productModelForOrderRequestList;
  final int subtractBonusesCount;

  OrderCreatedLoadEvent(
      {this.subtractBonusesCount,
      @required this.clientCreditCardUuid,
      @required this.address,
      @required this.clientComment,
      @required this.clientEmail,
      @required this.floor,
      @required this.entrance,
      @required this.apartmentNumber,
      @required this.intercomCode,
      @required this.plannedDeliveryDatetimeFrom,
      @required this.plannedDeliveryDatetimeTo,
      @required this.orderDeliveryTypeId,
      @required this.orderPaymentTypeId,
      @required this.productModelForOrderRequestList});
}

class OrderException implements Exception {
  final String errorText;

  OrderException({@required this.errorText});
}

//states

abstract class OrderCreatedState {}

class OrderCreatedInitState extends OrderCreatedState {}

class OrderCreatedLoadingState extends OrderCreatedState {}

class OrderCreatedTooFarForAddressErrorState extends OrderCreatedState {
  final errorText;

  OrderCreatedTooFarForAddressErrorState({this.errorText});
}

class OrderCreatedLoadedState extends OrderCreatedState {
  final OrderCreateResponseModel orderCreateResponseModel;

  OrderCreatedLoadedState({@required this.orderCreateResponseModel});
}

class OrderCreatedBloc extends Bloc<OrderCreatedEvent, OrderCreatedState> {
  OrderCreatedBloc() : super(OrderCreatedInitState());

  @override
  Stream<OrderCreatedState> mapEventToState(OrderCreatedEvent event) async* {
    if (event is OrderCreatedLoadEvent) {
      yield OrderCreatedLoadingState();
      try {
        final OrderCreateResponseModel _orderCreateResponseModel = await OrderProvider().createOrderResponse(
          subtractBonusesCount: event.subtractBonusesCount,
          clientCreditCardUuid: event.clientCreditCardUuid,
          address: event.address,
          apartmentNumber: event.apartmentNumber,
          clientComment: event.clientComment,
          clientEmail: event.clientEmail,
          entrance: event.entrance,
          floor: event.floor,
          intercomCode: event.intercomCode,
          orderDeliveryTypeId: event.orderDeliveryTypeId,
          orderPaymentTypeId: event.orderPaymentTypeId,
          plannedDeliveryDatetimeFrom: event.plannedDeliveryDatetimeFrom,
          plannedDeliveryDatetimeTo: event.plannedDeliveryDatetimeTo,
          productModelForOrderRequestList: event.productModelForOrderRequestList,
        );
        yield OrderCreatedLoadedState(orderCreateResponseModel: _orderCreateResponseModel);
      } on OrderException catch (e) {
        yield OrderCreatedTooFarForAddressErrorState(errorText: e);
      } catch (e) {
        yield OrderCreatedTooFarForAddressErrorState(
            errorText: 'Не смогли произвести списание средств за заказ. Повторите попытку или обретитесь за поддержкой в Банк');
      }
    }
  }
}
