// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/bloc_files/shopping_lists_bloc.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

// ignore: must_be_immutable
class UpdateShoppingListBottomSheetWidget extends StatefulWidget {
  final String shoppingListsUuid;
  final String shoppingListName;

  UpdateShoppingListBottomSheetWidget({@required this.shoppingListsUuid, @required this.shoppingListName});

  @override
  State<UpdateShoppingListBottomSheetWidget> createState() => _UpdateShoppingListBottomSheetWidgetState();
}

class _UpdateShoppingListBottomSheetWidgetState extends State<UpdateShoppingListBottomSheetWidget> {
  final TextEditingController renameShoppingListTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    renameShoppingListTextController.text = widget.shoppingListName;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    ShoppingListsBloc _shoppingListsBloc = BlocProvider.of<ShoppingListsBloc>(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: heightRatio(size: 25, context: context)),
          Text('Обновить список заказа'.tr(), style: appHeadersTextStyle(fontSize: heightRatio(size: 20, context: context), color: newBlack), textAlign: TextAlign.center),
          SizedBox(height: heightRatio(size: 15, context: context)),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: grey04, width: 1))),
            margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              style: appTextStyle(fontSize: heightRatio(size: 18, context: context)),
              controller: renameShoppingListTextController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Любимые продукты",
                hintStyle: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack03),
              ),
            ),
          ),
          SizedBox(height: heightRatio(size: 25, context: context)),
          // create shopping list
          InkWell(
            onTap: () async {
              Fluttertoast.showToast(msg: "Подождите...");

              if (await CreateNewShoppingListProvider().updateShoppingListResponse(shoppingListsUuid: widget.shoppingListsUuid, shoppingListName: renameShoppingListTextController.text)) {
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
                'Обновить список'.tr(),
                style: appLabelTextStyle(fontSize: heightRatio(size: 18, context: context), color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: heightRatio(size: 48, context: context)),
        ],
      ),
    );
  }
}
