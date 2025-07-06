//Events
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/assortment_comments_model.dart';

import '../services/services.dart';

abstract class AssortmentCommentsEvent {}

class AssortmentCommentsLoadEvent extends AssortmentCommentsEvent {
  final String assortmentUuid;

  AssortmentCommentsLoadEvent({@required this.assortmentUuid});
}

class AssortmentCommentsShowMoreEvent extends AssortmentCommentsEvent {}

//states
abstract class AssortmentCommentsState {
  AssortmentCommentsModel assortmentCommentsModel =
      AssortmentCommentsModel(data: []);

  AssortmentCommentsState({this.assortmentCommentsModel});
}

class AssortmentCommentsLoadingState extends AssortmentCommentsState {
  AssortmentCommentsLoadingState(
      AssortmentCommentsModel assortmentCommentsModel)
      : super(assortmentCommentsModel: assortmentCommentsModel);
}

class AssortmentCommentsErrorState extends AssortmentCommentsState {}

class AssortmentCommentsInitState extends AssortmentCommentsState {}

class AssortmentCommentsEmtyState extends AssortmentCommentsState {}

class AssortmentCommentsLoadedState extends AssortmentCommentsState {
  AssortmentCommentsLoadedState(AssortmentCommentsModel assortmentCommentsModel)
      : super(assortmentCommentsModel: assortmentCommentsModel);
}

class AssortmentCommentsBloc
    extends Bloc<AssortmentCommentsEvent, AssortmentCommentsState> {
  AssortmentCommentsBloc() : super(AssortmentCommentsInitState());
  AssortmentCommentsModel _assortmentCommentsModel =
      AssortmentCommentsModel(data: []);
  int perPage = 3;
  String assortmentUuid = "";
  @override
  Stream<AssortmentCommentsState> mapEventToState(
      AssortmentCommentsEvent event) async* {
    //Show more
    if (event is AssortmentCommentsShowMoreEvent) {
      if (perPage == _assortmentCommentsModel.data.length) {
        yield AssortmentCommentsLoadingState(_assortmentCommentsModel);
        perPage += 10;

        try {
          _assortmentCommentsModel = await AssrtmentCommentsProvider()
              .getAssortmentCommentsResponse(
                  perPage: perPage, assortmentUuid: assortmentUuid);
          if (_assortmentCommentsModel.data.isNotEmpty) {
            yield AssortmentCommentsLoadedState(_assortmentCommentsModel);
          } else {
            yield AssortmentCommentsEmtyState();
          }
        } catch (e) {
          yield AssortmentCommentsErrorState();
        }
      }
    }
    //init load
    if (event is AssortmentCommentsLoadEvent) {
      assortmentUuid = event.assortmentUuid;
      perPage = 3;
      _assortmentCommentsModel = AssortmentCommentsModel(data: []);
      yield AssortmentCommentsLoadingState(_assortmentCommentsModel);
      try {
        _assortmentCommentsModel = await AssrtmentCommentsProvider()
            .getAssortmentCommentsResponse(
                perPage: perPage, assortmentUuid: assortmentUuid);
        if (_assortmentCommentsModel.data.isNotEmpty) {
          yield AssortmentCommentsLoadedState(_assortmentCommentsModel);
        } else {
          yield AssortmentCommentsEmtyState();
        }
      } catch (_) {
        yield AssortmentCommentsErrorState();
      }
    }
  }
}
