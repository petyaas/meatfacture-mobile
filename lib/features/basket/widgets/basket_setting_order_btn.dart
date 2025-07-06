import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class BasketSettingOrderBtn extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;
  const BasketSettingOrderBtn({@required this.title, this.isActive = false, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightRatio(size: 42, context: context),
      child: ListTile(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        minVerticalPadding: 0,
        selectedColor: Colors.transparent,
        selectedTileColor: Colors.transparent,
        splashColor: Colors.transparent,
        tileColor: Colors.transparent,
        iconColor: Colors.transparent,
        onTap: onTap,
        title: Text(
          title,
          style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack),
        ),
        trailing: isActive == null
            ? const SizedBox(width: 16, child: Icon(Icons.arrow_forward_ios_rounded, size: 20, color: Colors.grey))
            : isActive == true
                ? Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.center,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      alignment: Alignment.center,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(color: newRedDark, borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  )
                : Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.center,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
        contentPadding: const EdgeInsets.all(0),
        dense: true,
      ),
    );
  }
}
