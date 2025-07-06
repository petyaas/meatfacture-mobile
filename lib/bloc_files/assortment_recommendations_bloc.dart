//events

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/assortments_list_model.dart';
import 'package:smart/services/services.dart';

abstract class AssortmentRecommendationsEvent {}

class AssortmentRecommendationsLoadEvent
    extends AssortmentRecommendationsEvent {}

//states
abstract class AssortmentRecommendationsState {}

class AssortmentRecommendationsLoadedState
    extends AssortmentRecommendationsState {
  final List<AssortmentsListModel> recommendationlist;

  AssortmentRecommendationsLoadedState({@required this.recommendationlist});
}

class AssortmentRecommendationsEmptyState
    extends AssortmentRecommendationsState {}

//bloc

class AssortmentRecommendationBloc extends Bloc<AssortmentRecommendationsEvent,
    AssortmentRecommendationsState> {
  AssortmentRecommendationBloc() : super(AssortmentRecommendationsEmptyState());

  @override
  Stream<AssortmentRecommendationsState> mapEventToState(
      AssortmentRecommendationsEvent event) async* {
    if (event is AssortmentRecommendationsLoadEvent) {
      yield AssortmentRecommendationsEmptyState();
      try {
        final List<AssortmentsListModel> _assortmentsListModel =
            await RecomendationProvider().getRecomendationListResponse(page: 1);

        if (_assortmentsListModel.isEmpty) {
          yield AssortmentRecommendationsEmptyState();
        } else {
          yield AssortmentRecommendationsLoadedState(
              recommendationlist: _assortmentsListModel);
        }
      } catch (_) {
        yield AssortmentRecommendationsEmptyState();
      }
    }
  }
}
