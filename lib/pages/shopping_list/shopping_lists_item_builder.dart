// ignore: implementation_imports
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/bloc_files/shopping_list_details_bloc.dart';
import 'package:smart/main.dart';
import 'package:smart/pages/shopping_list/widgets/update_shopping_list_bottom_sheet.dart';
import 'package:smart/models/shopping_lists_model.dart';
import 'package:smart/pages/shopping_list/shopping_list_details_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/utils/custom_cache_manager.dart';

class ShoppingListsItemBuilder extends StatefulWidget {
  final ShoppingListsModel shoppingListsModel;

  const ShoppingListsItemBuilder({@required this.shoppingListsModel});

  @override
  _ShoppingListsItemBuilderState createState() => _ShoppingListsItemBuilderState();
}

class _ShoppingListsItemBuilderState extends State<ShoppingListsItemBuilder> {
  SlidableController _shoppingListSlidableController = SlidableController();
  bool isinit;

  @override
  void initState() {
    isinit = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    BasketListBloc _basketListBloc = BlocProvider.of(context);
    // ignore: close_sinks
    ShoppingListDetailsBloc _shoppingListDetailsBloc = BlocProvider.of<ShoppingListDetailsBloc>(context);
    // // ignore: close_sinks
    // SecondaryPageBloc _bottomNavBloc =
    //     BlocProvider.of<SecondaryPageBloc>(context);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      // if (_shoppingListSlidableController.activeState != null) {}
      // _shoppingListSlidableController.activeState.context.on;
      // final slidable = Slidable.of(context);
      // slidable.open();
    });

    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: heightRatio(size: 40, context: context)),
      padding: EdgeInsets.symmetric(vertical: heightRatio(size: 20, context: context)),
      itemCount: widget.shoppingListsModel.data.length,
      itemBuilder: (BuildContext context, int index) {
        return Slidable(
          controller: _shoppingListSlidableController,
          actionExtentRatio: 1 / 9,
          secondaryActions: [
            IconSlideAction(
              onTap: () async {
                if (!await BasketProvider().addShoppingListToBasket(widget.shoppingListsModel.data[index].uuid)) {
                  Fluttertoast.showToast(msg: "errorText".tr());
                } else {
                  _basketListBloc.add(BasketLoadEvent());
                }
              },
              closeOnTap: true,
              iconWidget: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 5, context: context)),
                width: widthRatio(size: 32, context: context),
                child: SvgPicture.asset(
                  'assets/images/busketIcon.svg',
                  height: heightRatio(size: 20, context: context),
                  width: widthRatio(size: 20, context: context),
                  color: newGrey,
                ),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)), border: Border.all(color: newGrey, width: 1)),
              ),
            ),
            IconSlideAction(
              onTap: () {
                // _shoppingListDetailsBloc.add(ShoppingListDetailsLoadEvent(
                //     shoppingListUuid:
                //         widget.shoppingListsModel.data[index].uuid));
                // _bottomNavBloc.add(ShoppingListDetailsOpenEvent(
                //     shoppingListName:
                //         widget.shoppingListsModel.data[index].name));

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
                        UpdateShoppingListBottomSheetWidget(
                          shoppingListName: widget.shoppingListsModel.data[index].name,
                          shoppingListsUuid: widget.shoppingListsModel.data[index].uuid,
                        ),
                      ],
                    );
                  },
                );
              },
              closeOnTap: true,
              iconWidget: Container(
                width: widthRatio(size: 32, context: context),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/images/editIcon.svg',
                  width: widthRatio(size: 20, context: context),
                  height: heightRatio(size: 20, context: context),
                  color: newGrey,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(heightRatio(size: 3, context: context)),
                  border: Border.all(color: newGrey, width: 1),
                ),
              ),
            ),
            IconSlideAction(
              onTap: () async {
                Fluttertoast.showToast(msg: "Подождите...");
                if (await DeleteShoppingListProvider().getDeleteShoppingListResponse(shoppingListsUuid: widget.shoppingListsModel.data[index].uuid)) {
                  setState(() {
                    widget.shoppingListsModel.data.removeAt(index);
                  });
                } else {
                  await Fluttertoast.showToast(msg: 'errorText'.tr());
                }
              },
              iconWidget: Container(
                width: widthRatio(size: 32, context: context),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/images/newTrash.svg',
                  height: heightRatio(size: 20, context: context),
                  width: widthRatio(size: 20, context: context),
                  color: newGrey,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(heightRatio(size: 3, context: context)),
                  border: Border.all(color: newGrey, width: 1),
                ),
              ),
            )
          ],
          actionPane: SlidableDrawerActionPane(),
          child: Builder(builder: (context) {
            SchedulerBinding.instance.addPostFrameCallback(
              (_) {
                if (isinit) {
                  initSlidableAnimation(context: context);
                  isinit = false;
                }
              },
            );

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                //Go To  detail page
                _shoppingListDetailsBloc.add(ShoppingListDetailsLoadEvent(shoppingListUuid: widget.shoppingListsModel.data[index].uuid));
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ShoppingListDetailsPage(shoppingListName: widget.shoppingListsModel.data[index].name)));
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.shoppingListsModel.data[index].name,
                          style: appHeadersTextStyle(color: newBlack, fontSize: heightRatio(size: 17, context: context)),
                        ),
                        SizedBox(height: heightRatio(size: 13, context: context)),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: newRedDark),
                          height: heightRatio(size: 18, context: context),
                          width: widthRatio(size: 81, context: context),
                          child: Center(
                            child: Text(
                              widget.shoppingListsModel.data[index].assortments.length.toString() + " товаров",
                              style: TextStyle(color: whiteColor, fontSize: heightRatio(size: 10, context: context)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.shoppingListsModel.data[index].assortments.length > 0)
                      Container(
                        width: 130,
                        height: 48,
                        child: Stack(
                          children: [
                            if (widget.shoppingListsModel.data[index].assortments.length >= 3)
                              Positioned(
                                right: 70,
                                top: 0,
                                child: Container(
                                  width: widthRatio(size: 48, context: context),
                                  height: heightRatio(size: 48, context: context),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        widget.shoppingListsModel.data[index].assortments[2].images[0].thumbnails.the1000X1000,
                                        cacheManager: CustomCacheManager(),
                                      ),
                                      // image: NetworkImage(widget.shoppingListsModel.data[index].assortments[2].images[0].thumbnails.the1000X1000),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                              ),
                            if (widget.shoppingListsModel.data[index].assortments.length >= 2)
                              Positioned(
                                right: 35,
                                top: 0,
                                child: Container(
                                  width: widthRatio(size: 48, context: context),
                                  height: heightRatio(size: 48, context: context),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: widget.shoppingListsModel.data[index].assortments[1].images.isNotEmpty
                                          ? CachedNetworkImageProvider(
                                              widget.shoppingListsModel.data[index].assortments[1].images[0].thumbnails.the1000X1000,
                                              cacheManager: CustomCacheManager(),
                                            )
                                          : AssetImage("assets/images/notImage.png"),
                                      fit: widget.shoppingListsModel.data[index].assortments[1].images.isNotEmpty ? BoxFit.cover : BoxFit.contain,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                              ),
                            if (widget.shoppingListsModel.data[index].assortments.length >= 1)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: widthRatio(size: 48, context: context),
                                  height: heightRatio(size: 48, context: context),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        widget.shoppingListsModel.data[index].assortments[0].images[0].thumbnails.the1000X1000,
                                        cacheManager: CustomCacheManager(),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                              ),
                            if (widget.shoppingListsModel.data[index].assortments.length > 3)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: widthRatio(size: 48, context: context),
                                  height: heightRatio(size: 48, context: context),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '+${widget.shoppingListsModel.data[index].assortments.length - 3}',
                                      style: appHeadersTextStyle(color: whiteColor, fontSize: heightRatio(size: 16, context: context)),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  void initSlidableAnimation({BuildContext context}) async {
    if (await prefs.getBool("hasShoppingListIn") == null || await prefs.getBool("hasShoppingListIn") == false) {
      prefs.setBool("hasShoppingListIn", true);
      final slidable = Slidable.of(context);
      slidable.open(actionType: SlideActionType.secondary);
      Timer(Duration(milliseconds: 1500), () {
        slidable.close();
      });
    }
  }
}
