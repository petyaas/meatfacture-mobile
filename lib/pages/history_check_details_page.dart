import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/history_check_details_bloc.dart';
import 'package:smart/custom_widgets/history_check_details_page_content_widget.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

// ignore: must_be_immutable
class HistoryCheckDetailsPage extends StatelessWidget {
  String checkDate;
  HistoryCheckDetailsPage({@required this.checkDate});
  // final GlobalKey<NavigatorState> checkHistoryNavKey =
  //     new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // // ignore: close_sinks
    // SecondaryPageBloc _bottomNavBloc =
    //     BlocProvider.of<SecondaryPageBloc>(context);
    return BlocBuilder<HistoryCheckDetailsBloc, HistoryCheckDetailsState>(
      builder: (context, state) {
        if (state is HistoryCheckDetailsLoadedState) {
          checkDate = "checkText".tr() + " " + state.checkDetailsModel.checkDetailsDataModel.id.toString();
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            color: mainColor,
            child: SafeArea(
              bottom: false,
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: heightRatio(size: 12, context: context)),
                    Container(
                      margin: EdgeInsets.only(bottom: heightRatio(size: 16, context: context), left: widthRatio(size: 15, context: context)),
                      child: Row(
                        children: [
                          InkWell(
                            child: Container(
                              color: Colors.transparent,
                              child: Icon(Icons.arrow_back_ios_new_rounded, size: heightRatio(size: 25, context: context), color: whiteColor),
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                          SizedBox(width: widthRatio(size: 10, context: context)),
                          Text(
                            checkDate,
                            style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
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
                          child: HistoryCheckDetailsPageContentWidget(),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
