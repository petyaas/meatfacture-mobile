import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc_files/smart_contacts_bloc.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/theme/app_button.dart';
import 'package:smart/theme/app_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

// Поддержка
class ContactsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SmartContactsBloc _contactsBloc = BlocProvider.of(context);
    return BlocBuilder<SmartContactsBloc, SmartContactsState>(builder: (context, state) {
      if (state is SmartContactsLoadinState) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(newRedDark),
          ),
        );
      }
      if (state is SmartContactsErrorState) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 14, bottom: 14, left: 15, right: 15),
                decoration: BoxDecoration(color: colorBlack03, shape: BoxShape.circle),
                child: SvgPicture.asset(
                  'assets/images/netErrorIcon.svg',
                  color: Colors.white,
                  height: heightRatio(size: 28, context: context),
                ),
              ),
              SizedBox(height: heightRatio(size: 14, context: context)),
              Text(
                "errorText".tr(),
                style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: heightRatio(size: 10, context: context)),
              InkWell(
                onTap: () => _contactsBloc.add(SmartContactsLoadEvent()),
                child: Container(
                  color: Colors.transparent,
                  child: Text(
                    "tryAgainText".tr(),
                    style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      if (state is SmartContactsLoadedState) {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
          children: [
            // state.socialsListModel.data.isNotEmpty ? SocialsListContent(socialsListModel: state.socialsListModel) : SizedBox(),
            SizedBox(
              height: heightRatio(size: 80, context: context),
              child: Center(
                child: Text(
                  'Если вы столкнулись с проблемой или у вас возникли\nвопросы, пожалуйста свяжитесь с поддержкой',
                  style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // InkWell(
            //   onTap: () async {
            //     await Clipboard.setData(ClipboardData(text: state.smartContactsModel.data.callCenterNumber));
            //     AppAlert.show(
            //       context: context,
            //       message: "Телефон был успешно скопирован",
            //       sec: 2,
            //     );
            //   },
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       SvgPicture.asset(
            //         'assets/images/newPhone.svg',
            //         width: widthRatio(size: 21, context: context),
            //         height: heightRatio(size: 21, context: context),
            //       ),
            //       SizedBox(width: widthRatio(size: 17, context: context)),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             state.smartContactsModel.data.callCenterNumber,
            //             style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
            //             textAlign: TextAlign.center,
            //           ),
            //           SizedBox(height: heightRatio(size: 2, context: context)),
            //           Text(
            //             'Каждый день с 10 до 20',
            //             style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newGrey),
            //             textAlign: TextAlign.center,
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            // Divider(color: newGreyECECEC, height: 40),
            InkWell(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: state.smartContactsModel.data.email));
                AppAlert.show(
                  context: context,
                  message: "Эл. почта была успешно скопирована",
                  sec: 2,
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/newMail.svg',
                    width: widthRatio(size: 17, context: context),
                    height: heightRatio(size: 17, context: context),
                  ),
                  SizedBox(width: widthRatio(size: 16, context: context)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.smartContactsModel.data.email,
                        style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: heightRatio(size: 2, context: context)),
                      Text(
                        'По вопросам сотрудничества',
                        style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newGrey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: newGreyECECEC, height: 40),
            if (state.smartContactsModel.data.socialMessengerTelegram != null)
              state.smartContactsModel.data.callCenterNumber.isNotEmpty
                  ? AppButton(
                      text: 'Связаться по Telegram',
                      onPress: () {
                        log(state.smartContactsModel.data.socialMessengerTelegram);
                        launchUrl(Uri.parse(state.smartContactsModel.data.socialMessengerTelegram), mode: LaunchMode.externalApplication);
                      },
                      hasMargin: false,
                      colorButton: newBlue,
                    )
                  : null,
            if (state.smartContactsModel.data.socialMessengerTelegram != null) SizedBox(height: heightRatio(size: 12, context: context)),
            if (state.socialsListModel.data[0].url != null)
              state.socialsListModel.data.isNotEmpty && state.socialsListModel.data[0].url.isNotEmpty
                  ? AppButton(
                      text: 'Связаться в Whatsapp',
                      onPress: () {
                        log(state.socialsListModel.data[0].url);
                        launchUrl(Uri.parse(state.socialsListModel.data[0].url), mode: LaunchMode.externalApplication);
                      },
                      hasMargin: false,
                      colorButton: newGreen27B568,
                    )
                  : null,
            Divider(color: newGreyECECEC, height: 46),
            Text(
              'Крестьянско-фермерское хозяйство Кондохов Анзор Адамович\nИНН 090101676089',
              style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newGrey979797, height: 1.3),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: heightRatio(size: 16, context: context)),
            Text(
              'ОГРНИП 312091715800012 от 06.06.2012',
              style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newGrey979797, height: 1.3),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: heightRatio(size: 16, context: context)),
            Text(
              'Юридический адрес: 127322, Город Москва, вн.тер.г. муниципальный округ Бутырский, ул Фонвизина, д. 18, кв. 525',
              style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newGrey979797, height: 1.3),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: heightRatio(size: 16, context: context)),
            Text(
              'Фактический адрес: 355 042, г. Ставрополь,\nул. Доваторцев, д. 65, к. А',
              style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newGrey979797, height: 1.3),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: heightRatio(size: 30, context: context)),
            InkWell(
              onTap: () => launchUrl(Uri.parse('$apiHead/information.pdf'), mode: LaunchMode.externalApplication),
              child: Text('Условия возврата и обмена', style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: newRedDark)),
            ),
            SizedBox(height: heightRatio(size: 15, context: context)),
            InkWell(
              onTap: () => launchUrl(Uri.parse('$apiHead/policy.pdf'), mode: LaunchMode.externalApplication),
              child: Text('Порядок обработки персональный данных', style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: newRedDark)),
            ),
            SizedBox(height: heightRatio(size: 30, context: context)),
            Center(
              child: Text(
                'Версия приложения ${state.appVersion}',
                style: appLabelTextStyle(color: newBlack, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      }

      return SizedBox();
    });
  }
}
