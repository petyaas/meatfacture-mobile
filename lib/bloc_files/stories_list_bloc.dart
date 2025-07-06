//event
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/stories_list_model.dart';
import 'package:smart/services/services.dart';

abstract class StoriesListEvent {}

class StoriesListLoadEvent extends StoriesListEvent {}

//states
abstract class StoriesListState {}

class StoriesListLoadingState extends StoriesListState {}

class StoriesListErrorState extends StoriesListState {}

class StoriesListInitState extends StoriesListState {}

class StoriesListLoadedState extends StoriesListState {
  final StoriesListModel storiesListModel;
  StoriesListLoadedState({@required this.storiesListModel});
}

//BLoC class
class StoriesListBloc extends Bloc<StoriesListEvent, StoriesListState> {
  StoriesListBloc() : super(StoriesListInitState());

  @override
  Stream<StoriesListState> mapEventToState(StoriesListEvent event) async* {
    yield StoriesListLoadingState();
    try {
      StoriesListModel _storiesListModel = await StoriesProvider().storiesResponse();

      if (_storiesListModel.data.isEmpty) {
        yield StoriesListInitState();
      } else {
        yield StoriesListLoadedState(storiesListModel: _storiesListModel);
      }
    } catch (e) {
      yield StoriesListErrorState();
    }
  }
}
