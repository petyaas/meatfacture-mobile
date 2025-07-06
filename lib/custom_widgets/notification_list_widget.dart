// ignore: implementation_imports
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:smart/bloc_files/hisory_oder_details_bloc.dart';
import 'package:smart/bloc_files/history_check_details_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/features/catalog/subcatalog_screen.dart';
import 'package:smart/models/notification_list_model.dart';
import 'package:smart/pages/history_check_details_page.dart';
import 'package:smart/pages/history_order_details_page.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/pages/redesigned_pages/redes_product_details_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int i = 1;
    return Container(
        alignment: Alignment.topLeft,
        child: PaginationView<NotificationsListDataModel>(
          padding: EdgeInsets.symmetric(vertical: heightRatio(size: 10, context: context), horizontal: widthRatio(size: 20, context: context)),
          paginationViewType: PaginationViewType.listView,
          onError: (dynamic error) => Center(
            child: Text('errorText'.tr()),
          ),
          onEmpty: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/smartLogonoText.svg',
                color: colorBlack03,
                height: heightRatio(size: 80, context: context),
              ),
              SizedBox(height: heightRatio(size: 25, context: context)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
                child: Text("youHasNoGotNotificationsText".tr(), textAlign: TextAlign.center, style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500)),
              ),
            ],
          )),
          bottomLoader: Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
            ),
          ),
          initialLoader: Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
            ),
          ),
          pageFetch: (currentListSize) async {
            NotificationsListModel notificationList = await NotificationsProvider().getNotificationListResponse(page: i);
            i += 1;
            return notificationList.data;
          },
          itemBuilder: (BuildContext context, NotificationsListDataModel notificationsListDataModel, int index) {
            DateTime createdAt = dateTimeConverter(notificationsListDataModel.createdAt);
            return InkWell(
              onTap: () => routeFromNotifications(context, notificationsListDataModel.data.meta),
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: heightRatio(size: 15, context: context)),
                  //Title
                  Text(
                    notificationsListDataModel.data.title,
                    style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newRedDark),
                  ),
                  SizedBox(height: heightRatio(size: 5, context: context)),
                  //Body
                  Text(
                    notificationsListDataModel.data.body,
                    style: appLabelTextStyle(fontSize: heightRatio(size: 18, context: context), color: Colors.black),
                  ),
                  SizedBox(height: heightRatio(size: 10, context: context)),
                  //Date
                  Text(
                      createdAt.day == DateTime.now().day
                          ? "${"todayText".tr()}  ${createdAt.hour < 10 ? "0${createdAt.hour}" : createdAt.hour}:${createdAt.minute < 10 ? "0${createdAt.minute}" : createdAt.minute}"
                          : createdAt == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1)
                              ? "${"yesterdayText".tr()}  ${createdAt.hour < 10 ? "0${createdAt.hour}" : createdAt.hour}:${createdAt.minute < 10 ? "0${createdAt.minute}" : createdAt.minute}"
                              : "${createdAt.toFormatedDate()}  ${createdAt.toFormatedTime()}",
                      style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: colorBlack04)),
                  SizedBox(height: heightRatio(size: 5, context: context)),
                  Divider()
                ],
              )),
            );
          },
        ));
  }

  routeFromNotifications(BuildContext context, DataMeta meta) {
    switch (meta.type) {
      case "orders":
        HistoryOrdertDetailsBloc _historyOrdertDetailsBloc = BlocProvider.of(context);
        _historyOrdertDetailsBloc.add(HistoryOrderDetailsLoadEvent(orderId: meta.id));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HistoryOrderDetailsPage(
            orderDate: '',
          ),
        ));
        break;
      case "receipts":
        HistoryCheckDetailsBloc _historyCheckDetailsBloc = BlocProvider.of(context);
        _historyCheckDetailsBloc.add(HistoryCheckDetailsLoadEvent(receiptUuid: meta.id));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HistoryCheckDetailsPage(
            checkDate: '',
          ),
        ));
        break;
      case "assortments":
        if (meta.id == null) {
          SecondaryPageBloc secondaryPageBloc = BlocProvider.of(context);
          secondaryPageBloc.add(CatalogEvent());
        } else {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => RedesProductDetailsPage(
                productUuid: meta.id,
              ),
            ),
          );
        }
        break;

      case "catalogs":
        if (meta.id != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SubcatalogScreen(
                isSearchPage: false,
                uuidForAllProductsInCatalog: meta.id,
              ),
            ),
          );
        }
        break;
      case "profile":
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
        break;
      case "url":
        launchUrl(Uri.parse(meta.url));
        break;
    }
  }
}
