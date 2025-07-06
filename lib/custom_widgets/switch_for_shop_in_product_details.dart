// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/product_in_shop_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class SwitchForShopInProductDetails extends StatelessWidget {
  // const SwitchForShopInProductDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    ProductInShopBloc _productInShopBloc = BlocProvider.of<ProductInShopBloc>(context);
    return BlocBuilder<ProductInShopBloc, ProductInShopState>(
      builder: (context, state) {
        if (state is ProductInShopAsListState) {
          return ClipRRect(
              borderRadius: BorderRadius.circular(heightRatio(size: 50, context: context)),
              child: Container(
                  decoration: BoxDecoration(color: white04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          _productInShopBloc.add(ProductInShopAsMapEvent(assortmentUnitId: state.assortmentUnitId, storesListModel: state.storesListModel));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          padding: EdgeInsets.all(widthRatio(size: 8, context: context)),
                          child: Text(
                            'onMapText'.tr(),
                            textAlign: TextAlign.center,
                            style: appTextStyle(color: white04),
                          ),
                        ),
                      )),
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(widthRatio(size: 8, context: context)),
                        decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(-3, 4), blurRadius: 10, spreadRadius: 0)], borderRadius: BorderRadius.circular(heightRatio(size: 50, context: context)), color: Colors.white),
                        child: Text(
                          'asListText'.tr(),
                          textAlign: TextAlign.center,
                        ),
                      )),
                    ],
                  )));
        }

        if (state is ProductInShopAsMapState) {
          return ClipRRect(
              borderRadius: BorderRadius.circular(heightRatio(size: 50, context: context)),
              child: Container(
                  decoration: BoxDecoration(color: white04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(widthRatio(size: 8, context: context)),
                        decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(-3, 4), blurRadius: 10, spreadRadius: 0)], borderRadius: BorderRadius.circular(heightRatio(size: 50, context: context)), color: Colors.white),
                        child: Text(
                          'onMapText'.tr(),
                          textAlign: TextAlign.center,
                        ),
                      )),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          _productInShopBloc.add(ProductInShopAsListEvent(assortmentUnitId: state.assortmentUnitId, storesListModel: state.storesListModel));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          padding: EdgeInsets.all(widthRatio(size: 8, context: context)),
                          child: Text(
                            'asListText'.tr(),
                            textAlign: TextAlign.center,
                            style: appTextStyle(color: white04),
                          ),
                        ),
                      )),
                    ],
                  )));
        }
        return SizedBox();
      },
    );
  }
}
