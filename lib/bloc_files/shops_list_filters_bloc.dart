import 'package:flutter_bloc/flutter_bloc.dart';

//events
abstract class ShopsListFiltersEvent {}

class ShopsListFiltersLoadEvent extends ShopsListFiltersEvent {
  final bool hasParking;
  final bool hasReadyMeals;
  final bool hasAtms;
  final bool isfavorite;
  final bool isOpenNow;
  // final String searchText;

  ShopsListFiltersLoadEvent(
      {this.hasParking,
      this.hasReadyMeals,
      this.hasAtms,
      this.isfavorite,
      this.isOpenNow});
}

//states

abstract class ShopsListFiltersEState {}

class ShopsListFiltersActiveState extends ShopsListFiltersEState {
  bool hasParking;
  bool hasReadyMeals;
  bool hasAtms;
  bool isfavorite;
  bool isOpenNow;
  // final String searchText;

  ShopsListFiltersActiveState(
      {this.hasParking,
      this.hasReadyMeals,
      this.hasAtms,
      this.isfavorite,
      this.isOpenNow});
}

class ShopsListFiltersDisableState extends ShopsListFiltersEState {}

class ShopsListFiltersBloc
    extends Bloc<ShopsListFiltersEvent, ShopsListFiltersEState> {
  ShopsListFiltersBloc() : super(ShopsListFiltersDisableState());

  @override
  Stream<ShopsListFiltersEState> mapEventToState(
      ShopsListFiltersEvent event) async* {
    if (event is ShopsListFiltersLoadEvent) {
      yield ShopsListFiltersActiveState(
          hasAtms: event.hasAtms,
          hasParking: event.hasParking,
          hasReadyMeals: event.hasReadyMeals,
          isOpenNow: event.isOpenNow,
          isfavorite: event.isfavorite);
    }
  }
}
