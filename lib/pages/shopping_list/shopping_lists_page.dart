import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:smart/custom_widgets/create_new_shopping_list_bottom_sheet.dart';
import 'package:smart/pages/shopping_list/shopping_lists_content_widget.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class ShoppinglistsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _openBottomSheetNewShoppingListCrater(BuildContext context) {
      showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(heightRatio(size: 25, context: context)),
            topRight: Radius.circular(heightRatio(size: 25, context: context)),
          ),
        ),
        builder: (BuildContext bc) {
          return Wrap(
            children: [NewShoppingListBottomSheetWidget()],
          );
        },
      );
    }

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
                SizedBox(height: heightRatio(size: 10, context: context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: widthRatio(size: 12, context: context)),
                        InkWell(
                          child: Container(
                              color: Colors.transparent,
                              child: Icon(Icons.arrow_back_ios_new_rounded, size: heightRatio(size: 20, context: context), color: whiteColor)),
                          onTap: () => Navigator.pop(context),
                        ),
                        SizedBox(width: widthRatio(size: 10, context: context)),
                        Text(
                          "ListsText".tr(),
                          style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => _openBottomSheetNewShoppingListCrater(context),
                          child: Container(
                            width: widthRatio(size: 36, context: context),
                            height: heightRatio(size: 36, context: context),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: white03),
                            child: Center(
                              child: Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: heightRatio(size: 25, context: context),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: widthRatio(size: 16, context: context)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: heightRatio(size: 12, context: context)),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                      topRight: Radius.circular(heightRatio(size: 15, context: context)),
                    ),
                    child: Container(
                      child: ShoppingListsContentWidget(),
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
