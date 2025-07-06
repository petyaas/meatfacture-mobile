import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RedesSecondaryPage extends StatelessWidget {
  final String upText;
  final Widget contentWidget;
  final Color BGColor;

  const RedesSecondaryPage({@required this.upText, @required this.contentWidget, this.BGColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(color: BGColor ?? whiteColor),
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(top: heightRatio(size: 6, context: context), bottom: heightRatio(size: 20, context: context)),
            decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(heightRatio(size: 20, context: context)), bottomRight: Radius.circular(heightRatio(size: 20, context: context)))),
            width: screenWidth(context),
            child: SafeArea(
              bottom: false,
              child: Container(
                height: heightRatio(size: 30, context: context),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      left: 0,
                      child: InkWell(
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.only(bottom: heightRatio(size: 5, context: context), right: widthRatio(size: 25, context: context), left: widthRatio(size: 15, context: context)),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: heightRatio(size: 25, context: context),
                            color: blackColor,
                          ),
                        ),
                        onTap: () {
                          // _bottomNavBloc.add(HomeEvent());
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(width: widthRatio(size: 10, context: context)),
                    Text(
                      upText,
                      style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(color: whiteColor, child: contentWidget),
          ),
        ]),
      ),
    );
  }
}
