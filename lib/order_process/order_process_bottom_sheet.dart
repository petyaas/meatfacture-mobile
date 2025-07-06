import 'package:flutter/material.dart';
import 'package:smart/order_process/order_bns_delivery.dart';
import 'package:smart/order_process/order_bns_pickup.dart';
import 'package:smart/order_process/order_process_item.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/order_process/order_process_item_model.dart';

void orderProcessBottomSheet(BuildContext context, OrderProcessItemModel orderProcessItemModel) {
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
      print('заказ номер: ${orderProcessItemModel.number}, uuid: ${orderProcessItemModel.uuid}');
      String timeFrom = orderProcessItemModel.plannedDeliveryDatetimeFrom.split(' ')[1].substring(0, 5);
      String timeTo = orderProcessItemModel.plannedDeliveryDatetimeTo.split(' ')[1].substring(0, 5);
      String headline;
      if (orderProcessItemModel.orderDeliveryTypeId == "pickup" &&
          (orderProcessItemModel.orderStatusId == 'new' || orderProcessItemModel.orderStatusId == 'collecting')) {
        headline = 'Ваш заказ будет собран в $timeFrom - $timeTo';
      } else if (orderProcessItemModel.orderDeliveryTypeId == "pickup" && orderProcessItemModel.orderStatusId == 'collected') {
        headline = 'Заказ готов к выдаче по адресу';
      } else if (orderProcessItemModel.orderDeliveryTypeId == "pickup" && orderProcessItemModel.orderStatusId == 'done') {
        headline = 'Заказ был вручен';
      } else if (orderProcessItemModel.orderDeliveryTypeId == "delivery" && orderProcessItemModel.orderStatusId != 'done') {
        headline = 'Заказ приедет в $timeFrom - $timeTo';
      } else {
        headline = 'Информация о заказе';
      }

      return Wrap(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widthRatio(size: 16, context: context),
              vertical: heightRatio(size: 25, context: context),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  headline,
                  style: appHeadersTextStyle(fontSize: 18, color: newBlack),
                ),
                if (orderProcessItemModel.orderDeliveryTypeId == "pickup") SizedBox(height: heightRatio(size: 15, context: context)),
                if (orderProcessItemModel.orderDeliveryTypeId == "pickup")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.network(
                      //               orderProcessListModel.data[0].,
                      //               fit: BoxFit.scaleDown,
                      //               width: widthRatio(size: 51, context: context),
                      //               height: heightRatio(size: 42, context: context),
                      //             ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            orderProcessItemModel.storeUserFullName,
                            style: appLabelTextStyle(fontSize: 12, color: newBlack),
                          ),
                          Text(
                            orderProcessItemModel.storeUserAddress,
                            style: appLabelTextStyle(fontSize: 12, color: newBlack),
                          ),
                        ],
                      ),
                    ],
                  ),
                SizedBox(height: heightRatio(size: 20, context: context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OrderProcessItem(title: 'Заказ оформлен', icon: 'assets/images/newOrder1.svg', isActive: orderProcessItemModel.orderStatusId == 'new'),
                    OrderProcessItem(
                        title: 'Заказ собирается', icon: 'assets/images/newOrder2.svg', isActive: orderProcessItemModel.orderStatusId == 'collecting'),
                    orderProcessItemModel.orderDeliveryTypeId == "pickup"
                        ? OrderProcessItem(
                            title: 'Заказ готов к выдаче', icon: 'assets/images/newOrder33.svg', isActive: orderProcessItemModel.orderStatusId == 'collected')
                        : OrderProcessItem(
                            title: 'Заказ едет к вам', icon: 'assets/images/newOrder3.svg', isActive: orderProcessItemModel.orderStatusId == 'delivering'),
                    OrderProcessItem(
                        title: orderProcessItemModel.orderDeliveryTypeId == "pickup" ? 'Заказ вручен' : 'Заказ доставлен',
                        icon: 'assets/images/newOrder4.svg',
                        isActive: orderProcessItemModel.orderStatusId == 'done'),
                  ],
                ),
                SizedBox(height: heightRatio(size: 40, context: context)),
                orderProcessItemModel.orderDeliveryTypeId == "pickup"
                    ? OrderBnsPickup(orderProcessItemModel: orderProcessItemModel)
                    : OrderBnsDelivery(
                        orderProcessItemModel: orderProcessItemModel,
                      ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
