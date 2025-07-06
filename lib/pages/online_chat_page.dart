import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OnlineChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // WebViewController _webViewController;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: heightRatio(size: MediaQuery.of(context).viewInsets.bottom == 0 ? 0 : MediaQuery.of(context).viewInsets.bottom - 60, context: context)),
        child: WebView(
          initialUrl: "https://kprg.bitrix24.ru/online/mobile-chat",
          // onWebViewCreated: (controller) {
          // _webViewController = controller;
          // },
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
