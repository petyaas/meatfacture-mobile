import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AssortmentFiltersEvent {}

class AssortmentFiltersLoadEvent extends AssortmentFiltersEvent {
  String catalogUuid;
  bool isFavorite;
  bool isYellowTags;
  int currentPage;
  List<String> activeTagsList;
  String searchText;
  bool isBranded;

  AssortmentFiltersLoadEvent({
    this.catalogUuid,
    this.isFavorite,
    this.isYellowTags,
    this.currentPage,
    this.activeTagsList,
    this.searchText,
    this.isBranded,
  });
}

abstract class AssortmentFiltersEState {}

class AssortmentFiltersActiveState extends AssortmentFiltersEState {
  String catalogUuid;
  bool isFavorite;
  bool isYellowTags;
  int currentPage;
  List<String> activeTagsList;
  String searchText;
  bool isBranded;

  AssortmentFiltersActiveState({
    this.catalogUuid,
    this.isFavorite,
    this.isYellowTags,
    this.currentPage,
    this.activeTagsList,
    this.searchText,
    this.isBranded,
  });
}

class AssortmentFiltersDisableState extends AssortmentFiltersEState {}

class AssortmentFiltersBloc extends Bloc<AssortmentFiltersEvent, AssortmentFiltersEState> {
  AssortmentFiltersBloc() : super(AssortmentFiltersDisableState());

  @override
  Stream<AssortmentFiltersEState> mapEventToState(AssortmentFiltersEvent event) async* {
    if (event is AssortmentFiltersLoadEvent) {
      yield AssortmentFiltersActiveState(
        activeTagsList: event.activeTagsList,
        catalogUuid: event.catalogUuid,
        currentPage: event.currentPage,
        isFavorite: event.isFavorite,
        isYellowTags: event.isYellowTags,
        searchText: event.searchText,
        isBranded: event.isBranded,
      );
    }
  }
}
