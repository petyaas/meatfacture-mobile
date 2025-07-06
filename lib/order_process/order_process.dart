import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/order_process/order_process_bottom_sheet.dart';
import 'package:smart/order_process/order_process_choose.dart';
import 'package:smart/order_process/order_process_list_bloc.dart';
import 'package:smart/order_process/order_process_list_model.dart';
import 'package:smart/theme/app_screen.dart';

class OrderProcess extends StatefulWidget {
  @override
  State<OrderProcess> createState() => _OrderProcessState();
}

class _OrderProcessState extends State<OrderProcess> {
  OrderProcessListModel orderProcessListModel;
  bool _isProcessing = false; // Флаг для блокировки повторных кликов

  Widget build(BuildContext context) {
    return BlocBuilder<OrderProcessListBloc, OrderPLState>(
      builder: (context, state) {
        if (state is OrderPLLoadedState) {
          orderProcessListModel = state.orderProcessListModel;
        }
        // if (state is OrderPLLoadingState) {
        //   return Container(
        //     alignment: Alignment.center,
        //     height: heightRatio(size: 82, context: context),
        //     child: CircularProgressIndicator(),
        //   );
        // }
        if (orderProcessListModel == null || orderProcessListModel.data.isEmpty) {
          return SizedBox();
        } else {
          return Padding(
            padding: EdgeInsets.only(top: heightRatio(size: 15, context: context)),
            child: InkWell(
              onTap: () async {
                if (_isProcessing) return; // Блокируем повторный клик

                setState(() {
                  _isProcessing = true;
                });

                // Инициируем обновление данных
                context.read<OrderProcessListBloc>().add(OrderPLRefreshEvent());

                // Подписываемся на изменения состояния, чтобы дождаться обновления данных
                final newState = await context.read<OrderProcessListBloc>().stream.firstWhere(
                      (state) => state is OrderPLLoadedState || state is OrderPLErrorState,
                    );

                setState(() {
                  _isProcessing = false; // Разблокируем после завершения
                });

                if (newState is OrderPLLoadedState) {
                  orderProcessListModel = newState.orderProcessListModel;

                  if (orderProcessListModel.data.length == 1) {
                    orderProcessBottomSheet(context, orderProcessListModel.data[0]);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppScreen(
                          title: "Выберите заказ для отслеживания",
                          titleSize: 18,
                          content: OrderProcessChoose(model: orderProcessListModel),
                        ),
                      ),
                    );
                  }
                } else if (newState is OrderPLErrorState) {
                  // Здесь можно обработать ошибку, например, показать сообщение пользователю
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка обновления данных заказа')),
                  );
                }
              },
              child: Container(
                height: heightRatio(size: 102, context: context),
                padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
                decoration: BoxDecoration(
                  color: newBlack,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ваш заказ в процессе',
                          style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: Colors.white),
                        ),
                        SizedBox(height: heightRatio(size: 10, context: context)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Посмотреть статус заказа',
                              style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: Colors.white),
                            ),
                            SizedBox(width: widthRatio(size: 6, context: context)),
                            Icon(Icons.chevron_right_rounded, color: Colors.white, size: 19),
                          ],
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      'assets/images/newBike.svg',
                      height: heightRatio(size: 74, context: context),
                      width: widthRatio(size: 83, context: context),
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
