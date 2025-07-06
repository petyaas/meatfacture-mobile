import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/bloc_files/shopping_lists_bloc.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class NewShoppingListBottomSheetWidget extends StatefulWidget {
  @override
  State<NewShoppingListBottomSheetWidget> createState() => _NewShoppingListBottomSheetWidgetState();
}

class _NewShoppingListBottomSheetWidgetState extends State<NewShoppingListBottomSheetWidget> {
  final TextEditingController shoppingListTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ShoppingListsBloc _shoppingListsBloc = BlocProvider.of<ShoppingListsBloc>(context);
    double bottomSizedBox = MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : heightRatio(size: 48, context: context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: heightRatio(size: 25, context: context)),
          Text('Наименование списка', style: appHeadersTextStyle(fontSize: heightRatio(size: 20, context: context), color: newBlack), textAlign: TextAlign.center),
          SizedBox(height: heightRatio(size: 15, context: context)),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: grey04, width: 1))),
            margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              style: appTextStyle(fontSize: heightRatio(size: 18, context: context)),
              controller: shoppingListTextController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Любимые продукты",
                hintStyle: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack03),
              ),
            ),
          ),
          SizedBox(height: heightRatio(size: 25, context: context)),
          InkWell(
            onTap: () async {
              Fluttertoast.showToast(msg: "Подождите...");
              if (await CreateNewShoppingListProvider().getCreateShoppingListResponse(shoppingListName: shoppingListTextController.text)) {
                _shoppingListsBloc.add(ShoppingListsLoadEvent());
                Navigator.pop(context);
              } else {
                await Fluttertoast.showToast(msg: 'errorCreatingList'.tr());
              }
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
              margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
              child: Text(
                'createListText'.tr(),
                style: appLabelTextStyle(fontSize: heightRatio(size: 18, context: context), color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: bottomSizedBox),
        ],
      ),
    );
  }
}
