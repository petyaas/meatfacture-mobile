import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/shopping_list_deatils_model.dart';
import 'package:smart/repositories/shopping_list_details_repository.dart';

//events
abstract class ShoppingListDetailsEvent {}

class ShoppingListDetailsLoadEvent extends ShoppingListDetailsEvent {
  final String shoppingListUuid;
  ShoppingListDetailsLoadEvent({@required this.shoppingListUuid});
}

//states

abstract class ShoppingListDetailsState {}

class ShoppingListDetailsEmptyState extends ShoppingListDetailsState {}

class ShoppingListDetailsLoadingState extends ShoppingListDetailsState {}

class ShoppingListDetailsOldTokenState extends ShoppingListDetailsState {}

class ShoppingListDetailsErrorState extends ShoppingListDetailsState {
  final String shoppingListUuid;

  ShoppingListDetailsErrorState({@required this.shoppingListUuid});
}

class ShoppingListDetailsLoadedState extends ShoppingListDetailsState {
  final ShoppingListDeatailsModel shoppingListDeatailsModel;
  ShoppingListDetailsLoadedState({@required this.shoppingListDeatailsModel});
}

//bloc class
class ShoppingListDetailsBloc
    extends Bloc<ShoppingListDetailsEvent, ShoppingListDetailsState> {
  ShoppingListDetailsBloc() : super(ShoppingListDetailsEmptyState());

  @override
  Stream<ShoppingListDetailsState> mapEventToState(
      ShoppingListDetailsEvent event) async* {
    if (event is ShoppingListDetailsLoadEvent) {
      yield ShoppingListDetailsLoadingState();
      try {
        final ShoppingListDeatailsModel _shoppingListDeatailsModel =
            await ShoppingListDetailsRepository()
                .getShoppingListDetailsFromProvider(
                    shoppingListUuid: event.shoppingListUuid);
        if (_shoppingListDeatailsModel.data.assortments.isEmpty) {
          yield ShoppingListDetailsEmptyState();
        } else {
          yield ShoppingListDetailsLoadedState(
              shoppingListDeatailsModel: _shoppingListDeatailsModel);
        }
      } catch (error) {
        if (error.toString().contains("401")) {
          yield ShoppingListDetailsOldTokenState();
        } else {
          yield ShoppingListDetailsErrorState(
              shoppingListUuid: event.shoppingListUuid);
        }
      }
    }
  }
}
