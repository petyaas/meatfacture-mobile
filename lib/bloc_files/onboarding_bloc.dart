//events

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/onboarding_list_Model.dart';
import 'package:smart/services/services.dart';

abstract class OnboardingEvent {}

class OnboardingLoadEvent extends OnboardingEvent {
  final BuildContext context;

  OnboardingLoadEvent({@required this.context});
}

//state
abstract class OnboardingState {}

class OnboardingInitstate extends OnboardingState {}

class OnboardingLoadingstate extends OnboardingState {}

class OnboardingErrorstate extends OnboardingState {}

class OnboardingLoadedstate extends OnboardingState {
  final OnboardingListModel onboardingListModel;

  OnboardingLoadedstate({@required this.onboardingListModel});
}

//bloc class
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingInitstate());

  @override
  Stream<OnboardingState> mapEventToState(OnboardingEvent event) async* {
    if (event is OnboardingLoadEvent) {
      yield OnboardingLoadingstate();
      try {
        OnboardingListModel _onboardingListModel = await OnboardingListProvider().getOnboradingListResponse();
        // for (var i = 0; i < _onboardingListModel.data.length; i++) {
        //   await UtilsForOnboard.cachImage(
        //       event.context, _onboardingListModel.data[i].logoFilePath);
        // }
        // await Future.wait(_onboardingListModel.data.map((e) => UtilsForOnboard.cachImage(event.context, e.logoFilePath)).toList());
        if (_onboardingListModel.data.isEmpty) {
          yield OnboardingErrorstate();
        } else {
          yield OnboardingLoadedstate(onboardingListModel: _onboardingListModel);
        }
      } catch (error) {
        yield OnboardingErrorstate();
      }
    }
  }
}
