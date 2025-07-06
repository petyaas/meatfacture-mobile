import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/features/basket/models/basket_list_model.dart';
import 'package:smart/features/basket/repo/basket_list_repository.dart';
import 'package:smart/models/credit_cards_list_model.dart';
import 'package:smart/models/order_calculate_response_model.dart';
import 'package:smart/models/product_model_for_order_request.dart';
import 'package:smart/services/services.dart';

abstract class BasketEvent {}

class BasketLoadEvent extends BasketEvent {}

class UpdateProductQuantityEvent extends BasketEvent {
  final int index;
  final double newQuantity;

  UpdateProductQuantityEvent({@required this.index, @required this.newQuantity});
}

class BasketAddOneInProductEvent extends BasketEvent {
  final BasketListModel basketListModel;

  BasketAddOneInProductEvent(this.basketListModel);
}

class BasketDeletOneFromProductEvent extends BasketEvent {
  final BasketListModel basketListModel;

  BasketDeletOneFromProductEvent({this.basketListModel});
}

class BasketRemoveItemEvent extends BasketEvent {
  final int index;

  BasketRemoveItemEvent(this.index);
}

//states

abstract class BasketState {}

class BasketLoadingState extends BasketState {}

class BasketEmptyState extends BasketState {}

class BasketOldTokenState extends BasketState {}

class BasketErrorState extends BasketState {}

class BasketinitState extends BasketState {}

class BasketLoadedState extends BasketState {
  BasketListModel basketListModel;
  final CreditCardsListModel cardsListModel;
  final OrderDetailsAndCalculateResponseModel orderCalculateResponseModel;
  final List<ProductModelForOrderRequest> productModelForOrderRequestList;

  BasketLoadedState({@required this.orderCalculateResponseModel, @required this.productModelForOrderRequestList, @required this.cardsListModel, @required this.basketListModel});
}

//BLoC

class BasketListBloc extends Bloc<BasketEvent, BasketState> {
  BasketListBloc() : super(BasketEmptyState());

  OrderDetailsAndCalculateResponseModel _orderCalculateResponseModel;
  CreditCardsListModel _creditCardsListModel;

  @override
  Stream<BasketState> mapEventToState(BasketEvent event) async* {
    log('👉👉👉 BasketListBloc');
    if (event is BasketLoadEvent) {
      log('👉👉 BasketListBloc BasketLoadEvent');
      yield BasketLoadingState();
      try {
        final BasketListModel _basketListmodel = await BasketListRepository().getBasketListFromRepository();
        _creditCardsListModel = await CreditCardsProvider().getCreditCardsListResponce();
        if (_basketListmodel.data == null || _creditCardsListModel.data == null) {
          yield BasketOldTokenState();
        }
        if (_basketListmodel.data.isNotEmpty) {
          List<ProductModelForOrderRequest> productModelForOrderRequestList = [];
          String _currentStoreUuid = await loadShopUuid();
          for (var i = 0; i < _basketListmodel.data.length; i++) {
            for (var j = 0; j < _basketListmodel.data[i].assortment.stores.length; j++) {
              if (_basketListmodel.data[i].assortment.stores[j].uuid == _currentStoreUuid) {
                //вписание колисество продукта в выбранном магазине
                _basketListmodel.data[i].assortment.quantityInStore = _basketListmodel.data[i].assortment.stores[j].productsquantity;
                continue;
              }
            }

            if ((_basketListmodel.data[i].assortment.currentPrice != null || _basketListmodel.data[i].assortment.priceWithDiscount != null) && _basketListmodel.data[i].assortment.quantityInStore != null && _basketListmodel.data[i].assortment.quantityInStore != 0) {
              productModelForOrderRequestList
                  .add(ProductModelForOrderRequest(assortmentUuid: _basketListmodel.data[i].assortment.uuid, quantity: _basketListmodel.data[i].assortment.assortmentUnitId != "kilogram" ? _basketListmodel.data[i].quantity : _basketListmodel.data[i].quantity));
            }
          }

          // расчет с ценами
          if (productModelForOrderRequestList.isNotEmpty) {
            log('расчет с ценами orderCalculateResponse');
            _orderCalculateResponseModel = await OrderProvider().orderCalculateResponse(
              orderDeliveryTypeId: null,
              orderPaymentTypeId: null,
              productModelForOrderRequestList: productModelForOrderRequestList,
            );

            yield BasketLoadedState(productModelForOrderRequestList: productModelForOrderRequestList, cardsListModel: _creditCardsListModel, basketListModel: _basketListmodel, orderCalculateResponseModel: _orderCalculateResponseModel);
          } else {
            yield BasketLoadedState(productModelForOrderRequestList: productModelForOrderRequestList, cardsListModel: _creditCardsListModel, basketListModel: _basketListmodel, orderCalculateResponseModel: null);
          }
        } else {
          yield BasketEmptyState();
        }
      } catch (_) {
        yield BasketErrorState();
      }
    } else if (event is UpdateProductQuantityEvent) {
      log('👉👉 BasketListBloc UpdateProductQuantityEvent');
      try {
        final basketListModel = (state as BasketLoadedState).basketListModel;
        final product = basketListModel.data[event.index];
        product.quantity = event.newQuantity;

        final updatedProductModelForOrderRequestList = basketListModel.data
            .where((item) => (item.assortment.currentPrice != null || item.assortment.priceWithDiscount != null) && item.assortment.quantityInStore != null)
            .map((item) => ProductModelForOrderRequest(assortmentUuid: item.assortment.uuid, quantity: item.quantity))
            .toList();
        log('else if (event is UpdateProductQuantityEvent)::  await OrderProvider().orderCalculateResponse');
        final orderCalculateResponseModel = await OrderProvider().orderCalculateResponse(
          orderDeliveryTypeId: null,
          orderPaymentTypeId: null,
          productModelForOrderRequestList: updatedProductModelForOrderRequestList,
        );

        yield BasketLoadedState(
          productModelForOrderRequestList: updatedProductModelForOrderRequestList,
          cardsListModel: (state as BasketLoadedState).cardsListModel,
          basketListModel: basketListModel,
          orderCalculateResponseModel: orderCalculateResponseModel,
        );
      } catch (_) {
        yield BasketErrorState();
      }
    }

    if (event is BasketAddOneInProductEvent) {
      log('👉👉 BasketListBloc BasketAddOneInProductEvent');
      List<ProductModelForOrderRequest> productModelForOrderRequestList = [];

      for (var i = 0; i < event.basketListModel.data.length; i++) {
        if ((event.basketListModel.data[i].assortment.currentPrice != null || event.basketListModel.data[i].assortment.priceWithDiscount != null) && event.basketListModel.data[i].assortment.quantityInStore != null && event.basketListModel.data[i].assortment.quantityInStore != 0) {
          productModelForOrderRequestList.add(ProductModelForOrderRequest(assortmentUuid: event.basketListModel.data[i].assortment.uuid, quantity: event.basketListModel.data[i].quantity));
        }
      }
      _creditCardsListModel = await CreditCardsProvider().getCreditCardsListResponce();
      // расчет с ценами
      log('расчет с ценами2 orderCalculateResponse');
      _orderCalculateResponseModel = await OrderProvider().orderCalculateResponse(orderDeliveryTypeId: null, orderPaymentTypeId: null, productModelForOrderRequestList: productModelForOrderRequestList);
      yield BasketLoadedState(
        productModelForOrderRequestList: productModelForOrderRequestList,
        cardsListModel: _creditCardsListModel,
        basketListModel: event.basketListModel,
        orderCalculateResponseModel: _orderCalculateResponseModel,
      );
    }

    if (event is BasketDeletOneFromProductEvent) {
      log('👉👉 BasketListBloc BasketDeletOneFromProductEvent');
      List<ProductModelForOrderRequest> productModelForOrderRequestList = [];

      for (var i = 0; i < event.basketListModel.data.length; i++) {
        if ((event.basketListModel.data[i].assortment.currentPrice != null || event.basketListModel.data[i].assortment.priceWithDiscount != null) && event.basketListModel.data[i].assortment.quantityInStore != null && event.basketListModel.data[i].assortment.quantityInStore != 0) {
          productModelForOrderRequestList.add(ProductModelForOrderRequest(assortmentUuid: event.basketListModel.data[i].assortment.uuid, quantity: event.basketListModel.data[i].quantity));
        }
      }
      // расчет с ценами
      log('расчет с ценами3 orderCalculateResponse');
      _orderCalculateResponseModel = await OrderProvider().orderCalculateResponse(
        orderDeliveryTypeId: null,
        orderPaymentTypeId: null,
        productModelForOrderRequestList: productModelForOrderRequestList,
      );

      _creditCardsListModel = await CreditCardsProvider().getCreditCardsListResponce();
      yield BasketLoadedState(productModelForOrderRequestList: productModelForOrderRequestList, cardsListModel: _creditCardsListModel, basketListModel: event.basketListModel, orderCalculateResponseModel: _orderCalculateResponseModel);
    }

    if (event is BasketRemoveItemEvent) {
      log('👉👉 BasketListBloc BasketRemoveItemEvent');
      if (state is BasketLoadedState) {
        final basketListModel = (state as BasketLoadedState).basketListModel;
        basketListModel.data.removeAt(event.index);

        if (basketListModel.data.isEmpty) {
          yield BasketEmptyState();
        } else {
          final updatedProductModelForOrderRequestList = basketListModel.data
              .where((item) => (item.assortment.currentPrice != null || item.assortment.priceWithDiscount != null) && item.assortment.quantityInStore != null)
              .map((item) => ProductModelForOrderRequest(assortmentUuid: item.assortment.uuid, quantity: item.quantity))
              .toList();
          log('event is BasketRemoveItemEvent => basketListModel.data.isEmpty ? else: orderCalculateResponse');
          final orderCalculateResponseModel = await OrderProvider().orderCalculateResponse(
            orderDeliveryTypeId: null,
            orderPaymentTypeId: null,
            productModelForOrderRequestList: updatedProductModelForOrderRequestList,
          );

          yield BasketLoadedState(
            productModelForOrderRequestList: updatedProductModelForOrderRequestList,
            cardsListModel: (state as BasketLoadedState).cardsListModel,
            basketListModel: basketListModel,
            orderCalculateResponseModel: orderCalculateResponseModel,
          );
        }
      }
    }
  }
}
