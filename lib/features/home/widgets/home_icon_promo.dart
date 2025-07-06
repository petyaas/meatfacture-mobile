import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/yellow_promo_assortments_bloc.dart';
import 'package:smart/features/home/widgets/home_icon_bottom_sheet.dart';
import 'package:smart/models/prodmo_descriptions_model.dart';
import 'package:smart/pages/redesigned_pages/special_promo_desc_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class HomeIconPromo extends StatefulWidget {
  @override
  State<HomeIconPromo> createState() => _HomeIconPromoState();
}

class _HomeIconPromoState extends State<HomeIconPromo> {
  int i = 1;
  List<PromoDescriptionsDataModel> _promoDescriptionsDataList = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchPromoDescriptionsData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchPromoDescriptionsData();
    }
  }

  Future<void> _fetchPromoDescriptionsData() async {
    List<PromoDescriptionsDataModel> newData = await PromoDescriptionsProvider().getPromoDescriptionsResponse(i);
    setState(() {
      _promoDescriptionsDataList.addAll(newData);
      i++;
    });
  }

  @override
  Widget build(BuildContext context) {
    YellowPromoAssortmentsBloc _yellowPromoAssortmentsBloc = BlocProvider.of(context);
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: heightRatio(size: 15, context: context), horizontal: widthRatio(size: 15, context: context)),
      itemCount: _promoDescriptionsDataList.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            switch (_promoDescriptionsDataList[index].uuid) {
              //жц
              case "80d25ffe-528d-4906-ade9-35b33db7d73e":
                _yellowPromoAssortmentsBloc.add(YellowPromoAssortmentsLoadEvent());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpecialPromoDescPage(
                      infoText: _promoDescriptionsDataList[index].description ?? "",
                      promotitle: _promoDescriptionsDataList[index].title ?? "",
                      yellowOrGreenPage: 'y',
                      promoName: _promoDescriptionsDataList[index].name ?? "",
                    ),
                  ),
                );
                break;
              //зц
              case "48fa0378-34fe-429c-9fef-c313403ab212":
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpecialPromoDescPage(
                      promotitle: _promoDescriptionsDataList[index].title ?? "",
                      infoText: _promoDescriptionsDataList[index].description ?? "",
                      promoName: _promoDescriptionsDataList[index].name ?? "",
                      yellowOrGreenPage: 'g',
                    ),
                  ),
                );
                break;
              //Если обычная акция
              default:
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
                    return Wrap(
                      children: [
                        HomeIconBottomSheet(
                          infoText: _promoDescriptionsDataList[index].description,
                          promoName: _promoDescriptionsDataList[index].title,
                          subtitle: _promoDescriptionsDataList[index].subtitle,
                          icon: _promoDescriptionsDataList[index].logoFilePath != null ? Image.network(_promoDescriptionsDataList[index].logoFilePath) : null,
                        ),
                      ],
                    );
                  },
                );
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 11, context: context), vertical: heightRatio(size: 11, context: context)),
            margin: EdgeInsets.only(bottom: heightRatio(size: 20, context: context)),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)),
              boxShadow: [BoxShadow(color: newShadow, offset: Offset(12, 12), blurRadius: 24, spreadRadius: 0)],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _promoDescriptionsDataList[index].logoFilePath != null
                    ? Container(
                        width: 60,
                        height: 60,
                        padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)), color: newIconBg),
                        child: Image.network(_promoDescriptionsDataList[index].logoFilePath),
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)), color: newIconBg),
                      ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: widthRatio(size: 20, context: context)),
                    child: Text(
                      _promoDescriptionsDataList[index].name,
                      style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: newBlack,
                  size: 20,
                )
              ],
            ),
          ),
        );
      }, //end itemBuilder
    );
  }

  String getSvgFromIndex(int index) {
    switch (index) {
      case 0:
        return "assets/images/variedNutrition.svg";
      case 1:
        return "assets/images/newHeartContur";
      case 2:
        return "assets/images/newStor.svg";
      case 3:
        return "assets/images/newPercent.svg";
      case 4:
        return "assets/images/svgForSwitches/favorites_for_switch.svg";
      default:
        return "";
    }
  }
}
