//events

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/credit_cards_list_model.dart';
import 'package:smart/services/services.dart';

abstract class CreditCardsListEvent {}

class CreditCardsListLoadEvent extends CreditCardsListEvent {}

//states

abstract class CreditCardsListState {}

class CreditCardsListLoadingState extends CreditCardsListState {}

class CreditCardsListInitState extends CreditCardsListState {}

class CreditCardsListErrorState extends CreditCardsListState {}

class CreditCardsListLoadedState extends CreditCardsListState {
  final CreditCardsListModel cardsListModel;

  CreditCardsListLoadedState({@required this.cardsListModel});
}

//bloc class

class CreditCardsListBloc extends Bloc<CreditCardsListEvent, CreditCardsListState> {
  CreditCardsListBloc() : super(CreditCardsListInitState());

  @override
  Stream<CreditCardsListState> mapEventToState(CreditCardsListEvent event) async* {
    yield CreditCardsListLoadingState();
    try {
      final _creditCardsListModel = await CreditCardsProvider().getCreditCardsListResponce();
      yield CreditCardsListLoadedState(cardsListModel: _creditCardsListModel);
    } catch (e) {
      yield CreditCardsListErrorState();
    }
  }
}
