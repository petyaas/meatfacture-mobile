import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class AppAlert {
  static OverlayEntry _overlayEntry;

  static Future<void> show({
    BuildContext context,
    String message,
    String messageTap = '',
    int sec = 10,
    String svgName = 'newCustomAlert.svg',
    bool isPushToContactsWidget = false,
    Function() funcPushToContactsWidgetOnTap,
  }) async {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: 50,
        left: 18,
        right: 18,
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          shadowColor: newShadow,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [BoxShadow(color: grey04, offset: Offset(1, 2), blurRadius: 2, spreadRadius: 0)],
            ),
            padding: EdgeInsets.symmetric(vertical: heightRatio(size: 11, context: context), horizontal: widthRatio(size: 16, context: context)),
            child: Row(
              children: [
                Container(
                  height: heightRatio(size: 49, context: context),
                  width: widthRatio(size: 49, context: context),
                  padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 8, context: context), vertical: heightRatio(size: 12, context: context)),
                  decoration: BoxDecoration(
                    color: newRedDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/images/$svgName',
                    width: widthRatio(size: 50, context: context),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: widthRatio(size: 20, context: context)),
                Flexible(
                  child: isPushToContactsWidget
                      // ? Row(
                      //     children: [
                      //       Text(message, style: appLabelTextStyle(fontSize: heightRatio(size: 13, context: context), color: newBlackLight, height: 1.2)),
                      //       InkWell(
                      //         onTap: isPushToContactsWidgetOnTap,
                      //         child: Text(messageTap, style: appLabelTextStyle(fontSize: heightRatio(size: 13, context: context), color: newRedDark, height: 1.2)),
                      //       ),
                      //     ],
                      //   )
                      ? RichText(
                          text: TextSpan(
                            text: message,
                            style: appLabelTextStyle(fontSize: heightRatio(size: 13, context: context), color: newBlackLight, height: 1.2),
                            children: <TextSpan>[
                              TextSpan(
                                text: messageTap,
                                style: appLabelTextStyle(fontSize: heightRatio(size: 13, context: context), color: newRedDark, height: 1.2),
                                recognizer: TapGestureRecognizer()..onTap = funcPushToContactsWidgetOnTap,
                              ),
                            ],
                          ),
                        )
                      : Text(message, style: appLabelTextStyle(fontSize: heightRatio(size: 13, context: context), color: newBlackLight, height: 1.2)),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry);

    Future.delayed(Duration(seconds: sec), () {
      _overlayEntry.remove();
      _overlayEntry = null;
    });
  }
}
