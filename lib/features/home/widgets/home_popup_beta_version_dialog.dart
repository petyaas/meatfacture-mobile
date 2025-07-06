import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/main.dart';

class HomePopupBetaVersionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.only(
        top: heightRatio(size: 40, context: context),
        left: widthRatio(size: 22, context: context),
        right: widthRatio(size: 22, context: context),
        bottom: heightRatio(size: 0, context: context),
      ),
      title: Text(
        'Бета-версия приложения',
        textAlign: TextAlign.center,
        style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), color: newBlack),
      ),
      content: SizedBox(
        height: heightRatio(size: 400, context: context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/popupBetaVersionDark.svg',
              width: widthRatio(size: 170, context: context),
              fit: BoxFit.contain,
            ),
            SizedBox(height: 24),
            Text(
              'Уважаемые пользователи,\nПросим обратить ваше внимание, что наше приложение "Мясофактура" находится в бета-версии, которая будет дорабатываться и улучшаться.\n\nЕсли вы обнаружите какие-либо ошибки, пожалуйста, отнеситесь к этому с пониманием. Вы можете пользоваться всем функционалом приложения и совершать заказы',
              textAlign: TextAlign.center,
              style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack595F6E),
            ),
            SizedBox(height: 24),
            InkWell(
              onTap: () async {
                await prefs.setBool(SharedKeys.popupBetaVersion, true);
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                child: Text(
                  'Понятно, перейти к покупкам',
                  style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 14, context: context)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
