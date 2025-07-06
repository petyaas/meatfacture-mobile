// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc_files/loyalty_cards_list_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/custom_widgets/assortment_filter_button.dart';
import 'package:smart/custom_widgets/loyalty_card_view_bottom_sheet_widget.dart';
import 'package:smart/models/loyalty_cards_list_model.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class LoyaltyCardButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _openLoyaltyCardBottomSheet(String purchasesSum, LoyaltyCardsListModel loyaltyCardsListModel) {
      showModalBottomSheet<dynamic>(
          isScrollControlled: false,
          context: context,
          useSafeArea: true,
          useRootNavigator: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(heightRatio(size: 25, context: context)),
              topRight: Radius.circular(heightRatio(size: 25, context: context)),
            ),
          ),
          builder: (BuildContext bc) {
            return Wrap(
              clipBehavior: Clip.none,
              children: [
                LoyaltyCardViewBottomSheetWidget(
                  purchasesSum: purchasesSum,
                  loyaltyCardsListModel: loyaltyCardsListModel,
                ),
              ],
            );
          }).then((value) {});
    }

    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, profileState) {
      return BlocBuilder<LoyaltyCardsListBloc, LoyaltyCardsListState>(
        builder: (context, state) {
          // if (state is LoyaltyCardsListLoadedState) {
          return Container(
            height: heightRatio(size: 60, context: context),
            width: widthRatio(size: 60, context: context),
            margin: EdgeInsets.only(top: heightRatio(size: 40, context: context)),
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: InkWell(
              onTap: () {
                if (profileState is ProfileAsGuestState) {
                  AssortmentFilterButton().loginOrRegWarning(context);
                } else {
                  if (state is LoyaltyCardsListLoadedState) {
                    _openLoyaltyCardBottomSheet(state.purchasesSum, state.loyaltyCardsListModel);
                  }
                }
              },
              child: Container(
                height: heightRatio(size: 56, context: context),
                width: widthRatio(size: 56, context: context),
                alignment: Alignment.center,
                decoration: BoxDecoration(shape: BoxShape.circle, color: newRedDark),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/cart_icon.svg",
                      width: widthRatio(size: 20, context: context),
                      height: heightRatio(size: 16, context: context),
                    ),
                    SizedBox(height: heightRatio(size: 5, context: context)),
                    Text(
                      "cardText".tr(),
                      style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 10, context: context)),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
