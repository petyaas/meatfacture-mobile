import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class BasketAddress extends StatelessWidget {
  final String labelText;
  final TextEditingController textController;

  const BasketAddress({Key key, @required this.labelText, @required this.textController}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: grey04, width: widthRatio(size: 1, context: context)))),
      width: widthRatio(size: 64, context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlackLight),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: heightRatio(size: 30, context: context),
            child: TextField(
              textAlign: TextAlign.center,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              controller: textController,
              maxLines: 1,
              style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
            ),
          ),
        ],
      ),
    );
  }
}
