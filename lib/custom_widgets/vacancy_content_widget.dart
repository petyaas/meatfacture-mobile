// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:smart/custom_widgets/shimmer_loader_for_vacancy_list.dart';
import 'package:smart/models/vacancy_list_model.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class VacancyContentWidget extends StatelessWidget {
  final GlobalKey<PaginationViewState> paginationViewkey = GlobalKey();

  int i = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PaginationView<VacancyListDataModel>(
          key: paginationViewkey,
          paginationViewType: PaginationViewType.gridView,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1,
            crossAxisCount: 1,
          ),
          padding: EdgeInsets.only(left: widthRatio(size: 15, context: context), right: widthRatio(size: 15, context: context), bottom: heightRatio(size: 15, context: context)),
          itemBuilder: (context, vacancyContentWidget, index) => Container(
                margin: EdgeInsets.only(top: heightRatio(size: 10, context: context)),
                padding: EdgeInsets.all(widthRatio(size: 10, context: context)),
                decoration: BoxDecoration(image: DecorationImage(image: new NetworkImage(vacancyContentWidget.logoFilePath), fit: BoxFit.cover), borderRadius: BorderRadius.circular(heightRatio(size: 20, context: context))),
                child: InkWell(
                  onTap: () async {
                    launchUrl(Uri.parse(vacancyContentWidget.url), mode: LaunchMode.externalApplication);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: heightRatio(size: 14, context: context)),
                        alignment: Alignment.center,
                        child: Text(
                          'respondText'.tr(),
                          style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 18, context: context)),
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)), color: mainColor),
                      ),
                    ],
                  ),
                ),
              ),
          initialLoader: ShimmerLoaderForVacancyList(),
          pageFetch: (currentListSize) async {
            VacancyListModel _vacancyListModel = await VacancyListProvider().getVacancyListResponse(page: i++);
            return _vacancyListModel.data;
          },
          onEmpty: Center(
            child: Text('emptyText'.tr()),
          ),
          onError: (dynamic error) => Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
                    decoration: BoxDecoration(color: colorBlack03, shape: BoxShape.circle),
                    child: SvgPicture.asset(
                      'assets/images/netErrorIcon.svg',
                      color: Colors.white,
                      height: heightRatio(size: 30, context: context),
                    ),
                  ),
                  SizedBox(height: heightRatio(size: 15, context: context)),
                  Text("errorText".tr(), style: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500)),
                  SizedBox(height: heightRatio(size: 10, context: context)),
                  InkWell(
                      onTap: () {
                        i = 1;
                        paginationViewkey.currentState.refresh();
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Text("tryAgainText".tr(), style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500)),
                      ))
                ],
              ))),
    );
  }
}
