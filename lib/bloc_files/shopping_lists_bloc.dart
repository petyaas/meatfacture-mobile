//Events

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/shopping_lists_model.dart';
import 'package:smart/repositories/shopping_lists_repository.dart';

abstract class ShoppingListsEvent {}

class ShoppingListsLoadEvent extends ShoppingListsEvent {}

//states
abstract class ShoppingListsState {}

class ShoppingListsErrorState extends ShoppingListsState {}

class ShoppingListsOldTokenState extends ShoppingListsState {}

class ShoppingListsEmptyState extends ShoppingListsState {}

class ShoppingListsLoadingState extends ShoppingListsState {}

class ShoppingListsLoadedState extends ShoppingListsState {
  final ShoppingListsModel shoppingListsModel;
  ShoppingListsLoadedState({@required this.shoppingListsModel});
}

class ShoppingListsBloc extends Bloc<ShoppingListsEvent, ShoppingListsState> {
  ShoppingListsBloc() : super(ShoppingListsEmptyState());

  @override
  Stream<ShoppingListsState> mapEventToState(ShoppingListsEvent event) async* {
    if (event is ShoppingListsLoadEvent) {
      yield ShoppingListsLoadingState();
      try {
        ShoppingListsModel _shoppingListsModel =
            await ShoppingListsRepository().getShoppingListsFromRepository();
        if (_shoppingListsModel.data.isEmpty) {
          yield ShoppingListsEmptyState();
        } else {
          yield ShoppingListsLoadedState(
              shoppingListsModel: _shoppingListsModel);
        }
      } catch (error) {
        if (error.toString().contains("401")) {
          yield ShoppingListsOldTokenState();
        }
        yield ShoppingListsErrorState();
      }
    }
  }
}
