import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/product_details_model.dart';

//Events

abstract class ProductDetMiddleContentEvent {}

class ProductDetMiddleContentDescriptionEvent
    extends ProductDetMiddleContentEvent {
  final ProductDetailsModel productDetailsModel;
  ProductDetMiddleContentDescriptionEvent({@required this.productDetailsModel});
}

class ProductDetMiddleContentIngredientsEvent
    extends ProductDetMiddleContentEvent {
  final ProductDetailsModel productDetailsModel;

  ProductDetMiddleContentIngredientsEvent({@required this.productDetailsModel});
}

class ProductDetMiddleContentComentsEvent extends ProductDetMiddleContentEvent {
  final ProductDetailsModel productDetailsModel;

  ProductDetMiddleContentComentsEvent({@required this.productDetailsModel});
}

class ProductDetMiddleContentDisableEvent extends ProductDetMiddleContentEvent {
}

//states

abstract class ProductDetMiddleContentState {}

class ProductDetMiddleContentEmptyState extends ProductDetMiddleContentState {}

class ProductDetMiddleContentErrorState extends ProductDetMiddleContentState {}

class ProductDetMiddleContentLoadingState extends ProductDetMiddleContentState {
}

class ProductDetMiddleContentDescriptionState
    extends ProductDetMiddleContentState {
  final ProductDetailsModel productDetailsModel;

  ProductDetMiddleContentDescriptionState({@required this.productDetailsModel});
}

class ProductDetMiddleContentIngredientsState
    extends ProductDetMiddleContentState {
  final ProductDetailsModel productDetailsModel;

  ProductDetMiddleContentIngredientsState({@required this.productDetailsModel});
}

class ProductDetMiddleContentComentsState extends ProductDetMiddleContentState {
  final ProductDetailsModel productDetailsModel;

  ProductDetMiddleContentComentsState({@required this.productDetailsModel});
}

class ProductDetMiddleContentBloc
    extends Bloc<ProductDetMiddleContentEvent, ProductDetMiddleContentState> {
  ProductDetMiddleContentBloc() : super(ProductDetMiddleContentEmptyState());

  @override
  Stream<ProductDetMiddleContentState> mapEventToState(
      ProductDetMiddleContentEvent event) async* {
    if (event is ProductDetMiddleContentDescriptionEvent) {
      try {
        yield ProductDetMiddleContentDescriptionState(
            productDetailsModel: event.productDetailsModel);
      } catch (_) {
        yield ProductDetMiddleContentErrorState();
      }
    }

    if (event is ProductDetMiddleContentIngredientsEvent) {
      try {
        yield ProductDetMiddleContentIngredientsState(
            productDetailsModel: event.productDetailsModel);
      } catch (_) {
        yield ProductDetMiddleContentErrorState();
      }
    }

    if (event is ProductDetMiddleContentComentsEvent) {
      try {
        yield ProductDetMiddleContentComentsState(
            productDetailsModel: event.productDetailsModel);
      } catch (_) {
        yield ProductDetMiddleContentErrorState();
      }
    }

    if (event is ProductDetMiddleContentDisableEvent) {
      yield ProductDetMiddleContentEmptyState();
    }
  }
}
