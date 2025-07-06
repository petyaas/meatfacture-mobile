import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/custom_widgets/redesigned_widgets/accaunt_will_be_deleted_content.dart';
import 'package:smart/main.dart';
import 'package:smart/models/delete_profile_model.dart';
import 'package:smart/services/services.dart';
import '../pages/secondary_page.dart';

//Events
abstract class DeleteProfileEvent {}

class DeleteProfileStartEvent extends DeleteProfileEvent {
  final BuildContext context;

  DeleteProfileStartEvent(this.context);
}

//states

abstract class DeleteProfileState {
  final DeleteProfileModel deleteProfileModel;

  DeleteProfileState(this.deleteProfileModel);
}

class DeleteProfileInitState extends DeleteProfileState {
  DeleteProfileInitState() : super(DeleteProfileModel());
}

class DeleteProfileLoadingState extends DeleteProfileState {
  DeleteProfileLoadingState(DeleteProfileModel deleteProfileModel) : super(deleteProfileModel);
}

class DeleteProfileLoadedState extends DeleteProfileState {
  DeleteProfileLoadedState(DeleteProfileModel deleteProfileModel) : super(deleteProfileModel);
}

class DeleteProfileErrorState extends DeleteProfileState {
  DeleteProfileErrorState() : super(DeleteProfileModel());
}

//bloc

class DeleteProfileBloc extends Bloc<DeleteProfileEvent, DeleteProfileState> {
  DeleteProfileBloc() : super(DeleteProfileInitState());

  DeleteProfileModel _deleteProfileModel;

  @override
  Stream<DeleteProfileState> mapEventToState(DeleteProfileEvent event) async* {
    if (event is DeleteProfileStartEvent) {
      yield DeleteProfileLoadingState(_deleteProfileModel);
      try {
        _deleteProfileModel = await ProfileProvider().deleteProfileResponse();
        yield DeleteProfileLoadedState(_deleteProfileModel);
        Navigator.pop(event.context);
        _showProfileDeleteDescription(_deleteProfileModel.data.markDeletedAt, event.context);
      } catch (e) {
        yield DeleteProfileErrorState();
      }
    }
  }

  _showProfileDeleteDescription(String markDeletedAt, BuildContext cont) async {
    prefs = await SharedPreferences.getInstance();
    String number = await prefs.getString(SharedKeys.callCenterNumber);
    Navigator.push(
      cont,
      MaterialPageRoute(
        builder: (context) => SecondaryPage(
          bgColor: newRedDark,
          upText: "accauntWillBeDeleted".tr(),
          contentWidget: AccauntWillBeDeletedContent(callCenterNumber: number),
        ),
      ),
    );
  }
}
