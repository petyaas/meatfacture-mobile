import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/shopping_history_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class SwitchButtonForShoppingHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ShoppingHistoryBloc _shoppingHistoryBloc = BlocProvider.of<ShoppingHistoryBloc>(context);
    return BlocBuilder<ShoppingHistoryBloc, ShoppingHisoryState>(builder: (context, state) {
      if (state is ShoppingHistoryCheckListLoadedState || state is ShoppingHistoryCheckLoadingState) {
        return Container(
          height: heightRatio(size: 40, context: context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context)),
            color: grey04,
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      _shoppingHistoryBloc.add(ShoppingHistoryOrdersListEvent());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: Text(
                        'ordersText'.tr(),
                        style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack),
                      ),
                    ),
                  )),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'checksText'.tr(),
                    style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    color: newRedDark,
                    borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context)),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      //orders selected
      if (state is ShoppingHistoryOrdersListLoadedState) {
        return Container(
          height: heightRatio(size: 40, context: context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context)),
            color: grey04,
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'ordersText'.tr(),
                      style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                      color: newRedDark,
                      borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context)),
                    ),
                  )),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    _shoppingHistoryBloc.add(ShoppingHistoryCheckListEvent());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: Text(
                      'checksText'.tr(),
                      style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        child: Text(''),
      );
    });
  }
}
