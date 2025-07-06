import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/bloc_files/shopping_lists_bloc.dart';
import 'package:smart/bloc_files/smart_contacts_bloc.dart';
import 'package:smart/features/home/widgets/home_icon_bottom_sheet.dart';
import 'package:smart/pages/shopping_list/shopping_lists_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class BasketHeader extends StatelessWidget {
  final BasketListBloc basketListBloc;
  final ShoppingListsBloc shoppingListsBloc;
  final SmartContactsBloc smartContactsBloc;
  final BasketState basketState;
  final bool isBasket;
  final bool isPayment;
  const BasketHeader({
    Key key,
    @required this.basketListBloc,
    @required this.shoppingListsBloc,
    @required this.smartContactsBloc,
    @required this.basketState,
    this.isBasket = true,
    this.isPayment = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Корзина шапка
    return Container(
      margin: EdgeInsets.only(bottom: heightRatio(size: 12, context: context), left: widthRatio(size: 15, context: context)),
      child: Column(
        children: [
          SizedBox(height: heightRatio(size: isPayment ? 17 : 10, context: context)),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isBasket
                          ? 'basketText'.tr()
                          : isPayment
                              ? "Оплата"
                              : "Оформление",
                      style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                    ),
                    !isPayment
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              isBasket
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ShoppinglistsPage(),
                                            ));
                                        this.shoppingListsBloc.add(ShoppingListsLoadEvent());
                                      },
                                      child: Container(
                                          width: widthRatio(size: 36, context: context),
                                          height: heightRatio(size: 36, context: context),
                                          padding: EdgeInsets.all(widthRatio(size: 9, context: context)),
                                          decoration: BoxDecoration(shape: BoxShape.circle, color: white03),
                                          child: SvgPicture.asset(
                                            "assets/images/listIcon.svg",
                                            color: whiteColor,
                                          )),
                                    )
                                  : SizedBox(),
                              SizedBox(width: widthRatio(size: 10, context: context)),
                              InkWell(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  this.smartContactsBloc.add(SmartContactsLoadEvent());
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
                                            HomeIconBottomSheet(),
                                          ],
                                        );
                                      });
                                },
                                child: Container(
                                    width: widthRatio(size: 36, context: context),
                                    height: heightRatio(size: 36, context: context),
                                    padding: EdgeInsets.all(widthRatio(size: 9, context: context)),
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: white03),
                                    child: SvgPicture.asset(
                                      'assets/images/newInfo.svg',
                                      color: whiteColor,
                                      height: heightRatio(size: 20, context: context),
                                      width: widthRatio(size: 20, context: context),
                                    )),
                              ),
                              SizedBox(width: widthRatio(size: isBasket ? 10 : 0, context: context)),
                              isBasket
                                  ? InkWell(
                                      onTap: () async {
                                        if (basketState is BasketEmptyState) {
                                          null;
                                        } else {
                                          FocusScope.of(context).unfocus();
                                          showModalBottomSheet<dynamic>(
                                            isScrollControlled: false,
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
                                                  Container(
                                                    alignment: Alignment.topLeft,
                                                    child: SingleChildScrollView(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                          left: widthRatio(size: 16, context: context),
                                                          right: widthRatio(size: 16, context: context),
                                                          top: heightRatio(size: 20, context: context),
                                                          bottom: heightRatio(size: 30, context: context),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'Вы уверены, что хотите \nочистить корзину?',
                                                                  style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context)),
                                                                ),
                                                                InkWell(
                                                                  onTap: () => Navigator.pop(context),
                                                                  child: SvgPicture.asset("assets/images/newTrash.svg",
                                                                      height: heightRatio(size: 24, context: context)),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(height: heightRatio(size: 20, context: context)),
                                                            Divider(
                                                                height: heightRatio(size: heightRatio(size: 0, context: context), context: context),
                                                                thickness: 1,
                                                                color: grey04),
                                                            SizedBox(height: heightRatio(size: 16, context: context)),
                                                            InkWell(
                                                              onTap: () async {
                                                                await BasketProvider().removeAllBasket() == true
                                                                    ? this.basketListBloc.add(BasketLoadEvent())
                                                                    : Fluttertoast.showToast(msg: "errorText".tr());
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                padding: EdgeInsets.only(
                                                                    top: heightRatio(size: 15, context: context),
                                                                    bottom: heightRatio(size: 18, context: context)),
                                                                width: MediaQuery.of(context).size.width,
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                                                                child: Text("Да",
                                                                    style: appLabelTextStyle(
                                                                        color: Colors.white, fontSize: heightRatio(size: 16, context: context))),
                                                              ),
                                                            ),
                                                            SizedBox(height: heightRatio(size: 8, context: context)),
                                                            InkWell(
                                                              onTap: () => Navigator.pop(context),
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                padding: EdgeInsets.only(
                                                                    top: heightRatio(size: 15, context: context),
                                                                    bottom: heightRatio(size: 18, context: context)),
                                                                width: MediaQuery.of(context).size.width,
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
                                                                child: Text("Нет",
                                                                    style: appLabelTextStyle(
                                                                        color: Colors.white, fontSize: heightRatio(size: 16, context: context))),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                        ;
                                      },
                                      child: Container(
                                        width: widthRatio(size: 36, context: context),
                                        height: heightRatio(size: 36, context: context),
                                        padding: EdgeInsets.all(widthRatio(size: 9, context: context)),
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: white03),
                                        child: SvgPicture.asset(
                                          'assets/images/newTrash.svg',
                                          height: heightRatio(size: 25, context: context),
                                          width: widthRatio(size: 25, context: context),
                                          color: whiteColor,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(width: widthRatio(size: 15, context: context)),
                            ],
                          )
                        : SizedBox()
                  ],
                ),
              )
            ],
          ),
          if (isPayment) SizedBox(height: heightRatio(size: 5, context: context)),
        ],
      ),
    );
  }
}
