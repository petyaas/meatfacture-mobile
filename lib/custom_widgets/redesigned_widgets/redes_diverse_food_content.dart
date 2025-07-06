import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/bloc_files/diverse_food_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_diverse_food_is_active_content.dart';
import 'package:smart/pages/redesigned_pages/redes_secondary_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RedesDiverseFoodContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DiverseFoodBloc _diverseFoodBloc = BlocProvider.of<DiverseFoodBloc>(context);
    ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadedState) {
          if (state.profileModel.data.isAgreeWithDiverseFoodPromo == false) {
            return RedesSecondaryPage(
                contentWidget: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/diverse_food_image.png',
                          width: widthRatio(size: screenWidth(context) / 2, context: context),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context), vertical: heightRatio(size: 6, context: context)),
                          child: Text(
                            "diverseFoodCampaignText".tr(),
                            style: appHeadersTextStyle(fontSize: heightRatio(size: 22, context: context)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth(context) / 8, vertical: heightRatio(size: 10, context: context)),
                          child: Text(
                            "diverseFoodDeactiveSubtitle".tr(),
                            style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context)),
                            // style: appTextStyle(fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 25),
                        InkWell(
                          onTap: () {
                            _profileBloc.add(ProfileUpdateDataEvent(isAgreeWithDiverseFoodPromo: 1));
                            _profileBloc.add(ProfileLoadEvent());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                            margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 35, context: context)),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                            child: Text("takePartText".tr(), style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context))),
                          ),
                        ),
                      ],
                    )),
                upText: "diverseFoodOneLineText".tr());
          } else {
            if (_diverseFoodBloc.state is DiverseFoodLoadedState) {
              return RedesDiverseFoodIsActiveContent();
            } else {
              _diverseFoodBloc.add(DiverseFoodLoadEvent());
              return RedesDiverseFoodIsActiveContent();
            }
          }
        }
        if (state is ProfileErrorState) {
          return RedesSecondaryPage(
            upText: "diverseFoodOneLineText".tr(),
            contentWidget: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: widthRatio(size: 20, context: context), right: widthRatio(size: 20, context: context)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                  topRight: Radius.circular(heightRatio(size: 15, context: context)),
                ),
              ),
              child: Center(
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
                  Text("errorText".tr(),
                      style: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500)),
                  SizedBox(height: heightRatio(size: 10, context: context)),
                  InkWell(
                      onTap: () {
                        _profileBloc.add(ProfileLoadEvent());
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Text("tryAgainText".tr(),
                            style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500)),
                      ))
                ],
              )),
            ),
          );
        }
        return Container();
      },
    );
  }
}
