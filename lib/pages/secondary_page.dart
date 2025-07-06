import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class SecondaryPage extends StatelessWidget {
  final String upText;
  final Widget contentWidget;
  final bgColor;

  const SecondaryPage({@required this.upText, @required this.contentWidget, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: bgColor == null ? mainColor : bgColor,
        child: SafeArea(
            child: Container(
          alignment: Alignment.center,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(height: heightRatio(size: 12, context: context)),
            Container(
              margin: EdgeInsets.only(bottom: heightRatio(size: 20, context: context), left: widthRatio(size: 15, context: context)),
              child: Row(
                children: [
                  InkWell(
                    child: Container(
                      color: Colors.transparent,
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: heightRatio(size: 25, context: context),
                        color: whiteColor,
                      ),
                    ),
                    onTap: () {
                      // _bottomNavBloc.add(HomeEvent());
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: widthRatio(size: 10, context: context)),
                  Text(
                    upText,
                    style: appHeadersTextStyle(color: whiteColor, fontSize: heightRatio(size: 22, context: context), fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                  topRight: Radius.circular(heightRatio(size: 15, context: context)),
                ),
                child: Container(color: Colors.white, child: contentWidget),
              ),
            ),
          ]),
        )),
      ),
    );
  }
}
