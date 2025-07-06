import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/tags_model.dart';
import 'package:smart/repositories/tags_repository.dart';

//Events
abstract class TagsEvent {}

class TagsloadEvent extends TagsEvent {}

//States

abstract class TagsState {}

class TagsLoadingState extends TagsState {}

class TagsErrorState extends TagsState {}

class TagsEmptyState extends TagsState {}

class TagsLoadedState extends TagsState {
  final TagsModel tagsModel;
  TagsLoadedState({this.tagsModel});
}

class TagsBloc extends Bloc<TagsEvent, TagsState> {
  TagsBloc() : super(TagsLoadingState());

  @override
  Stream<TagsState> mapEventToState(TagsEvent event) async* {
    if (event is TagsloadEvent) {
      yield TagsLoadingState();
      try {
        final TagsModel _loadedTags = await TagsRepository().getAllTags();
        if (_loadedTags.data.isNotEmpty) {
          yield TagsLoadedState(tagsModel: _loadedTags);
        } else {
          yield TagsEmptyState();
        }
      } catch (_) {
        yield TagsErrorState();
      }
    }
  }
}
