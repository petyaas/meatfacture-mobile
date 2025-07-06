import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_im_in_shop_content.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RedesImInShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: newRedDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: heightRatio(size: 10, context: context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 12.5),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: heightRatio(size: 22, context: context),
                      color: whiteColor,
                    ),
                  ),
                ),
                Text(
                  "Я в магазине",
                  style: appHeadersTextStyle(
                    color: Colors.white,
                    fontSize: heightRatio(size: 22, context: context),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: heightRatio(size: 15, context: context)),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: widthRatio(size: 20, context: context)),
                          SvgPicture.asset(
                            'assets/images/newStorBold.svg',
                            color: Colors.white,
                            height: heightRatio(size: 20, context: context),
                            width: widthRatio(size: 22, context: context),
                          ),
                          SizedBox(width: widthRatio(size: 12, context: context)),
                          Text(
                            profileState is ProfileLoadedState
                                ? profileState.profileModel.data.selectedStoreAddress == null
                                    ? 'notSelectedText'.tr()
                                    : profileState.profileModel.data.selectedStoreAddress
                                : profileState is ProfileAsGuestState
                                    ? profileState.shopAddress ?? "notSelectedText".tr()
                                    : '',
                            textAlign: TextAlign.center,
                            style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: widthRatio(size: 1, context: context),
                            height: heightRatio(size: 27, context: context),
                            color: white03,
                          ),
                          SizedBox(width: widthRatio(size: 15, context: context)),
                          SvgPicture.asset(
                            'assets/images/newEdit2.svg',
                            height: heightRatio(size: 26, context: context),
                            width: widthRatio(size: 26, context: context),
                            fit: BoxFit.scaleDown,
                          ),
                          SizedBox(width: widthRatio(size: 20, context: context)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: heightRatio(size: 6, context: context)),
            Expanded(
              child: RedesImInShopContent(),
            ),
          ],
        ),
      ),
    );
  }
}
