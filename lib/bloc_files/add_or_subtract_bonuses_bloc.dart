//events
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AddOrSubtractBonusesEvent {}

class AddBonusesEvent extends AddOrSubtractBonusesEvent {}

class SubtractBonusesEvent extends AddOrSubtractBonusesEvent {}

//states

abstract class AddOrSubtractBonusesState {}

class AddBonusesState extends AddOrSubtractBonusesState {}

class SubtractBonusesState extends AddOrSubtractBonusesState {}

//BLoC class

class AddOrSubtractBonusesBloc
    extends Bloc<AddOrSubtractBonusesEvent, AddOrSubtractBonusesState> {
  AddOrSubtractBonusesBloc() : super(AddBonusesState());

  @override
  Stream<AddOrSubtractBonusesState> mapEventToState(
      AddOrSubtractBonusesEvent event) async* {
    if (event is AddBonusesEvent) {
      yield AddBonusesState();
    }
    if (event is SubtractBonusesEvent) {
      yield SubtractBonusesState();
    }
  }
}
