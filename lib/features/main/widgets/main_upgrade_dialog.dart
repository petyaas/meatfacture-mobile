// import 'package:flutter/material.dart';
// import 'package:smart/core/constants/source.dart';
// import 'package:smart/core/constants/text_styles.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:io';

// class MainUpgradeDialog extends StatelessWidget {
//   final String newVersion;
//   final String currentVersion;
//   const MainUpgradeDialog({Key key, this.newVersion, this.currentVersion}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         contentPadding: EdgeInsets.only(
//           top: heightRatio(size: 40, context: context),
//           left: widthRatio(size: 20, context: context),
//           right: widthRatio(size: 20, context: context),
//           bottom: heightRatio(size: 0, context: context),
//         ),
//         insetPadding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
//         content: SizedBox(
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(left: widthRatio(size: 35, context: context)),
//                 child: Image.asset(
//                   "assets/images/upgrade.png",
//                   fit: BoxFit.cover,
//                   width: widthRatio(size: 150, context: context),
//                 ),
//               ),
//               SizedBox(height: heightRatio(size: 30, context: context)),
//               Text(
//                 'Обновите приложение',
//                 style: appHeadersTextStyle(fontSize: heightRatio(size: 20, context: context), color: newBlack),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: heightRatio(size: 20, context: context)),
//               Text(
//                 'Доступна новая версия приложения “Мясофактура”',
//                 style: appLabelTextStyle(fontSize: heightRatio(size: 13, context: context), color: newBlack595F6E),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: heightRatio(size: 8, context: context)),
//               Text(
//                 'У Вас установлена версия: $currentVersion',
//                 style: appLabelTextStyle(fontSize: heightRatio(size: 13, context: context), color: newBlack595F6E),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: heightRatio(size: 8, context: context)),
//               Text(
//                 'Доступно для обновления: $newVersion',
//                 style: appLabelTextStyle(fontSize: heightRatio(size: 13, context: context), color: newBlack595F6E),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: heightRatio(size: 34, context: context)),
//               GestureDetector(
//                 onTap: () async {
//                   final androidUrl =
//                       Uri.parse('https://play.google.com/store/apps/details?id=com.meatfacture.androidapp&hl=ru&pli=1');
//                   final iosUrl = Uri.parse(
//                       'https://apps.apple.com/ru/app/%D0%BC%D1%8F%D1%81%D0%BE%D1%84%D0%B0%D0%BA%D1%82%D1%83%D1%80%D0%B0/id6460006989?l=uk');
//                   final url = Platform.isAndroid ? androidUrl : iosUrl;
//                   if (await canLaunchUrl(url)) {
//                     await launchUrl(url, mode: LaunchMode.externalApplication);
//                   } else {
//                     print('❌ Не удалось открыть ссылку: $url');
//                   }
//                 },
//                 child: Container(
//                   alignment: Alignment.center,
//                   height: heightRatio(size: 54, context: context),
//                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
//                   child: Text(
//                     "Обновить приложение сейчас",
//                     style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
//                   ),
//                 ),
//               ),
//               SizedBox(height: heightRatio(size: 8, context: context)),
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   alignment: Alignment.center,
//                   height: heightRatio(size: 54, context: context),
//                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
//                   child: Text(
//                     'Нет, спасибо',
//                     style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
//                   ),
//                 ),
//               ),
//               SizedBox(height: heightRatio(size: 30, context: context)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
