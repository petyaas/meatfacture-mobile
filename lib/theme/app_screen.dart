import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class AppScreen extends StatelessWidget {
  final String title;
  final double titleSize;
  final Widget content;
  final bool titleCenter;
  const AppScreen({@required this.title, @required this.content, this.titleCenter = false, this.titleSize = 22});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: newRedDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: heightRatio(size: 15, context: context)),
            Row(
              mainAxisAlignment: titleCenter ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12.5),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: heightRatio(size: 25, context: context),
                      color: whiteColor,
                    ),
                  ),
                ),
                Text(
                  title,
                  style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: titleSize, context: context)),
                  textAlign: TextAlign.left,
                ),
                titleCenter ? SizedBox(width: widthRatio(size: 60, context: context)) : SizedBox.shrink(),
              ],
            ),
            SizedBox(height: heightRatio(size: 20, context: context)),
            Expanded(
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                    topRight: Radius.circular(heightRatio(size: 15, context: context)),
                  ),
                ),
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
