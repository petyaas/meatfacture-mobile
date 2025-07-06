import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc_files/basic_page_bloc.dart';
import 'package:smart/bloc_files/diverse_food_bloc.dart';
import 'package:smart/features/home/widgets/home_diverse_food_card_button_shimmer.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_diverse_food_content.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_diverse_food_progress_box.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

// разнообразное питание
HomeDiverseFoodCardButton() => BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        BasicPageBloc _basicPageBloc = BlocProvider.of(context);
        AuthPageBloc _authPageBloc = BlocProvider.of(context);
        return BlocConsumer<DiverseFoodBloc, DiverseFoodState>(
          listener: (context, state) {
            if (state is DiverseFoodOldTokenState) {
              ProfilePage.logout(regBloc: _authPageBloc, basicPageBloc: _basicPageBloc);
            }
          },
          builder: (context, diverseFoodState) {
            return InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RedesDiverseFoodContent())),
              child: Container(
                padding: EdgeInsets.all(widthRatio(size: 10, context: context)),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)),
                  boxShadow: [BoxShadow(color: newShadow, offset: Offset(12, 12), blurRadius: 24, spreadRadius: 0)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)), color: newIconBg),
                          child: SvgPicture.asset(
                            "assets/images/variedNutrition.svg",
                            height: heightRatio(size: 35, context: context),
                            width: widthRatio(size: 34, context: context),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        SizedBox(width: widthRatio(size: 15, context: context)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "diverseFoodOneLineText".tr(),
                                style: appHeadersTextStyle(fontSize: heightRatio(size: 15, context: context), fontWeight: FontWeight.w700, color: newBlack),
                              ),
                              SizedBox(height: heightRatio(size: 5, context: context)),
                              // если пользователь еще не участвует в разннобр питании:
                              if (profileState is ProfileLoadedState && profileState.profileModel.data.isAgreeWithDiverseFoodPromo == false)
                                Text(
                                  "diverseFoodDescriptionText".tr(),
                                  style: appTextStyle(fontSize: heightRatio(size: 12.5, context: context), fontWeight: FontWeight.w400, color: newBlackLight),
                                )
                              // участвует в разн питании:
                              else
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Сейчас вы копите скидку ",
                                        style: appLabelTextStyle(fontSize: heightRatio(size: 13, context: context), fontWeight: FontWeight.w400, color: newBlackLight),
                                      ),
                                      TextSpan(
                                        text: "to".tr() + " ",
                                        style: appLabelTextStyle(fontSize: heightRatio(size: 13, context: context), fontWeight: FontWeight.w400, color: newRedDark),
                                      ),
                                      TextSpan(
                                        text: getMonthName(month: DateTime.now().month == 12 ? 1 : DateTime.now().month + 1),
                                        style: appLabelTextStyle(fontSize: heightRatio(size: 13, context: context), fontWeight: FontWeight.w400, color: newRedDark),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(width: widthRatio(size: 10, context: context)),
                        Icon(Icons.arrow_forward_ios_rounded, color: newRedDark, size: heightRatio(size: 23, context: context)),
                      ],
                    ),
                    if (diverseFoodState is DiverseFoodLoadingState) HomeDiverseFoodCardButtonShimmer(),
                    if (profileState is ProfileLoadedState &&
                        profileState.profileModel.data.isAgreeWithDiverseFoodPromo == true &&
                        diverseFoodState is DiverseFoodLoadedState &&
                        diverseFoodState.diverseFoodPersentListModel.data != null &&
                        diverseFoodState.diverseFoodPersentListModel.data.isNotEmpty)
                      redesDiverseFoodProgressBox(context: context, state: diverseFoodState, forMaim: true), //проценты в квадратиках
                    // if (diverseFoodState is DiverseFoodLoadedState &&
                    //     profileState is ProfileLoadedState &&
                    //     profileState
                    //             .profileModel.data.isAgreeWithDiverseFoodPromo ==
                    //         true)
                    //   Padding(
                    //     padding: EdgeInsets.only(
                    //       top: heightRatio(size: 20, context: context),
                    //       left: widthRatio(size: 15, context: context),
                    //     ),
                    //     child: Text(
                    //       diverseFoodState.dFDescription.title ?? '',
                    //       style: appTextStyle(
                    //           color: red015,
                    //           fontSize: heightRatio(size: 10, context: context)),
                    //     ),
                    //   )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
