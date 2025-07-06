import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/bloc_files/credit_cards_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

Widget openUrlPage({@required String url, @required CreditCardsListBloc cardsListBloc, @required BuildContext context, @required String orderId}) {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  return Scaffold(
    body: SafeArea(
      bottom: false,
      child: Stack(
        children: [
          WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: url,
              onWebViewCreated: (WebViewController webcontroller) {
                _controller.complete(webcontroller);
              },
              navigationDelegate: (navigation) {
                print('blocking navigation to $navigation}');
                if (navigation.url.contains("sberpay")) {
                  _launchUrl(navigation.url);
                  return NavigationDecision.prevent;
                }
                if (navigation.url.contains("success")) {
                  Navigator.pop(context);
                } else if (navigation.url.contains("error")) {
                  Fluttertoast.showToast(msg: "errorText".tr());
                  Navigator.pop(context);
                }
                print('allowing navigation to $navigation');
                return NavigationDecision.navigate;
              },
              onPageStarted: (url) async {}),
          Container(
            margin: EdgeInsets.only(top: heightRatio(size: 10, context: context), left: widthRatio(size: 15, context: context)),
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: shadowGrayColor006,
                              spreadRadius: 5,
                              offset: Offset(0, 0),
                              blurRadius: 20,
                            )
                          ],
                          shape: BoxShape.circle),
                      height: heightRatio(size: 40, context: context),
                      width: widthRatio(size: 40, context: context),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "assets/images/arrow_back.svg",
                        color: blackColor,
                        height: heightRatio(size: 15, context: context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: widthRatio(size: 15, context: context)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

void _launchUrl(String url) async {
  var _url = Uri.parse(url);
  // try {
  //   launchUrl(_url, mode: LaunchMode.externalApplication);
  // } catch (e) {
  //   Fluttertoast.showToast(msg: "SberBankIsNotInstalled".tr());
  // }

  if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
    Fluttertoast.showToast(msg: "SberBankIsNotInstalled".tr());
  }

  // if (await canla(
  //   url,
  // )) {
  //   await launchUrlString(url, mode: LaunchMode.externalApplication);
  // } else {
  //   Fluttertoast.showToast(msg: "SberBankIsNotInstalled".tr());
  // }
}
