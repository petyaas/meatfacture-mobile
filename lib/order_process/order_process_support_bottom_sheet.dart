import 'package:flutter/material.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/main.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderProcessSupportBottomSheet extends StatelessWidget {
  final int orderNumber;
  final String storePhone;
  final String courierPhone;

  const OrderProcessSupportBottomSheet({Key key, @required this.orderNumber, @required this.storePhone, @required this.courierPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context), vertical: heightRatio(size: 25, context: context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Поддержка', style: appHeadersTextStyle(fontSize: 18, color: newBlack)),
              SizedBox(height: heightRatio(size: 15, context: context)),
              Text('Номер вашего заказа: $orderNumber', style: appHeadersTextStyle(fontSize: 14, color: newBlack)),
              SizedBox(height: heightRatio(size: 20, context: context)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 30, context: context)),
                child: Text('При обращении в поддержку не забудьте сообщить номер вашего заказа', style: appLabelTextStyle(fontSize: 14, color: newBlack, height: 1.2), textAlign: TextAlign.center),
              ),
              SizedBox(height: heightRatio(size: 24, context: context)),
              // InkWell(
              //   onTap: () async {
              //     final Uri launchUri = Uri(scheme: 'tel', path: storePhone);
              //     await launchUrl(launchUri);
              //   },
              //   child: Container(
              //     alignment: Alignment.center,
              //     padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
              //     width: MediaQuery.of(context).size.width,
              //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
              //     child: Text(
              //       'Связаться по телефону',
              //       style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
              //     ),
              //   ),
              // ),
              // SizedBox(height: heightRatio(size: 10, context: context)),
              InkWell(
                onTap: () async {
                  String whatsapp = await prefs.getString(SharedKeys.socialsListModelUrlWhatsapp);
                  String text = 'Здравствуйте, номер моего заказа $orderNumber';
                  final whatsappUrl = Uri.parse("whatsapp://send?phone=$whatsapp&text=$text");
                  await launchUrl(whatsappUrl);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newGreen27B568),
                  child: Text(
                    'Связаться в Whatsapp',
                    style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                  ),
                ),
              ),
              SizedBox(height: heightRatio(size: 10, context: context)),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
                  child: Text(
                    'Вернуться к заказу',
                    style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                  ),
                ),
              ),
              SizedBox(height: heightRatio(size: 10, context: context)),
            ],
          ),
        ),
      ],
    );
  }
}
