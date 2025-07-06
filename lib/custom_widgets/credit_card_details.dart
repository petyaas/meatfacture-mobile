// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/bloc_files/credit_cards_bloc.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class CreditCardDetailsBottomSheet extends StatelessWidget {
  final String paySystem;
  final String mask;
  final String cardUuid;

  const CreditCardDetailsBottomSheet({@required this.paySystem, @required this.mask, @required this.cardUuid});

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    CreditCardsListBloc _cardsListBloc = BlocProvider.of<CreditCardsListBloc>(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(heightRatio(size: 15, context: context)),
          topRight: Radius.circular(heightRatio(size: 15, context: context)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: heightRatio(size: 20, context: context), horizontal: widthRatio(size: 15, context: context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("deleteCreditCardText".tr(), style: appTextStyle(fontSize: heightRatio(size: 20, context: context), fontWeight: FontWeight.w500)),
            SizedBox(height: heightRatio(size: 25, context: context)),
            Text("cardNumberText".tr(), style: appTextStyle(fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w500, color: colorBlack04)),
            SizedBox(height: heightRatio(size: 10, context: context)),
            Text(mask, style: appTextStyle(fontSize: heightRatio(size: 18, context: context), fontWeight: FontWeight.w400)),
            SizedBox(height: heightRatio(size: 5, context: context)),
            Divider(),
            SizedBox(height: heightRatio(size: 35, context: context)),
            InkWell(
              onTap: () async {
                Navigator.pop(context);

                if (await CreditCardsProvider().deleteCreditCardResponse(cardUuid: cardUuid)) {
                  _cardsListBloc.add(CreditCardsListLoadEvent());
                } else {
                  // Navigator.pop(context);
                  Fluttertoast.showToast(msg: "errorText".tr());
                }
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: heightRatio(size: 15, context: context)),
                  margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 10, context: context)),
                  decoration: BoxDecoration(border: Border.all(color: orangeTextColor, width: widthRatio(size: 1.5, context: context)), color: Colors.white, borderRadius: BorderRadius.circular(heightRatio(size: 15, context: context))),
                  alignment: Alignment.center,
                  child: Text('deleteText'.tr())),
            ),
          ],
        ),
      ),
    );
  }
}
