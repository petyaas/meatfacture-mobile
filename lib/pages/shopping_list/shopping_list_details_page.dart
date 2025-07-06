import 'package:flutter/material.dart';
import 'package:smart/pages/shopping_list/shopping_list_details_content_widget.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class ShoppingListDetailsPage extends StatelessWidget {
  final String shoppingListName;
  ShoppingListDetailsPage({@required this.shoppingListName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: newRedDark,
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: heightRatio(size: 18, context: context)),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: widthRatio(size: 12, context: context)),
                    InkWell(
                      child: Container(color: Colors.transparent, child: Icon(Icons.arrow_back_ios_new_rounded, size: heightRatio(size: 20, context: context), color: whiteColor)),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: widthRatio(size: 10, context: context)),
                    Text(shoppingListName, style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context))),
                  ],
                ),
                SizedBox(height: heightRatio(size: 26, context: context)),
                //main Content
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                      topRight: Radius.circular(heightRatio(size: 15, context: context)),
                    ),
                    child: Container(
                      child: ShoppingListDetailsContentWidget(),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
