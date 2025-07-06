// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_points_have_now_card.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_points_history_content.dart';
import 'package:smart/models/bonuses_list_model.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

import '../../bloc_files/hisory_oder_details_bloc.dart';
import '../../bloc_files/history_check_details_bloc.dart';
import '../../pages/history_check_details_page.dart';
import '../../pages/history_order_details_page.dart';

class RedesHasBonusesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HistoryOrdertDetailsBloc _historyOrdertDetailsBloc = BlocProvider.of<HistoryOrdertDetailsBloc>(context);
    HistoryCheckDetailsBloc _historyCheckDetailsBloc = BlocProvider.of<HistoryCheckDetailsBloc>(context);
    int currentPage = 1;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(heightRatio(size: 15, context: context)),
                bottomRight: Radius.circular(heightRatio(size: 15, context: context)),
              ),
              color: whiteColor),
          child: RedesPointsHaveNowCard(),
        ),
        SizedBox(height: heightRatio(size: 15, context: context)),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                  topRight: Radius.circular(heightRatio(size: 15, context: context)),
                ),
                color: whiteColor),
            child: PaginationView<BonusesListDataModel>(
              initialLoader: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                ),
              ),
              padding: EdgeInsets.only(left: widthRatio(size: 15, context: context), right: widthRatio(size: 15, context: context), top: heightRatio(size: 12, context: context)),
              paginationViewType: PaginationViewType.listView,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.3,
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, BonusesListDataModel bonusesListDataModel, int index) {
                return InkWell(
                  onTap: () {
                    if (bonusesListDataModel.relatedReferenceType != null && bonusesListDataModel.relatedReferenceId != "") {
                      if (bonusesListDataModel.relatedReferenceType == "receipt") {
                        _historyCheckDetailsBloc.add(HistoryCheckDetailsLoadEvent(receiptUuid: bonusesListDataModel.relatedReferenceId));

                        Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryCheckDetailsPage(checkDate: "checkText".tr())));
                      } else {
                        _historyOrdertDetailsBloc.add(HistoryOrderDetailsLoadEvent(orderId: bonusesListDataModel.relatedReferenceId));

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoryOrderDetailsPage(
                                      orderDate: "",
                                    )));
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: heightRatio(size: 12, context: context), bottom: heightRatio(size: 12, context: context)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getResonText(bonusesListDataModel),
                                style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: heightRatio(size: 5, context: context)),
                              Text(
                                getDateForText(bonusesListDataModel.createdAt),
                                style: appHeadersTextStyle(fontSize: heightRatio(size: 12, context: context), fontWeight: FontWeight.w500, color: colorBlack06),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: widthRatio(size: 10, context: context)),
                        Row(
                          children: [
                            Text(
                              bonusesListDataModel.quantityDelta < 0 ? bonusesListDataModel.quantityDelta.toString() : "+" + bonusesListDataModel.quantityDelta.toString(),
                              style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), fontWeight: FontWeight.w600, color: colorBlack06),
                            ),
                            SizedBox(width: widthRatio(size: 5, context: context)),
                            SvgPicture.asset(
                              "assets/images/MFIcon.svg",
                              fit: BoxFit.contain,
                              height: heightRatio(size: 30, context: context),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              pageFetch: (currentListSize) async {
                List<BonusesListDataModel> fechedPage = await BonusesListProvider().BonusesListForPaginationResponse(currentPage: currentPage);
                currentPage++;
                return fechedPage;
              },
              onEmpty: RedesEmptyBonusesHitoryContent(),
              bottomLoader: Center(
                // optional
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                )),
              ),
              onError: (dynamic error) => Center(
                child: Text('errorText'.tr()),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String getDateForText(DateTime date) {
  if (date.month == DateTime.now().month && date.day == DateTime.now().day) {
    return "${"todayText".tr()} ${date.hour}:${date.minute}";
  }
  if (date.month == DateTime.now().month && date.day - 1 == DateTime.now().day) {
    return "${"yesterdayText".tr()} ${date.hour}:${date.minute}";
  }
  return "${date.day} ${getMonthName(month: date.month, isOfMode: true)} ${date.hour}:${date.minute}";
}

String getResonText(BonusesListDataModel bonusesListDataModel) {
  switch (bonusesListDataModel.reason) {
    case "purchase_paid":
      {
        if (bonusesListDataModel.relatedReferenceType == "receipt")
          return "${"forCheckText".tr()}";
        //${bonusesListDataModel.relatedReferenceId}*/";
        else
          return "${"forOrderText".tr()} ";
        // ${bonusesListDataModel.relatedReferenceId}";
      }
      break;
    case "manual":
      return "youGotGiftFromSmartText".tr();
      break;
    case "paid_purchase_cancelled":
      return "purchaseCancelled".tr();
      break;
    case "done_purchase_cancelled":
      {
        if (bonusesListDataModel.relatedReferenceType == "receipt")
          return "${"refundText".tr()} ${"forCheckText".tr().toLowerCase()}";
        //${bonusesListDataModel.relatedReferenceId}*/";
        else
          return "${"refundText".tr()} ${"forOrderText".tr().toLowerCase()} ";
        // ${bonusesListDataModel.relatedReferenceId}";
      }
      break;
    case "profile_filled":
      return "profile_filled".tr();
    case "purchase_done":
      return "purchase_done".tr();
    default:
      return bonusesListDataModel.reason;
  }
}
