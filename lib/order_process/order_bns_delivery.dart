import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/hisory_oder_details_bloc.dart';
import 'package:smart/order_process/order_process_item_model.dart';
import 'package:smart/order_process/order_process_support_bottom_sheet.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/pages/history_order_details_page.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderBnsDelivery extends StatelessWidget {
  final OrderProcessItemModel orderProcessItemModel;

  const OrderBnsDelivery({Key key, this.orderProcessItemModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return orderProcessItemModel.orderStatusId != 'delivering'
        ? Column(
            children: [
              if (orderProcessItemModel.orderStatusId != 'done')
                InkWell(
                  onTap: () {
                    BlocProvider.of<HistoryOrdertDetailsBloc>(context).add(HistoryOrderDetailsLoadEvent(orderId: orderProcessItemModel.uuid));
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return HistoryOrderDetailsPage(orderDate: orderProcessItemModel.number.toString());
                    }));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                    child: Text(
                      'Информация о заказе',
                      style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                    ),
                  ),
                ),
              if (orderProcessItemModel.orderStatusId != 'done' && orderProcessItemModel.orderStatusId == 'collected')
                SizedBox(height: heightRatio(size: 10, context: context)),
              if (orderProcessItemModel.orderStatusId == 'done') SizedBox(height: heightRatio(size: 10, context: context)),
            ],
          )
        : Column(
            children: [
              InkWell(
                onTap: () async {
                  await showModalBottomSheet<dynamic>(
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
                      return OrderProcessSupportBottomSheet(
                        orderNumber: orderProcessItemModel.number,
                        storePhone: orderProcessItemModel.storePhone,
                        courierPhone: orderProcessItemModel.courierPhone,
                      );
                    },
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                  child: Text(
                    'Поддержка',
                    style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                  ),
                ),
              ),
              SizedBox(height: heightRatio(size: 10, context: context)),
              InkWell(
                onTap: () async {
                  final Uri launchUri = Uri(scheme: 'tel', path: orderProcessItemModel.courierPhone);
                  await launchUrl(launchUri);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
                  child: Text(
                    'Связаться с курьером',
                    style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                  ),
                ),
              ),
            ],
          );
  }
}
