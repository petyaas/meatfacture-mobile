//Events

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/assortments_list_model.dart';
import '../services/services.dart';

abstract class RecomendationsEvent {}

class RecomendationsLoadEvent extends RecomendationsEvent {}

class RecomendationsNextPageEvent extends RecomendationsEvent {}

//states

abstract class RecomendationsState {
  final List<AssortmentsListModel> recomList;
  RecomendationsState({@required this.recomList});
}

class RecomendationsInitState extends RecomendationsState {
  RecomendationsInitState() : super(recomList: []);
}

class RecomendationsLoadingState extends RecomendationsState {
  RecomendationsLoadingState({@required List<AssortmentsListModel> recomList}) : super(recomList: recomList);
}

class RecomendationsErrorState extends RecomendationsState {
  RecomendationsErrorState({@required List<AssortmentsListModel> recomList}) : super(recomList: recomList);
}

class RecomendationsEmptyState extends RecomendationsState {
  RecomendationsEmptyState({@required List<AssortmentsListModel> recomsList}) : super(recomList: recomsList);
}

class RecomendationsLoadedState extends RecomendationsState {
  RecomendationsLoadedState({@required List<AssortmentsListModel> recomList}) : super(recomList: recomList);
}

class RecomendationsBloc extends Bloc<RecomendationsEvent, RecomendationsState> {
  RecomendationsBloc() : super(RecomendationsInitState());
  List<AssortmentsListModel> recomList = [];
  int currentPage = 1;
  int limit = 20;

  @override
  Stream<RecomendationsState> mapEventToState(RecomendationsEvent event) async* {
    if (event is RecomendationsLoadEvent) {
      yield RecomendationsLoadingState(recomList: recomList);
      try {
        recomList = await getRecomendationsFromRepository();
        if (recomList.isNotEmpty) {
          yield RecomendationsLoadedState(recomList: recomList);
        } else {
          yield RecomendationsEmptyState(recomsList: recomList);
        }
      } catch (e) {
        print("error in (REcomendationssBloc) class: $e )");
        yield RecomendationsErrorState(recomList: recomList);
      }
    }

    if (event is RecomendationsNextPageEvent) {
      if (recomList.length == limit * currentPage) {
        yield RecomendationsLoadingState(recomList: recomList);
        currentPage++;
        try {
          recomList.addAll(await getRecomendationsFromRepository());
          yield RecomendationsLoadedState(recomList: recomList);
        } catch (e) {
          print("error in (REcomendationssBloc) class: $e )");
          yield RecomendationsErrorState(recomList: recomList);
        }
      }
    }
  }

  Future<List<AssortmentsListModel>> getRecomendationsFromRepository() async {
    final recomendationProducts = await RecomendationProvider().getRecomendationListResponse(page: currentPage);
    recomendationProducts.removeWhere((e) => e.quantityInClientCart > 0);
    return recomendationProducts;
  }
}
