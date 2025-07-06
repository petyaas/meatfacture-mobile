import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smart/features/profile/models/profile_model.dart';
import 'package:smart/repositories/profile_repository.dart';
import 'package:smart/services/services.dart';

abstract class ProfileEvent {}

class ProfileAsGuestEvent extends ProfileEvent {
  final String shopAddress;

  ProfileAsGuestEvent({this.shopAddress});
}

class ProfileLoadEvent extends ProfileEvent {}

class ProfileUpdateDataEvent extends ProfileEvent {
  final String uuid;
  final String phone;
  final String name;
  final String birthdayDate;
  final int consentToServiceNewsletter;
  final int consentToReceivePromotionalMailings;
  final String email;
  final String sex;
  final String selectedStoreUserUuid;
  final int isAgreeWithDiverseFoodPromo;

  ProfileUpdateDataEvent({this.isAgreeWithDiverseFoodPromo, this.birthdayDate, this.selectedStoreUserUuid, this.uuid, this.phone, this.name, this.consentToServiceNewsletter, this.consentToReceivePromotionalMailings, this.email, this.sex});
}

//states

abstract class ProfileState {}

class ProfileAsGuestState extends ProfileState {
  final String shopAddress;

  ProfileAsGuestState({@required this.shopAddress});
}

class ProfileEmptyState extends ProfileState {}

class ProfileErrorState extends ProfileState {}

class ProfileOldTokenState extends ProfileState {}

class ProfileBadTokenState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final ProfileModel profileModel;
  ProfileLoadedState({@required this.profileModel});
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileEmptyState());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileLoadEvent) {
      yield ProfileLoadingState();
      try {
        final ProfileModel profileModel = await ProfileRepository().getProfileFromRepository();
        if (profileModel.data == null) {
          yield ProfileBadTokenState();
        } else {
          PackageInfo _packageInfo = await PackageInfo.fromPlatform();
          String _versionAndPlatform;
          if (Platform.isAndroid) {
            _versionAndPlatform = "Android/${_packageInfo.version}";
            // print(_versionAndPlatform = "Android/${_packageInfo.version}");
          } else if (Platform.isIOS) {
            _versionAndPlatform = "IOS/${_packageInfo.version}";
          } else {
            _versionAndPlatform = "${_packageInfo.version}";
          }

          await ProfileUpdateDataProvider(phone: profileModel.data.phone, appVersion: _versionAndPlatform).getProfileChangeRsponse();
          yield ProfileLoadedState(profileModel: profileModel);
        }
      } catch (_) {
        if (_.toString().contains("401")) {
          yield ProfileOldTokenState();
        } else {
          yield ProfileErrorState();
        }
      }
    }

    if (event is ProfileAsGuestEvent) {
      yield ProfileAsGuestState(shopAddress: event.shopAddress != null ? event.shopAddress : await loadShopName());
    }

    if (event is ProfileUpdateDataEvent) {
      log('✅ Событие ProfileUpdateDataEvent дошло до ProfileBloc');
      PackageInfo _packageInfo = await PackageInfo.fromPlatform();
      String _versionAndPlatform;
      if (Platform.isAndroid) {
        _versionAndPlatform = "Android/${_packageInfo.version}";
      } else if (Platform.isIOS) {
        _versionAndPlatform = "IOS/${_packageInfo.version}";
      } else {
        _versionAndPlatform = "${_packageInfo.version}";
      }

      log('🌎 Отправляем запрос на обновление профиля с магазином: ${event.selectedStoreUserUuid}');

      final bool profileUpdatedCheck = await ProfileUpdateDataProvider(
              appVersion: _versionAndPlatform,
              selectedStoreUserUuid: event.selectedStoreUserUuid,
              sex: event.sex,
              isAgreeWithDiverseFoodPromo: event.isAgreeWithDiverseFoodPromo,
              phone: event.phone,
              email: event.email,
              name: event.name,
              birthdayDate: event.birthdayDate,
              consentToReceivePromotionalMailings: event.consentToReceivePromotionalMailings,
              consentToServiceNewsletter: event.consentToServiceNewsletter)
          .getProfileChangeRsponse();
      final ProfileModel profileModel = await ProfileRepository().getProfileFromRepository();
      yield ProfileLoadedState(profileModel: profileModel);
      if (profileUpdatedCheck) {
      } else {
        Fluttertoast.showToast(msg: 'errorText'.tr());
      }
    }
  }
}
