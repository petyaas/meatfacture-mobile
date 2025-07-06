//events

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/features/fav_product/models/favorite_product_model.dart';
import 'package:smart/models/favorite_product_title_model.dart';
import 'package:smart/models/favorite_product_variant_uuid_model.dart';
import 'package:smart/services/services.dart';

abstract class FavoriteProductEvent {}

class FavoriteProductLoadEvent extends FavoriteProductEvent {}

//states

abstract class FavoriteProductState {}

class FavoriteProductLoadingState extends FavoriteProductState {}

class FavoriteProductErrorState extends FavoriteProductState {}

class FavoriteProductOldTokenState extends FavoriteProductState {}

class FavoriteProductInitState extends FavoriteProductState {}

class FavoriteProductLoadedState extends FavoriteProductState {
  final String purchasesSumModel;
  final FavoriteProductModel favoriteProductModel;
  final FavoriteProductTitleModel favoriteProductTitleModel;
  final FavoriteProductVariantUuidModel favoriteProductVariantUuidModel;

  FavoriteProductLoadedState({this.favoriteProductVariantUuidModel, this.favoriteProductTitleModel, this.purchasesSumModel, @required this.favoriteProductModel});
}

class FavoriteProductBloc extends Bloc<FavoriteProductEvent, FavoriteProductState> {
  FavoriteProductBloc() : super(FavoriteProductInitState());

  @override
  Stream<FavoriteProductState> mapEventToState(FavoriteProductEvent event) async* {
    if (event is FavoriteProductLoadEvent) {
      yield FavoriteProductLoadingState();

      try {
        FavoriteProductVariantUuidModel _favoriteProductVariantUuidModel = await FavoriteProductProvider().getFavoriteProductVariantUuidResponse();
        final FavoriteProductModel _favoriteProductModel = await FavoriteProductProvider().getFavoriteProductResponse();
        FavoriteProductTitleModel _favoriteProductTitleModel = await PromoDescriptionsProvider().favoritePrductTitleRequest();
        String _purchasesSumModelfor1Day = await ProfileProvider().getPurchasesSumResponse(days: 1);

        yield FavoriteProductLoadedState(purchasesSumModel: _purchasesSumModelfor1Day, favoriteProductVariantUuidModel: _favoriteProductVariantUuidModel, favoriteProductModel: _favoriteProductModel, favoriteProductTitleModel: _favoriteProductTitleModel);
      } catch (_) {
        if (_.toString().contains("401")) {
          yield FavoriteProductOldTokenState();
        } else {
          yield FavoriteProductErrorState();
        }
      }
    }
  }
}
