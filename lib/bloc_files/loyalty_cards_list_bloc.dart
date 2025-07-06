import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/loyalty_cards_list_model.dart';
import 'package:smart/repositories/loyalty_cards_list_repository.dart';
import 'package:smart/services/services.dart';

//Events

abstract class LoyaltyCardsListEvent {}

class LoyaltyCardsListLoadEvent extends LoyaltyCardsListEvent {}

//state

abstract class LoyaltyCardsListState {}

class LoyaltyCardsListEmptyState extends LoyaltyCardsListState {}

class LoyaltyCardsListErrorState extends LoyaltyCardsListState {}

class LoyaltyCardsListLoadedState extends LoyaltyCardsListState {
  final LoyaltyCardsListModel loyaltyCardsListModel;
  final String purchasesSum;

  LoyaltyCardsListLoadedState(
      {@required this.purchasesSum, @required this.loyaltyCardsListModel});
}

class LoyaltyCardsListBloc
    extends Bloc<LoyaltyCardsListEvent, LoyaltyCardsListState> {
  LoyaltyCardsListBloc() : super(LoyaltyCardsListEmptyState());

  @override
  Stream<LoyaltyCardsListState> mapEventToState(
      LoyaltyCardsListEvent event) async* {
    if (event is LoyaltyCardsListLoadEvent) {
      yield LoyaltyCardsListEmptyState();
      try {
        LoyaltyCardsListModel _loyaltyCardsListModel =
            await LoyaltyCardsListRepository()
                .getLoyaltyCardsListFromRepository();
        String purchasesSum =
            await ProfileProvider().getPurchasesSumResponse(days: 14);
        yield LoyaltyCardsListLoadedState(
            purchasesSum: purchasesSum,
            loyaltyCardsListModel: _loyaltyCardsListModel);
      } catch (_) {
        yield LoyaltyCardsListErrorState();
      }
    }
  }
}
