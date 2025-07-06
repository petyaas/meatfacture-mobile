//events
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/product_details_data_model.dart';

abstract class ProductInShopEvent {}

class ProductInShopAsMapEvent extends ProductInShopEvent {
  final List<ProductDetailsStoreListModel> storesListModel;
  final String assortmentUnitId;

  ProductInShopAsMapEvent(
      {@required this.assortmentUnitId, @required this.storesListModel});
}

class ProductInShopAsListEvent extends ProductInShopEvent {
  final List<ProductDetailsStoreListModel> storesListModel;
  final String assortmentUnitId;

  ProductInShopAsListEvent(
      {@required this.assortmentUnitId, @required this.storesListModel});
}

//states

abstract class ProductInShopState {}

class ProductInShopInitState extends ProductInShopState {}

class ProductInShopAsMapState extends ProductInShopState {
  final List<ProductDetailsStoreListModel> storesListModel;
  final String assortmentUnitId;

  ProductInShopAsMapState(
      {@required this.assortmentUnitId, @required this.storesListModel});
}

class ProductInShopAsListState extends ProductInShopState {
  final List<ProductDetailsStoreListModel> storesListModel;
  final String assortmentUnitId;
  ProductInShopAsListState(
      {@required this.assortmentUnitId, @required this.storesListModel});
}

class ProductInShopBloc extends Bloc<ProductInShopEvent, ProductInShopState> {
  ProductInShopBloc() : super(ProductInShopInitState());

  @override
  Stream<ProductInShopState> mapEventToState(ProductInShopEvent event) async* {
    if (event is ProductInShopAsMapEvent) {
      yield ProductInShopAsMapState(
          storesListModel: event.storesListModel,
          assortmentUnitId: event.assortmentUnitId);
    } else if (event is ProductInShopAsListEvent) {
      yield ProductInShopAsListState(
          storesListModel: event.storesListModel,
          assortmentUnitId: event.assortmentUnitId);
    }
  }
}
