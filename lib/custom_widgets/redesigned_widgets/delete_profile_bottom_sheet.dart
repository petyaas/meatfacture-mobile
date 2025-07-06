import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/custom_widgets/redesigned_widgets/custom_loadable_screen.dart';
import 'package:smart/theme/app_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc_files/delete_profile_bloc.dart';
import '../../services/services.dart';

//ignore: must_be_immutable
class DeleteProfileBottomSheet extends StatelessWidget {
  DeleteProfileBottomSheet({Key key, this.isDeleted}) : super(key: key);

  bool isDeleted;

  @override
  Widget build(
    BuildContext context,
  ) {
    ProfileBloc _profileBloc = BlocProvider.of(context);
    return BlocProvider(
      create: (BuildContext context) => DeleteProfileBloc(),
      child: BlocBuilder<DeleteProfileBloc, DeleteProfileState>(builder: (context, state) {
        DeleteProfileBloc _deleteProfileBloc = BlocProvider.of(context);

        if (state is DeleteProfileLoadedState && state.deleteProfileModel.success) {
          _profileBloc.add(ProfileLoadEvent());
          isDeleted = true;
        }
        if (state is DeleteProfileErrorState) {
          Fluttertoast.showToast(msg: "errorText".tr());
        }
        return CustomLoadableScreen(
          loading: state is DeleteProfileLoadingState,
          child: Container(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: widthRatio(size: 16, context: context), right: widthRatio(size: 16, context: context), top: heightRatio(size: 20, context: context), bottom: heightRatio(size: 30, context: context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${"deleteProfileForever".tr()}?",
                          style: appHeadersTextStyle(fontSize: widthRatio(size: 17, context: context)),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: SvgPicture.asset(
                            "assets/images/close_circle_for_bs.svg",
                            height: heightRatio(size: 24, context: context),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: heightRatio(size: 16, context: context)),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "deleteProfileDescription".tr(),
                            style: appLabelTextStyle(color: colorBlack08, fontSize: widthRatio(size: 12, context: context)),
                          ),
                          TextSpan(
                            text: "deleteProfileDescriptionHyperlink".tr(),
                            recognizer: TapGestureRecognizer()..onTap = () => launchUrl(Uri.parse('$apiHead/policy.pdf'), mode: LaunchMode.externalApplication),
                            style: appLabelTextStyle(color: newRedDark, fontSize: widthRatio(size: 12, context: context)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: heightRatio(size: 16, context: context)),
                    Text(
                      "haventChangedYourMind".tr(),
                      style: appHeadersTextStyle(fontSize: widthRatio(size: 14, context: context)),
                    ),
                    SizedBox(height: heightRatio(size: 30, context: context)),
                    AppButton(
                      text: "deleteAcc".tr(),
                      colorButton: newRedDark,
                      hasMargin: false,
                      onPress: () {
                        _deleteProfileBloc.add(DeleteProfileStartEvent(context));
                      },
                    ),
                    SizedBox(height: heightRatio(size: 8, context: context)),
                    AppButton(
                      text: "toCancel".tr(),
                      colorButton: newBlack,
                      hasMargin: false,
                      onPress: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
