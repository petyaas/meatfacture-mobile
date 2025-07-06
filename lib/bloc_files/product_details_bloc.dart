//evens

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/product_details_model.dart';
import 'package:smart/repositories/product_details_repository.dart';

abstract class ProductDetailsEvent {}

class ProductDetailsLoadEvent extends ProductDetailsEvent {
  final String uuid;

  ProductDetailsLoadEvent({@required this.uuid});
}

class ProductDetailsAddToBasketEvent extends ProductDetailsEvent {
  final ProductDetailsModel productDetailsModel;

  ProductDetailsAddToBasketEvent({@required this.productDetailsModel});
}

class ProductDetailsRemoveToBasketEvent extends ProductDetailsEvent {
  final ProductDetailsModel productDetailsModel;

  ProductDetailsRemoveToBasketEvent({@required this.productDetailsModel});
}

//states

abstract class ProductDetailsState {}

class ProductDetailsEmptyState extends ProductDetailsState {}

class ProductDetailsErrorState extends ProductDetailsState {
  final String uuid;

  ProductDetailsErrorState({@required this.uuid});
}

class ProductDetailsLoadingState extends ProductDetailsState {}

class ProductDetailsLoadedState extends ProductDetailsState {
  final ProductDetailsModel productDetailsModel;

  ProductDetailsLoadedState({@required this.productDetailsModel});
}

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc() : super(ProductDetailsEmptyState());

  @override
  Stream<ProductDetailsState> mapEventToState(
      ProductDetailsEvent event) async* {
    if (event is ProductDetailsLoadEvent) {
      yield ProductDetailsLoadingState();
      try {
        final ProductDetailsModel _productDetailsModel =
            await ProductDetailsRepository()
                .getProductDeatilsFromRepository(uuid: event.uuid);
        yield ProductDetailsLoadedState(
            productDetailsModel: _productDetailsModel);
      } catch (_) {
        // print("******" + _.toString());
        yield ProductDetailsErrorState(uuid: event.uuid);
      }
    }

    if (event is ProductDetailsAddToBasketEvent) {
      yield ProductDetailsLoadedState(
          productDetailsModel: event.productDetailsModel);
    }
    if (event is ProductDetailsRemoveToBasketEvent) {
      yield ProductDetailsLoadedState(
          productDetailsModel: event.productDetailsModel);
    }
  }
}
