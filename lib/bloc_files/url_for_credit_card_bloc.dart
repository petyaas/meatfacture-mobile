//event

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/url_for_credit_carde_link_model.dart';
import 'package:smart/services/services.dart';

abstract class UrlForCreditCardLinkEvent {}

class UrlForCreditCardLinkLoadEvent extends UrlForCreditCardLinkEvent {}

//states

abstract class UrlForCreditCardLinkState {}

class UrlForCreditCardLinkInitState extends UrlForCreditCardLinkState {}

class UrlForCreditCardLinkLoadingState extends UrlForCreditCardLinkState {}

class UrlForCreditCardLinkErrorState extends UrlForCreditCardLinkState {}

class UrlForCreditCardLinkLoadState extends UrlForCreditCardLinkState {
  final UrlForCreditCardLinkModel urlForCreditCardLinkModel;

  UrlForCreditCardLinkLoadState({@required this.urlForCreditCardLinkModel});
}

//bloc

class UrlForCreditCardLinkBloc
    extends Bloc<UrlForCreditCardLinkEvent, UrlForCreditCardLinkState> {
  UrlForCreditCardLinkBloc() : super(UrlForCreditCardLinkInitState());

  @override
  Stream<UrlForCreditCardLinkState> mapEventToState(
      UrlForCreditCardLinkEvent event) async* {
    if (event is UrlForCreditCardLinkEvent) {
      yield UrlForCreditCardLinkLoadingState();
      try {
        final UrlForCreditCardLinkModel _urlForCreditCardLinkModel =
            await CreditCardsProvider().getUrlForCreditCardLinkResponse();
        yield UrlForCreditCardLinkLoadState(
            urlForCreditCardLinkModel: _urlForCreditCardLinkModel);
      } catch (error) {
        yield UrlForCreditCardLinkErrorState();
      }
    }
  }
}
