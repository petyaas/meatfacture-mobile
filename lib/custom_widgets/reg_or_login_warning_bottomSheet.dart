// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/basic_page_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RegOrLoginWarningBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    BasicPageBloc _basicPageBloc = BlocProvider.of<BasicPageBloc>(context);
    // ignore: close_sinks
    AuthPageBloc _regBloc = BlocProvider.of<AuthPageBloc>(context);
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(heightRatio(size: 15, context: context)),
        topRight: Radius.circular(heightRatio(size: 15, context: context)),
      ),
      child: Container(
          padding: EdgeInsets.all(widthRatio(size: 20, context: context)),
          height: heightRatio(size: 200, context: context),
          decoration: BoxDecoration(color: whiteColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "theActionIsAvailableOnlyToRegisteredUsersText".tr(),
                style: appTextStyle(color: blackColor, fontSize: heightRatio(size: 20, context: context), fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              ),
              InkWell(
                onTap: () async {
                  await ProfilePage.destroySharedPref();
                  _regBloc.add(LoginEvent());
                  _basicPageBloc.add(BasicPagesEvent.regPageEvent);
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "registerNowText".tr(),
                    style: appTextStyle(color: whiteColor, fontSize: heightRatio(size: 18, context: context), fontWeight: FontWeight.w400),
                  ),
                  height: heightRatio(size: 60, context: context),
                  decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context))),
                ),
              )
            ],
          )),
    );
  }
}
