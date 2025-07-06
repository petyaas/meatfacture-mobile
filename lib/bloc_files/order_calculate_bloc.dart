import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/order_calculate_response_model.dart';
import 'package:smart/models/product_model_for_order_request.dart';
import 'package:smart/services/services.dart';

abstract class OrderCalculateEvent {}

class OrderCalculateLoadEvent extends OrderCalculateEvent {
  final String orderDeliveryTypeId;
  final String orderPaymentTypeId;
  final List<ProductModelForOrderRequest> productModelForOrderRequestList;
  final int subtractBonusesCount;
  OrderCalculateLoadEvent(
      {this.subtractBonusesCount, @required this.orderDeliveryTypeId, @required this.orderPaymentTypeId, @required this.productModelForOrderRequestList});
}

//states
abstract class OrderCalculateState {
  final OrderDetailsAndCalculateResponseModel orderCalculateResponseModel;
  OrderCalculateState(this.orderCalculateResponseModel);
}

class OrderCalculateInitState extends OrderCalculateState {
  OrderCalculateInitState() : super(null);
}

class OrderCalculateLoadingState extends OrderCalculateState {
  OrderCalculateLoadingState({OrderDetailsAndCalculateResponseModel orderCalculateResponseModel}) : super(orderCalculateResponseModel);
}

class OrderCalculateErrorState extends OrderCalculateState {
  OrderCalculateErrorState() : super(null);
}

class OrderCalculateLoadedState extends OrderCalculateState {
  OrderCalculateLoadedState({OrderDetailsAndCalculateResponseModel orderCalculateResponseModel}) : super(orderCalculateResponseModel);
}

class OrderCalculateBloc extends Bloc<OrderCalculateEvent, OrderCalculateState> {
  OrderCalculateBloc() : super(OrderCalculateInitState());
  OrderDetailsAndCalculateResponseModel _orderDetailsAndCalculateResponseModel;
  String _promocode;
  String get promocode => _promocode;

  void updatePromoCode(String newPromoCode) {
    _promocode = newPromoCode;
    log('💾 Промокод обновлён вручную: $_promocode');
  }

  @override
  Stream<OrderCalculateState> mapEventToState(OrderCalculateEvent event) async* {
    if (event is OrderCalculateLoadEvent) {
      yield OrderCalculateLoadingState(orderCalculateResponseModel: _orderDetailsAndCalculateResponseModel);
      try {
        if (event.productModelForOrderRequestList.isNotEmpty) {
          log('🔄 Отправка запроса на расчёт заказа с промокодом: $_promocode');
          _orderDetailsAndCalculateResponseModel = await OrderProvider().orderCalculateResponse(
            subtractBonusesCount: event.subtractBonusesCount,
            orderDeliveryTypeId: event.orderDeliveryTypeId,
            orderPaymentTypeId: event.orderPaymentTypeId,
            productModelForOrderRequestList: event.productModelForOrderRequestList,
            promocode: _promocode,
          );
          //
          if (_orderDetailsAndCalculateResponseModel?.data?.promocode != null) {
            _promocode = _orderDetailsAndCalculateResponseModel.data.promocode;
            log('✅ Промокод успешно применён: $_promocode');
          } else {
            _promocode = null;
            log('❌ Промокод невалидный или устарел');
          }
          yield OrderCalculateLoadedState(orderCalculateResponseModel: _orderDetailsAndCalculateResponseModel);
        } else {
          log('⚠️ Отправка загрузки счета ⚠️ на калькуляцию запрос не отправлен так как список с продуктами пуст');
        }
      } catch (_) {
        yield OrderCalculateErrorState();
        print(_);
      }
    }
  }
}
