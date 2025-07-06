// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/main.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

//вроде бы вообще нигде не вызывается
class StoreWillBeChangetBottomSheet extends StatelessWidget {
  final String newStoreUuuid;
  final String newStoreAddress;
  final String newStoreLogo;

  const StoreWillBeChangetBottomSheet({@required this.newStoreUuuid, @required this.newStoreAddress, @required this.newStoreLogo});
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
    // ignore: close_sinks
    BasketListBloc _basketListBloc = BlocProvider.of(context);
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(heightRatio(size: 15, context: context)),
          topRight: Radius.circular(heightRatio(size: 15, context: context)),
        ),
        color: Colors.white,
      ),
      height: heightRatio(size: 240, context: context),
      width: screenWidth(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Адрес магазина будет изменен",
            textAlign: TextAlign.center,
            style: appTextStyle(fontSize: heightRatio(size: 24, context: context), fontWeight: FontWeight.w500),
          ),
          Text(
            "storeAddresswiilBeChangedTitleText".tr(),
            textAlign: TextAlign.center,
            style: appTextStyle(fontSize: heightRatio(size: 18, context: context), fontWeight: FontWeight.w500),
          ),
          InkWell(
            onTap: () async {
              await prefs.setString(SharedKeys.shopUuid, newStoreUuuid);
              await prefs.setString(SharedKeys.shopAddress, newStoreAddress);
              await prefs.setString(SharedKeys.shopLogo, newStoreLogo);
              _profileBloc.add(ProfileUpdateDataEvent(selectedStoreUserUuid: newStoreUuuid));

              _basketListBloc.add(BasketLoadEvent());
              _profileBloc.add(ProfileLoadEvent());
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: heightRatio(size: 15, context: context)),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)), color: mainColor),
              child: Text(
                'ContinueText'.tr(),
                style: appTextStyle(fontWeight: FontWeight.w500, fontSize: heightRatio(size: 18, context: context), color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
