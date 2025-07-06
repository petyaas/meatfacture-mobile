import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/home/widgets/home_popup_beta_version_dialog.dart';

class HomePopupBetaVersion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: HomePopupBetaVersionDialog(),
          ),
        );
      },
      child: Container(
        height: heightRatio(size: 102, context: context),
        padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
        decoration: BoxDecoration(color: newBlack, borderRadius: BorderRadius.circular(15)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Бета-версия приложения',
                  style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: Colors.white),
                ),
                SizedBox(height: heightRatio(size: 10, context: context)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Просим обратить ваше внимание',
                      style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: Colors.white),
                    ),
                    SizedBox(width: widthRatio(size: 6, context: context)),
                    Icon(Icons.chevron_right_rounded, color: Colors.white, size: 19),
                  ],
                ),
              ],
            ),
            Flexible(
              child: SvgPicture.asset(
                'assets/images/popupBetaVersion.svg',
                height: heightRatio(size: 74, context: context),
                width: widthRatio(size: 83, context: context),
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
