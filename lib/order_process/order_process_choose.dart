import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/order_process/order_process_bottom_sheet.dart';
import 'package:smart/order_process/order_process_list_model.dart';

class OrderProcessChoose extends StatelessWidget {
  final OrderProcessListModel model;
  const OrderProcessChoose({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context), vertical: heightRatio(size: 15, context: context)),
        itemCount: model.data.length,
        itemBuilder: (BuildContext context, int index) {
          final String price = model.data[index].totalPrice % 1 == 0 ? model.data[index].totalPrice.toStringAsFixed(0) : model.data[index].totalPrice.toStringAsFixed(2);
          String status;
          switch (model.data[index].orderStatusId) {
            case "new":
              status = "Заказ оформлен";
              break;
            case "collecting":
              status = "Заказ собирается";
              break;
            case "collected":
              status = model.data[index].orderDeliveryTypeId == "pickup" ? "Заказ готов к выдаче" : "Заказ едет к вам";
              break;
            case "delivering":
              status = "Заказ едет к вам";
              break;
            case "done":
              status = model.data[index].orderDeliveryTypeId == "pickup" ? "Заказ вручен" : "Заказ доставлен";
              break;
            case "cancelled":
              status = "Заказ отменен";
              break;
          }
          return InkWell(
            onTap: () {
              orderProcessBottomSheet(context, model.data[index]);
            },
            child: Container(
              width: double.maxFinite,
              height: heightRatio(size: 70, context: context),
              padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
              margin: EdgeInsets.symmetric(vertical: heightRatio(size: 6, context: context)),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)),
                boxShadow: [BoxShadow(color: newShadow, offset: Offset(12, 12), blurRadius: 24, spreadRadius: 0)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Заказ ${model.data[index].number}',
                        style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'На сумму: $price',
                              style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newBlack),
                            ),
                            TextSpan(
                              text: ' ₽',
                              style: appTextStyle(fontSize: heightRatio(size: 12, context: context), color: newBlack),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        model.data[index].orderDeliveryTypeId == "pickup" ? 'Самовывоз' : 'Доставка',
                        style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newBlackLight),
                      ),
                      Text(
                        status,
                        style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newRedDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
