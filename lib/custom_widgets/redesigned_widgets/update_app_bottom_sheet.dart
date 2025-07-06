import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppBottomSheet extends StatelessWidget {
  const UpdateAppBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: heightRatio(size: 20, context: context), left: widthRatio(size: 16, context: context), right: widthRatio(size: 16, context: context), bottom: heightRatio(size: 20, context: context)),
      decoration: BoxDecoration(
        color: whiteColor,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "update_app".tr(),
          style: appTextStyle(fontWeight: FontWeight.w800, fontSize: heightRatio(size: 20, context: context)),
        ),
        SizedBox(height: heightRatio(size: 20, context: context)),
        Center(
          child: Image.asset(
            "assets/images/update_app_image.png",
            height: heightRatio(size: 120, context: context),
            width: widthRatio(size: 120, context: context),
          ),
        ),
        SizedBox(height: heightRatio(size: 20, context: context)),
        Text("we_added_handy_features_and_fixed_bugs".tr(), style: appTextStyle(fontWeight: FontWeight.w400, fontSize: heightRatio(size: 14, context: context))),
        SizedBox(height: heightRatio(size: 16, context: context)),
        InkWell(
          onTap: () => updateApp(context),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: heightRatio(size: 16, context: context)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widthRatio(size: 12, context: context)),
              color: mainColor,
            ),
            child: Text("to_update_app".tr(), style: appTextStyle(fontWeight: FontWeight.w700, color: whiteColor, fontSize: heightRatio(size: 14, context: context))),
          ),
        ),
        SizedBox(height: heightRatio(size: 16, context: context)),
        Center(
          child: Text("we_will_redirect_you_to_the_app_store".tr(), textAlign: TextAlign.center, style: appTextStyle(fontWeight: FontWeight.w400, color: colorBlack04, fontSize: heightRatio(size: 12, context: context))),
        ),
      ]),
    );
  }

  updateApp(BuildContext context) {
    if (Platform.isIOS) {
      launchUrl(Uri.parse(appStoreAppUrl));
    } else {
      launchUrl(Uri.parse(playMarketAppUrl));
    }
  }
}
