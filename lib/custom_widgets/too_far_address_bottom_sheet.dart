import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class TooFarAddressBottomSheet extends StatelessWidget {
  const TooFarAddressBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 22, context: context), vertical: heightRatio(size: 24, context: context)),
      height: heightRatio(size: 222, context: context),
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Text(
            "Адрес недоступен для доставки",
            textAlign: TextAlign.center,
            style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), color: newBlack),
          ),
          SizedBox(height: heightRatio(size: 20, context: context)),
          Text(
            "tooFarNotifTitleText".tr(),
            textAlign: TextAlign.center,
            style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
          ),
          SizedBox(height: heightRatio(size: 25, context: context)),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
              child: Text(
                "Понятно",
                style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
