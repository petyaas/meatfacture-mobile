// ignore: implementation_imports
import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/bloc_files/hisory_oder_details_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/bloc_files/shopping_history_bloc.dart';
import 'package:smart/features/catalog/subcatalog_screen.dart';
import 'package:smart/main.dart';
import 'package:smart/models/order_list_model.dart';
import 'package:smart/pages/history_order_details_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

import '../bloc_files/order_type_bloc.dart';

class OrderListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HistoryOrdertDetailsBloc _historyOrdertDetailsBloc = BlocProvider.of<HistoryOrdertDetailsBloc>(context);
    SecondaryPageBloc _secondaryPageBloc = BlocProvider.of<SecondaryPageBloc>(context);
    BasketListBloc _basketListBloc = BlocProvider.of(context);
    OrderTypeBloc _orderTypeBloc = BlocProvider.of<OrderTypeBloc>(context);
    int i = 1;
    bool isinit = true;
    return BlocBuilder<ShoppingHistoryBloc, ShoppingHisoryState>(
      builder: (context, state) {
        if (state is ShoppingHistoryOrdersListLoadedState) {
          return Expanded(
            child: PaginationView<OrderListDataModel>(
                paginationViewType: PaginationViewType.listView,
                onError: (dynamic error) => Center(child: Text('errorText'.tr())),
                onEmpty: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/newEmptyList.svg',
                        width: widthRatio(size: 131, context: context),
                        height: heightRatio(size: 131, context: context),
                      ),
                      SizedBox(height: heightRatio(size: 30, context: context)),
                      Text(
                        'У вас еще нет истории заказов',
                        textAlign: TextAlign.center,
                        style: appLabelTextStyle(fontSize: heightRatio(size: 18, context: context), color: newBlack),
                      ),
                      SizedBox(height: heightRatio(size: 25, context: context)),
                      InkWell(
                        onTap: () => BlocProvider.of<SecondaryPageBloc>(context).add(CatalogEvent()),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          margin: const EdgeInsets.only(right: 20, left: 20),
                          width: widthRatio(size: 205, context: context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: newRedDark,
                          ),
                          child: Text(
                            'Перейти к покупкам',
                            style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                          ),
                        ),
                      ),
                      SizedBox(height: heightRatio(size: 15, context: context)),
                      InkWell(
                        onTap: () async {
                          BlocProvider.of<SecondaryPageBloc>(context).add(CatalogEvent());
                          navigatorKey.currentState?.push(
                            MaterialPageRoute(
                              builder: (context) => SubcatalogScreen(isSearchPage: false, isFavorite: true),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          margin: const EdgeInsets.only(right: 20, left: 20),
                          width: widthRatio(size: 205, context: context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: newBlack,
                          ),
                          child: Text(
                            'Перейти в избранное',
                            style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomLoader: SizedBox.shrink(),
                // initialLoader: Container(color: Colors.white, child: ShimmerHistoryCheckLoader()),
                initialLoader: SizedBox.shrink(),
                pageFetch: (currentListSize) async {
                  OrderListModel orderListModel = await OrderProvider().getOrderListResponse(i);
                  i += 1;
                  return orderListModel.data;
                },
                itemBuilder: (BuildContext context, OrderListDataModel orderListDataModel, int index) {
                  DateTime date = DateTime.parse(orderListDataModel.plannedDeliveryDatetimeFrom.replaceAll("+0300", "+0000"));
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Slidable(
                          actionExtentRatio: 1 / 7,
                          secondaryActions: [
                            IconSlideAction(
                              onTap: () async {
                                if (await BasketProvider().fillBasketFromORderResponse(orderListDataModel.uuid)) {
                                  _basketListBloc.add(BasketLoadEvent());
                                  _secondaryPageBloc.add(BasketPageLoadEvent());
                                  orderListDataModel.orderDeliveryTypeId == "delivery" ? _orderTypeBloc.add(OrderTypeDeliveryEvent()) : _orderTypeBloc.add(OrderTypePickupEvent());
                                }
                              },
                              closeOnTap: true,
                              iconWidget: Container(
                                margin: EdgeInsets.symmetric(vertical: heightRatio(size: 10, context: context), horizontal: widthRatio(size: 5, context: context)),
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  'assets/images/busketIcon.svg',
                                  color: newRedDark,
                                  width: widthRatio(size: 25, context: context),
                                  height: heightRatio(size: 25, context: context),
                                ),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 15, context: context)), border: Border.all(color: newRedDark, width: 1)),
                              ),
                            ),
                          ],
                          actionPane: SlidableDrawerActionPane(),
                          child: Builder(builder: (context) {
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              if (isinit) {
                                initSlidableAnimation(context: context);
                                isinit = false;
                              }
                            });
                            return InkWell(
                              onTap: () {
                                _historyOrdertDetailsBloc.add(HistoryOrderDetailsLoadEvent(orderId: orderListDataModel.uuid));
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryOrderDetailsPage(orderDate: orderListDataModel.number.toString())));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: heightRatio(size: 20, context: context)),
                                  Text(
                                    orderListDataModel.orderDeliveryTypeId == "pickup" ? 'Самовывоз' : 'Доставка',
                                    style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w400, color: colorBlack04),
                                  ),
                                  SizedBox(height: heightRatio(size: 5, context: context)),
                                  Text(
                                      orderListDataModel.orderDeliveryTypeId == "pickup"
                                          ? orderListDataModel.storeUserAddress
                                          : orderListDataModel.clientAddressData != null
                                              ? "${orderListDataModel.clientAddressData.address} ${orderListDataModel.clientAddressData.apartmentNumber ?? ""}"
                                              : '',
                                      style: appHeadersTextStyle(fontWeight: FontWeight.w400, fontSize: heightRatio(size: 18, context: context))),
                                  SizedBox(height: heightRatio(size: 5, context: context)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getOrderStatus(orderListDataModel: orderListDataModel),
                                            style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newRedDark),
                                          ),
                                          SizedBox(height: heightRatio(size: 5, context: context)),
                                          Text(
                                            "${date.toFormatedDate()}",
                                            style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w400, color: colorBlack04),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          orderListDataModel.bonusToCharge != null && orderListDataModel.bonusToCharge != 0
                                              ?
                                              // bonus container
                                              Container(
                                                  margin: EdgeInsets.only(right: widthRatio(size: 15, context: context)),
                                                  padding: EdgeInsets.all(widthRatio(size: 4, context: context)),
                                                  decoration: BoxDecoration(
                                                    color: whiteColor,
                                                    borderRadius: BorderRadius.circular(heightRatio(size: 8, context: context)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: colorBlack03,
                                                        spreadRadius: 0,
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/bonus_image.png",
                                                        height: heightRatio(size: 20, context: context),
                                                        width: widthRatio(size: 20, context: context),
                                                      ),
                                                      SizedBox(width: widthRatio(size: 5, context: context)),
                                                      Text(orderListDataModel.bonusToCharge.toString())
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(),
                                          RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: orderListDataModel.totalPrice.toStringAsFixed(0),
                                                  style: appLabelTextStyle(fontSize: heightRatio(size: 17, context: context), color: Colors.black),
                                                ),
                                                TextSpan(
                                                  text: " ₽",
                                                  style: appTextStyle(fontSize: heightRatio(size: 17, context: context), color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: heightRatio(size: 8, context: context)),
                                  Divider(),
                                ],
                              ),
                            );
                          })),
                    ],
                  );
                }),
          );
        }
        return Container(
          color: Colors.white,
        );
      },
    );
  }

  String getOrderStatus({OrderListDataModel orderListDataModel}) {
    switch (orderListDataModel.orderStatusId) {
      case "new":
        return "Оформлен";
        break;
      case "collecting":
        return "Обрабатывается";
        break;
      case "collected":
        if (orderListDataModel.orderDeliveryTypeId == "pickup") {
          return "Можно забрать";
        } else {
          return "Ваш заказ собран";
        }
        break;
      case "delivering":
        return "Доставляется";
        break;
      case "done":
        return "Выполнен";
        break;
      case "cancelled":
        return "Отменен";
        break;
      default:
        return "";
    }
  }

  void initSlidableAnimation({BuildContext context}) async {
    if (await prefs.getBool("hasOrderListIn") == null || await prefs.getBool("hasOrderListIn") == false) {
      prefs.setBool("hasOrderListIn", true);
      final slidable = Slidable.of(context);
      slidable.open(actionType: SlideActionType.secondary);
      Timer(Duration(milliseconds: 1500), () {
        if (slidable != null) {
          slidable.close();
        }
      });
    }
  }
}
