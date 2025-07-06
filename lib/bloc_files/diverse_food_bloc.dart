//ebents
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/diverse_food_assortment_list_model.dart';
import 'package:smart/models/diverse_food_future_discount_model.dart';
import 'package:smart/models/diverse_food_persent_list_model.dart';
import 'package:smart/models/diverse_food_present_discount_model.dart';
import 'package:smart/models/diverse_food_stats_model.dart';
import 'package:smart/models/prodmo_descriptions_model.dart';
import 'package:smart/services/services.dart';

abstract class DiverseFoodEvent {}

class DiverseFoodLoadEvent extends DiverseFoodEvent {}

//states
abstract class DiverseFoodState {}

class DiverseFoodLoadingState extends DiverseFoodState {}

class DiverseFoodErrorState extends DiverseFoodState {}

class DiverseFoodOldTokenState extends DiverseFoodState {}

class DiverseFoodInitState extends DiverseFoodState {}

class DiverseFoodLoadedState extends DiverseFoodState {
  final DiverseFoodPersentListModel diverseFoodPersentListModel;
  final DiverseFoodFutureDiscountModel diverseFoodFutureDiscountModel;
  final DiverseFoodPresentDiscountModel diverseFoodPresentDiscountModel;
  final DiverseFoodStatsModel diverseFoodStatsModel;
  final DiverseFoodAssortmentListModel isRatedProductsList;
  final DiverseFoodAssortmentListModel isNotRatedProductsList;
  final PromoDescriptionsDataModel dFDescription;

  DiverseFoodLoadedState(
      {@required this.dFDescription,
      @required this.isRatedProductsList,
      @required this.isNotRatedProductsList,
      @required this.diverseFoodPersentListModel,
      @required this.diverseFoodFutureDiscountModel,
      @required this.diverseFoodPresentDiscountModel,
      @required this.diverseFoodStatsModel});
}

//bloc
class DiverseFoodBloc extends Bloc<DiverseFoodEvent, DiverseFoodState> {
  DiverseFoodBloc() : super(DiverseFoodInitState());

  @override
  Stream<DiverseFoodState> mapEventToState(DiverseFoodEvent event) async* {
    if (event is DiverseFoodLoadEvent) {
      yield DiverseFoodLoadingState();
      try {
        DiverseFoodStatsModel _diverseFoodStatsModel =
            await DiverseFoodProvider().diverseFoodStatsResponse();
        DiverseFoodFutureDiscountModel _diverseFoodFutureDiscountModel =
            await DiverseFoodProvider().diverseFoodFutureDiscountResponse();
        DiverseFoodPresentDiscountModel _diverseFoodPresentDiscountModel =
            await DiverseFoodProvider().diverseFoodPresentDiscountResponse();
        DiverseFoodPersentListModel _diverseFoodPersentListModel =
            await DiverseFoodProvider().getImInShopPersentListModelResponse();
        DiverseFoodAssortmentListModel isRatedProductsList =
            await DiverseFoodProvider()
                .diverseFoodAssortmentListResponse(isRated: true, page: 1);
        DiverseFoodAssortmentListModel isNotRatedProductsList =
            await DiverseFoodProvider()
                .diverseFoodAssortmentListResponse(isRated: false, page: 1);

        PromoDescriptionsDataModel descriptionsDataModel =
            await PromoDescriptionsProvider()
                .getDiverseFoodDescriptionsResponse();

        yield DiverseFoodLoadedState(
            dFDescription: descriptionsDataModel,
            diverseFoodPersentListModel: _diverseFoodPersentListModel,
            diverseFoodFutureDiscountModel: _diverseFoodFutureDiscountModel,
            diverseFoodPresentDiscountModel: _diverseFoodPresentDiscountModel,
            diverseFoodStatsModel: _diverseFoodStatsModel,
            isNotRatedProductsList: isNotRatedProductsList,
            isRatedProductsList: isRatedProductsList);
      } catch (_) {
        if (_.toString().contains("401")) {
          yield DiverseFoodOldTokenState();
        } else {
          yield DiverseFoodErrorState();
        }
      }
    }
  }
}
