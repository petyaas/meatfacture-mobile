import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/features/addresses/addresses_select_nearest_shop_bottom_sheet.dart';
import 'package:smart/pages/redesigned_pages/redes_bonuses_instruction_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RedesPointsHaveNowCard extends StatelessWidget {
  final String shopAddres = "";

  void openAddressesSelectNearestShopBottomSheet(BuildContext context) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(heightRatio(size: 25, context: context)),
            topRight: Radius.circular(heightRatio(size: 25, context: context)),
          ),
        ),
        builder: (BuildContext bc) {
          //Выберите ближайший магазин для продолжения покупок
          return AddressesSelectNearestShopBottomSheet();
        }).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state is ProfileLoadedState) {
        return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 15, context: context)), color: lightGreyColor),
            padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "totalBonusesText".tr(),
                      style: appHeadersTextStyle(fontSize: heightRatio(size: 15, context: context), fontWeight: FontWeight.w700),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => redesBonusesInstructionPage(headerText: "", context: context),
                            ));
                      },
                      child: Container(
                        child: Text(
                          "FindOutHowToSaveMoreText".tr(),
                          style: appHeadersTextStyle(fontSize: heightRatio(size: 12, context: context), fontWeight: FontWeight.w600, color: colorDarkRed),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: heightRatio(size: 5, context: context)),
                Row(
                  children: [
                    Text(state.profileModel.data.bonusBalance.toString(),
                        style: appHeadersTextStyle(fontSize: heightRatio(size: 20, context: context), fontWeight: FontWeight.w800, color: mainColor)),
                    SizedBox(width: widthRatio(size: 5, context: context)),
                    Container(
                      height: heightRatio(size: 25, context: context),
                      child: SvgPicture.asset('assets/images/bonus_vector.svg', height: heightRatio(size: 25, context: context)),
                    )
                  ],
                )
              ],
            ));
      }
      return SizedBox();
    });
  }
}
