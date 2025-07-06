import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function() onPress;
  final Color colorButton;
  final Color colorText;
  final bool hasMargin;
  const AppButton({
    Key key,
    @required this.text,
    @required this.onPress,
    this.colorText = Colors.white,
    this.colorButton = newRedDark,
    this.hasMargin = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
        margin: hasMargin ? EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)) : EdgeInsets.zero,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: colorButton),
        child: Text(
          text ?? '',
          style: appLabelTextStyle(color: colorText, fontSize: heightRatio(size: 16, context: context)),
        ),
      ),
    );
  }
}
