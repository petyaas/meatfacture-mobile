//events

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/main.dart';
import 'package:smart/models/smart_contacts_model.dart';
import 'package:smart/models/socials_list_model.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/shared_keys.dart';

abstract class SmartContactsEvent {}

class SmartContactsLoadEvent extends SmartContactsEvent {}

// states

abstract class SmartContactsState {}

class SmartContactsInitState extends SmartContactsState {}

class SmartContactsLoadinState extends SmartContactsState {}

class SmartContactsErrorState extends SmartContactsState {}

class SmartContactsLoadedState extends SmartContactsState {
  final SmartContactsModel smartContactsModel;
  final SocialsListModel socialsListModel;
  final String appVersion;

  SmartContactsLoadedState({@required this.socialsListModel, @required this.smartContactsModel, @required this.appVersion});
}

//bloc class

class SmartContactsBloc extends Bloc<SmartContactsEvent, SmartContactsState> {
  SmartContactsBloc() : super(SmartContactsInitState());

  @override
  Stream<SmartContactsState> mapEventToState(SmartContactsEvent event) async* {
    yield SmartContactsLoadinState();
    try {
      SmartContactsModel _smartContactsModel = await SmartContactsProvider().getContactsResponse();
      prefs = await SharedPreferences.getInstance();
      await prefs.setString(SharedKeys.callCenterNumber, _smartContactsModel.data.callCenterNumber);
      log('попап отображать: ');
      await prefs.setBool(SharedKeys.isSocialNetworkFacebook, _smartContactsModel.data.socialNetworkFacebook == '1' ? true : false);
      log('попап отображать: ${prefs.getBool(SharedKeys.isSocialNetworkFacebook)}');

      SocialsListModel _socialsListModel = await SmartContactsProvider().getSocialsListResponse();
      await prefs.setString(SharedKeys.socialsListModelUrlWhatsapp, _socialsListModel.data[0].url);

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      yield SmartContactsLoadedState(appVersion: packageInfo.version, smartContactsModel: _smartContactsModel, socialsListModel: _socialsListModel);
    } catch (_) {
      yield SmartContactsErrorState();
    }
  }
}
