//events

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/shopping_check_list_model.dart';
import 'package:smart/repositories/shopping_check_list_repository.dart';

abstract class ShoppingHisoryEvent {}

class ShoppingHistoryCheckListEvent extends ShoppingHisoryEvent {}

// class ShoppingHistoryScoresListEvent extends ShoppingHisoryEvent {}

class ShoppingHistoryOrdersListEvent extends ShoppingHisoryEvent {}

//states
abstract class ShoppingHisoryState {}

class ShoppingHistoryEmptytState extends ShoppingHisoryState {}

class ShoppingHistoryErrorState extends ShoppingHisoryState {}

class ShoppingHistoryCheckLoadingState extends ShoppingHisoryState {}

// class ShoppingHistoryScoresLoadingState extends ShoppingHisoryState {}

class ShoppingHistoryOrdersLoadingState extends ShoppingHisoryState {}

class ShoppingHistoryCheckListLoadedState extends ShoppingHisoryState {
  final ShoppingCheckListModel shoppingCheckListModel;
  ShoppingHistoryCheckListLoadedState({@required this.shoppingCheckListModel});
}

class ShoppingHistoryOrdersListLoadedState extends ShoppingHisoryState {
  // final OrderListModel orderListModel;
  // ShoppingHistoryOrdersListLoadedState({@required this.orderListModel});
}

class ShoppingHistoryBloc extends Bloc<ShoppingHisoryEvent, ShoppingHisoryState> {
  ShoppingHistoryBloc() : super(ShoppingHistoryEmptytState());

  @override
  Stream<ShoppingHisoryState> mapEventToState(ShoppingHisoryEvent event) async* {
    if (event is ShoppingHistoryCheckListEvent) {
      yield ShoppingHistoryCheckLoadingState();
      try {
        ShoppingCheckListModel shoppingCheckListModel = await ShoppingCheckListRepository().getShoppingCheckListFromRepository();
        yield ShoppingHistoryCheckListLoadedState(shoppingCheckListModel: shoppingCheckListModel);
      } catch (_) {
        yield ShoppingHistoryErrorState();
      }
    }

    if (event is ShoppingHistoryOrdersListEvent) {
      yield ShoppingHistoryOrdersListLoadedState();
    }

    // if (event is ShoppingHistoryScoresListEvent) {
    //   yield ShoppingHistoryScoresListState();
    // }
  }
}
