import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/hisory_oder_details_bloc.dart';
import 'package:smart/order_process/order_process_item_model.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/pages/history_order_details_page.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderBnsPickup extends StatelessWidget {
  final OrderProcessItemModel orderProcessItemModel;

  const OrderBnsPickup({Key key, this.orderProcessItemModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (orderProcessItemModel.orderStatusId != 'done')
          GestureDetector(
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
        if (orderProcessItemModel.orderStatusId != 'done' && orderProcessItemModel.orderStatusId == 'collected') SizedBox(height: heightRatio(size: 10, context: context)),
        if (orderProcessItemModel.orderStatusId != 'done' && orderProcessItemModel.orderStatusId == 'collected')
          GestureDetector(
            onTap: () async {
              final Uri launchUri = Uri(scheme: 'tel', path: orderProcessItemModel.storePhone);
              await launchUrl(launchUri);
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
              child: Text(
                'Связаться с магазином',
                style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
              ),
            ),
          ),
        if (orderProcessItemModel.orderStatusId != 'done' && orderProcessItemModel.orderStatusId == 'collected') SizedBox(height: heightRatio(size: 10, context: context)),
        // if (orderProcessItemModel.orderStatusId == 'done')
        //   Container(
        //     alignment: Alignment.center,
        //     padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
        //     width: MediaQuery.of(context).size.width,
        //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
        //     child: Text(
        //       'Оставить отзыв о заказе',
        //       style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
        //     ),
        //   ),
      ],
    );
  }
}
