// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/hisory_oder_details_bloc.dart';
import 'package:smart/custom_widgets/history_order_details_page_content_widget.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

// ignore: must_be_immutable
class HistoryOrderDetailsPage extends StatelessWidget {
  String orderDate;
  HistoryOrderDetailsPage({@required this.orderDate});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryOrdertDetailsBloc, HistoryOrderDetailsState>(
      builder: (context, state) {
        if (state is HistoryOrderDetailsLoadedState) {
          orderDate = state.orderDetailsAndCalculateResponseModel.data.number.toString();
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            color: newRedDark,
            child: SafeArea(
              bottom: false,
              child: Container(
                alignment: Alignment.center,
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: heightRatio(size: 15, context: context), horizontal: widthRatio(size: 10, context: context)),
                    child: Row(
                      children: [
                        InkWell(
                          child: Container(
                            color: Colors.transparent,
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: heightRatio(size: 25, context: context),
                              color: whiteColor,
                            ),
                          ),
                          onTap: () {
                            // _bottomNavBloc.add(HomeEvent());
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: widthRatio(size: 10, context: context)),
                        Text(
                          "OrderText".tr() + " №" + orderDate,
                          style: appHeadersTextStyle(color: whiteColor, fontSize: heightRatio(size: 22, context: context)),
                        )
                      ],
                    ),
                  ),
                  //main Content
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                        topRight: Radius.circular(heightRatio(size: 15, context: context)),
                      ),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: HistoryOrderDetailsPageContentWidget(),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
