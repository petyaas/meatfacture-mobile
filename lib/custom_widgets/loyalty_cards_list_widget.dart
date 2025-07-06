// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc_files/loyalty_cards_list_bloc.dart';
import 'package:smart/custom_widgets/user_name_in_L_card.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class LoyaltyCardsListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoyaltyCardsListBloc, LoyaltyCardsListState>(
      builder: (context, state) {
        if (state is LoyaltyCardsListEmptyState || state is LoyaltyCardsListErrorState) {
          return Container();
        }
        if (state is LoyaltyCardsListLoadedState) {
          if (state.loyaltyCardsListModel.data.isNotEmpty) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: heightRatio(size: 10, context: context)),
                  Text('loyaltyCardText'.tr(), style: profileGreyTextStyle),
                  SizedBox(height: heightRatio(size: 20, context: context)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(heightRatio(size: 15, context: context)),
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(top: widthRatio(size: 20, context: context), left: widthRatio(size: 20, context: context)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //User name
                                  Container(
                                    child: UserNameInLCardForProfilePage(),
                                    alignment: Alignment.topLeft,
                                  ),
                                  SizedBox(height: heightRatio(size: 5, context: context)),
                                  Text(
                                    'cardNomText'.tr() + state.loyaltyCardsListModel.data[0].number,
                                    style: appTextStyle(color: white04, fontSize: heightRatio(size: 12, context: context)),
                                  ),
                                  SizedBox(height: heightRatio(size: 10, context: context)),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_border_outlined,
                                        color: white04,
                                      ),
                                      SizedBox(width: widthRatio(size: 10, context: context)),
                                      Text(
                                        '',
                                        style: appTextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: heightRatio(size: 14, context: context)),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: heightRatio(size: 15, context: context)),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.shopping_bag_outlined,
                                        color: white04,
                                      ),
                                      Text(
                                        " ${state.purchasesSum} p",
                                        style: appTextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: heightRatio(size: 14, context: context)),
                                      ),
                                      Text(
                                        "for14daysText".tr(),
                                        style: appTextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: heightRatio(size: 12, context: context)),
                                      ),
                                      SizedBox(width: widthRatio(size: 10, context: context)),
                                      Text(
                                        '',
                                        style: appTextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: heightRatio(size: 14, context: context)),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: heightRatio(size: 20, context: context)),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: EdgeInsets.only(top: heightRatio(size: 25, context: context)),
                              alignment: Alignment.bottomRight,
                              child: SvgPicture.asset(
                                "assets/images/MFIcon.svg",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(color: mainColor),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        }
        return Container();
      },
    );
  }
}
