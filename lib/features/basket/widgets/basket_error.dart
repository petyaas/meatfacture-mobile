import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class BasketError extends StatelessWidget {
  final BasketListBloc basketListBloc;
  final BoxDecoration Function(BuildContext) decorationForContent;

  const BasketError({Key key, @required this.basketListBloc, @required this.decorationForContent}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: decorationForContent(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(heightRatio(size: 15, context: context)),
              decoration: BoxDecoration(color: colorBlack03, shape: BoxShape.circle),
              child: SvgPicture.asset(
                'assets/images/netErrorIcon.svg',
                color: Colors.white,
                height: heightRatio(size: 30, context: context),
              ),
            ),
            SizedBox(height: heightRatio(size: 15, context: context)),
            Text("errorText".tr(), style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06)),
            SizedBox(height: heightRatio(size: 10, context: context)),
            InkWell(
              onTap: () {
                basketListBloc.add(BasketLoadEvent());
              },
              child: Container(
                color: Colors.transparent,
                child: Text("tryAgainText".tr(), style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: newRedDark)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
