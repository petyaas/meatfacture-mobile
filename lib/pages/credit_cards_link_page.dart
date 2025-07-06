// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/bloc_files/credit_cards_bloc.dart';
import 'package:smart/bloc_files/loyalty_cards_list_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
// import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/bloc_files/url_for_credit_card_bloc.dart';

import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CreditCardsLinkPage extends StatelessWidget {
  final String topText;

  const CreditCardsLinkPage({@required this.topText});
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    // SecondaryPageBloc _bottomNavBloc =
    //     BlocProvider.of<SecondaryPageBloc>(context);
    // ignore: close_sinks
    LoyaltyCardsListBloc _loyaltyCardsListBloc = BlocProvider.of<LoyaltyCardsListBloc>(context);
    // ignore: close_sinks
    ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
    // ignore: close_sinks
    CreditCardsListBloc _cardsListBloc = BlocProvider.of<CreditCardsListBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          body: Column(
        children: [
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: heightRatio(size: 15, context: context), horizontal: widthRatio(size: 20, context: context)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back_ios)))),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(topText, textAlign: TextAlign.left, style: appTextStyle(fontWeight: FontWeight.w600, fontSize: heightRatio(size: 14, context: context))),
                    ),
                  ),
                  Expanded(child: SizedBox())
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: BlocBuilder<UrlForCreditCardLinkBloc, UrlForCreditCardLinkState>(
                builder: (context, state) {
                  if (state is UrlForCreditCardLinkLoadingState) {
                    return CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                    );
                  }
                  if (state is UrlForCreditCardLinkLoadState) {
                    WebViewController _webViewController;
                    return WebView(
                      initialUrl: state.urlForCreditCardLinkModel.data.formUrl,
                      onWebViewCreated: (controller) {
                        _webViewController = controller;
                      },
                      javascriptMode: JavascriptMode.unrestricted,
                      onPageStarted: (progress) async {
                        if (await _webViewController.currentUrl().then((value) => value.contains("success"))) {
                          if (await CreditCardsProvider().setSuccessStatusOfLinkingCardResponse(orderId: state.urlForCreditCardLinkModel.data.orderId)) {
                            _cardsListBloc.add(CreditCardsListLoadEvent());
                            Navigator.pop(context);
                          }
                        }

                        if (await _webViewController.currentUrl().then((value) => value.contains("error"))) {
                          Fluttertoast.showToast(msg: "CardLinkErrorText".tr());
                          if (await CreditCardsProvider().setSErrorStatusOfLinkingCardResponse(orderId: state.urlForCreditCardLinkModel.data.orderId)) {
                            _loyaltyCardsListBloc.add(LoyaltyCardsListLoadEvent());
                            _profileBloc.add(ProfileLoadEvent());
                            _cardsListBloc.add(CreditCardsListLoadEvent());
                            // print("****" + await _webViewController.currentUrl());
                            Navigator.pop(context);
                          }
                        }
                      },
                    );
                  }

                  return (Text("errorText".tr()));
                },
              ),
            ),
          ),
        ],
      )),
    );
  }
}
