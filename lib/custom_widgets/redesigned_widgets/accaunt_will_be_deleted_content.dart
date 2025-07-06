import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/theme/app_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AccauntWillBeDeletedContent extends StatelessWidget {
  final String callCenterNumber;

  const AccauntWillBeDeletedContent({Key key, @required this.callCenterNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context), vertical: heightRatio(size: 30, context: context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Вы подали заявку на удаление профиля',
            style: appHeadersTextStyle(fontSize: heightRatio(size: 17, context: context)),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: heightRatio(size: 16, context: context)),
          Text(
            "deleteProfileDescription2".tr(),
            style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack),
          ),
          SizedBox(height: heightRatio(size: 16, context: context)),
          AppButton(
            text: callCenterNumber,
            onPress: () => launchUrl(Uri.parse(("tel:$callCenterNumber"))),
            hasMargin: false,
          ),
        ],
      ),
    );
  }
}
