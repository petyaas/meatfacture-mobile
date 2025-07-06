import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/assortments_list_model.dart';
import 'package:smart/services/services.dart';

//Events

abstract class YellowPromoAssortmentsEvent {}

class YellowPromoAssortmentsLoadEvent extends YellowPromoAssortmentsEvent {}

//states
abstract class YellowPromoAssortmentsState {}

class YellowPromoAssortmentsLoadingState extends YellowPromoAssortmentsState {}

class YellowPromoAssortmentsErrorState extends YellowPromoAssortmentsState {}

class YellowPromoAssortmentsEmptyState extends YellowPromoAssortmentsState {}

class YellowPromoAssortmentsLoadedState extends YellowPromoAssortmentsState {
  final List<AssortmentsListModel> assortmentsList;

  YellowPromoAssortmentsLoadedState({@required this.assortmentsList});
}

class YellowPromoAssortmentsBloc
    extends Bloc<YellowPromoAssortmentsEvent, YellowPromoAssortmentsState> {
  YellowPromoAssortmentsBloc() : super(YellowPromoAssortmentsLoadingState());

  @override
  Stream<YellowPromoAssortmentsState> mapEventToState(
      YellowPromoAssortmentsEvent event) async* {
    if (event is YellowPromoAssortmentsLoadEvent) {
      yield YellowPromoAssortmentsLoadingState();
      try {
        final List<AssortmentsListModel> _assortmentsList =
            await AssortmentsProvider(currentPage: 1, isPromoAssortment: true)
                .getAssortmentsForPagination();
        if (_assortmentsList.isEmpty) {
          yield YellowPromoAssortmentsEmptyState();
        } else {
          yield YellowPromoAssortmentsLoadedState(
              assortmentsList: _assortmentsList);
        }
      } catch (_) {
        yield YellowPromoAssortmentsErrorState();
      }
    }
  }
}
