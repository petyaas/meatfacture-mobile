import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:smart/bloc_files/product_details_bloc.dart';
import 'package:smart/bloc_files/shopping_lists_bloc.dart';
import 'package:smart/custom_widgets/create_new_shopping_list_bottom_sheet.dart';
import 'package:smart/models/product_details_data_model.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class AddProductToShoppingListBottomSheetwidget extends StatefulWidget {
  final String assortmentUuid;
  final ProductDetailsBloc productDetailsBloc;
  final String assortmentPrice;
  final List<ProductDetailsUserShoppingList> addedShoppingList;
  final double priceWithDiscount;
  // final List<ProductDetailsUserShoppingList>
  AddProductToShoppingListBottomSheetwidget(
      {@required this.addedShoppingList,
      @required this.assortmentUuid,
      @required this.assortmentPrice,
      @required this.priceWithDiscount,
      @required this.productDetailsBloc});

  @override
  _AddProductToShoppingListBottomSheetwidgetState createState() => _AddProductToShoppingListBottomSheetwidgetState();
}

class _AddProductToShoppingListBottomSheetwidgetState extends State<AddProductToShoppingListBottomSheetwidget> {
  int selectedRadioButton;
  String shoppingListsUuid;
  int quantity;

  @override
  void initState() {
    super.initState();
    quantity = 1;
  }

  @override
  Widget build(BuildContext context) {
    void _openBottomSheetNewShoppingListCrater(BuildContext context) {
      showModalBottomSheet<dynamic>(
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
              children: [
                NewShoppingListBottomSheetWidget(),
              ],
            );
          });
    }

    //Добавить продукт в список
    Future<bool> addShoppingListToAdded(String uuid) async {
      return await AddProductToShopingListProvider()
          .getAddProducttoShoppingListRespone(shoppingListsUuid: uuid, assortmentUuid: widget.assortmentUuid, quantity: quantity);
    }

    // удалить продукт из списка
    Future<bool> deleteShoppingListToAdded(String uuid) async {
      return await DeleteProductToShopingListProvider().getDeleteProducttoShoppingListRespone(shoppingListsUuid: uuid, assortmentUuid: widget.assortmentUuid);
    }

    //
    bool isContain(String uuid) {
      for (var i = 0; i < widget.addedShoppingList.length; i++) {
        if (widget.addedShoppingList[i].uuid == uuid) {
          return true;
        }
      }
      return false;
    }

    // ignore: close_sinks

    return BlocBuilder<ShoppingListsBloc, ShoppingListsState>(
      builder: (context, state) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenHeight(context) * 0.7),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(heightRatio(size: 15, context: context)),
              topRight: Radius.circular(heightRatio(size: 15, context: context)),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context), vertical: heightRatio(size: 15, context: context)),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'addToListText'.tr(),
                    style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: heightRatio(size: 10, context: context)),
                  state is ShoppingListsLoadedState
                      ? state.shoppingListsModel.data.isNotEmpty
                          ? Flexible(
                              child: Container(
                                child: ListView.builder(
                                  itemCount: state.shoppingListsModel.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            state.shoppingListsModel.data[index].name,
                                            style: appTextStyle(fontSize: heightRatio(size: 17, context: context), fontWeight: FontWeight.w400),
                                          ),
                                          Checkbox(
                                              onChanged: (value) async {
                                                setState(() {
                                                  if (value) {
                                                    widget.addedShoppingList.add(ProductDetailsUserShoppingList(
                                                        name: state.shoppingListsModel.data[index].name, uuid: state.shoppingListsModel.data[index].uuid));
                                                  } else {
                                                    for (var i = 0; i < widget.addedShoppingList.length; i++) {
                                                      if (widget.addedShoppingList[i].uuid == state.shoppingListsModel.data[index].uuid) {
                                                        widget.addedShoppingList.removeAt(i);
                                                      }
                                                    }
                                                  }
                                                });
                                                if (value) {
                                                  if (await addShoppingListToAdded(state.shoppingListsModel.data[index].uuid)) {
                                                    widget.productDetailsBloc.add(ProductDetailsLoadEvent(
                                                      uuid: widget.assortmentUuid,
                                                    ));
                                                  }
                                                } else {
                                                  if (await deleteShoppingListToAdded(state.shoppingListsModel.data[index].uuid)) {
                                                    widget.productDetailsBloc.add(ProductDetailsLoadEvent(
                                                      uuid: widget.assortmentUuid,
                                                    ));
                                                  }
                                                }
                                              },
                                              activeColor: mainColor,
                                              value: isContain(state.shoppingListsModel.data[index].uuid))
                                          //   groupValue: widget.addedShoppingList
                                          //           .contains(
                                          //               ProductDetailsUserShoppingList(
                                          //                   name: state
                                          //                       .shoppingListsModel
                                          //                       .data[index]
                                          //                       .name,
                                          //                   uuid: state
                                          //                       .shoppingListsModel
                                          //                       .data[index]
                                          //                       .uuid))
                                          //       ? index
                                          //       : 0,
                                          //   onChanged: (val) {
                                          //     setState(() {
                                          //       selectedRadioButton = index;
                                          //       shoppingListsUuid = state
                                          //           .shoppingListsModel
                                          //           .data[index]
                                          //           .uuid;
                                          //     });
                                          //   },
                                          //   activeColor: mainFocusColor,
                                          // )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Expanded(
                              child: Container(
                                child: Center(
                                  child: Text(
                                    'emptyText'.tr(),
                                    style: appLabelTextStyle(
                                      fontSize: heightRatio(size: 18, context: context),
                                    ),
                                  ),
                                ),
                              ),
                            )
                      : state is ShoppingListsLoadingState
                          ? Expanded(
                              child: Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                                ),
                              ),
                            ))
                          : state is ShoppingListsEmptyState
                              ? Expanded(
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        'На данный момент у\nВас ни одного списка',
                                        style: appHeadersTextStyle(fontSize: heightRatio(size: 20, context: context)),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        'errorText'.tr(),
                                        style: appLabelTextStyle(height: heightRatio(size: 18, context: context)),
                                      ),
                                    ),
                                  ),
                                ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'createNewList'.tr(),
                          style: appLabelTextStyle(
                              fontSize: heightRatio(size: heightRatio(size: 18, context: context), context: context), fontWeight: FontWeight.w400),
                        ),
                        GestureDetector(
                          onTap: () => _openBottomSheetNewShoppingListCrater(context),
                          child: Container(
                            padding: EdgeInsets.all(widthRatio(size: 12, context: context)),
                            decoration: BoxDecoration(color: colorBlack03, shape: BoxShape.circle),
                            child: Icon(Icons.add, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                  // TextButton(
                  //     onPressed: () async {
                  //       Fluttertoast.showToast(msg: 'Подождите...');
                  //       if (shoppingListsUuid != null &&
                  //           await AddProductToShopingListProvider()
                  //               .getAddProducttoShoppingListRespone(
                  //                   shoppingListsUuid: shoppingListsUuid,
                  //                   assortmentUuid: widget.assortmentUuid,
                  //                   quantity: quantity)) {
                  //         Navigator.pop(context);
                  //       } else {
                  //         if (shoppingListsUuid == null) {
                  //           Fluttertoast.showToast(msg: 'Выберите Список');
                  //         } else {
                  //           Fluttertoast.showToast(
                  //               msg: 'Ошибка добавлния продукта');
                  //         }
                  //       }
                  //     },
                  //     child: Container(
                  //         padding: const EdgeInsets.symmetric(vertical: 15),
                  //         alignment: Alignment.center,
                  //         child: Text(
                  //           "Добавить",
                  //           style: GoogleFonts.raleway(
                  //               color: Colors.white, fontSize: 18),
                  //         ),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(15),
                  //             gradient: LinearGradient(
                  //                 colors: [
                  //                   firstColorButtonsOrangeGradient,
                  //                   secondColorButtonsOrangeGradient
                  //                 ],
                  //                 begin: Alignment.centerLeft,
                  //                 end: Alignment.centerRight))))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
