import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/product_in_shop_bloc.dart';
import 'package:smart/custom_widgets/product_in_shop_content_widget.dart';
import 'package:smart/custom_widgets/switch_for_shop_in_product_details.dart';
import 'package:smart/models/product_details_data_model.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class ProductInShopPage extends StatelessWidget {
  final List<ProductDetailsStoreListModel> storesListModel;
  final String assortmentUnitId;
  final TextEditingController shopsSearchTextController = TextEditingController();

  ProductInShopPage({@required this.storesListModel, @required this.assortmentUnitId});
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    ProductInShopBloc _productInShopBloc = BlocProvider.of<ProductInShopBloc>(context);
    // ShopsBloc _shopsBloc = BlocProvider.of<ShopsBloc>(context);
    // // ignore: close_sinks

    List<ProductDetailsStoreListModel> searchedStoresListModel = [];

    void _searchTextChange(String searchText) {
      if (searchText == null || searchText == "") {
        searchedStoresListModel = storesListModel;
      } else {
        for (int i = 0; i < storesListModel.length; i++) {
          if (storesListModel[i].address.contains(searchText)) {
            searchedStoresListModel = [];
            searchedStoresListModel.add(storesListModel[i]);
          }
        }
      }
      _productInShopBloc.add(ProductInShopAsListEvent(storesListModel: searchedStoresListModel, assortmentUnitId: assortmentUnitId));

      // if (_productInShopBloc.state is ProductInShopAsMapState) {
      //   _productInShopBloc.add(
      //       ProductInShopAsMapEvent(storesListModel: searchedStoresListModel));
      // } else if (_productInShopBloc.state is ProductInShopAsListState) {
      //   _productInShopBloc.add(
      //       ProductInShopAsListEvent(storesListModel: searchedStoresListModel));
      // }
    }

    return WillPopScope(
      onWillPop: () async {
        // _bottomNavBloc.add(ProductDetailsonSecondaryPageEvent());
        // return false;
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: mainColor),
          child: SafeArea(
            child: Container(
              alignment: Alignment.center,
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                    margin: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 5, context: context), right: widthRatio(size: 15, context: context), left: widthRatio(size: 15, context: context)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              GestureDetector(
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: heightRatio(size: 30, context: context),
                                ),
                                onTap: () {
                                  // _bottomNavBloc.add(
                                  //     ProductDetailsonSecondaryPageEvent());
                                  Navigator.pop(context);
                                  return false;
                                },
                              ),
                              SizedBox(width: widthRatio(size: 10, context: context)),
                              Text(
                                'availabilityinStoresText'.tr(),
                                style: appTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context), fontWeight: FontWeight.w600),
                              ),
                            ]),
                          ],
                        ),
                        //Search Field
                        SizedBox(height: heightRatio(size: 7, context: context)),
                        Container(
                          decoration: BoxDecoration(color: white04, borderRadius: BorderRadius.circular(heightRatio(size: 50, context: context))),
                          child: TextField(
                              onChanged: (value) {
                                _searchTextChange(shopsSearchTextController.text);
                              },
                              controller: shopsSearchTextController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: white04,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    shopsSearchTextController.text = "";
                                    _searchTextChange("");
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                                border: InputBorder.none,
                                hintText: 'findInStoreText'.tr(),
                                hintStyle: appTextStyle(color: white04, fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w400),
                              )),
                        ),
                        SizedBox(height: heightRatio(size: 15, context: context)),

                        SizedBox(height: heightRatio(size: 15, context: context)),

                        SwitchForShopInProductDetails(),
                        SizedBox(height: heightRatio(size: 20, context: context))
                      ],
                    )),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                      topRight: Radius.circular(heightRatio(size: 15, context: context)),
                    ),
                    child: Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: ProductInShopContent(),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
