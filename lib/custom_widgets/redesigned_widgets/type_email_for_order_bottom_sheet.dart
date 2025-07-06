import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class TypeEmailForOrderBottomSheet extends StatefulWidget {
  @override
  State<TypeEmailForOrderBottomSheet> createState() => _TypeEmailForOrderBottomSheetState();
}

class _TypeEmailForOrderBottomSheetState extends State<TypeEmailForOrderBottomSheet> {
  final formKey = GlobalKey<FormState>();
  bool isInit = true;
  final TextEditingController emailTextController = TextEditingController();
  @override
  void dispose() {
    emailTextController.dispose();
    super.dispose();
  }

  bool isUserHasEmail = true;
  @override
  Widget build(BuildContext context) {
    ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, profileState) {
      if (profileState is ProfileLoadedState && isInit && profileState.profileModel.data.email != null && profileState.profileModel.data.email.isNotEmpty) {
        isInit = false;
        emailTextController.text = profileState.profileModel.data.email;
      } else {
        isUserHasEmail = false;
      }
      if (profileState is ProfileLoadedState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: formKey,
            child: Container(
              alignment: Alignment.center,
              clipBehavior: Clip.hardEdge,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                  topRight: Radius.circular(heightRatio(size: 15, context: context)),
                ),
                color: whiteColor,
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: heightRatio(size: 15, context: context)),
                Text(
                  "inputEmailToSendYouCheckText".tr(),
                  style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context)),
                  textAlign: TextAlign.center,
                ),

                // EMAIL WITH VALIDATION
                TextFormField(
                  textAlign: TextAlign.center,
                  validator: (email) => email != null && email != "" && !EmailValidator.validate(email) ? "wrongMailFormatText".tr() : null,
                  controller: emailTextController,
                  style: notEmptyHintTextStyle,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: heightRatio(size: -10, context: context)),
                    hintText: 'your@mail.ru',
                    hintStyle: hintTextStyle,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                Divider(),
                SizedBox(height: heightRatio(size: 15, context: context)),
                InkWell(
                  onTap: () {
                    final _form = formKey.currentState;
                    //Этот if  просто чекает, валидная ли почта или нет
                    if (_form.validate() && emailTextController.text.isNotEmpty) {
                      if (!isUserHasEmail) {
                        _profileBloc.add(ProfileUpdateDataEvent(name: profileState.profileModel.data.name, email: emailTextController.text, phone: profileState.profileModel.data.phone));
                      }

                      Navigator.pop(context, emailTextController.text);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                    child: Text(
                      "Продолжить",
                      style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: whiteColor),
                    ),
                  ),
                ),
                SizedBox(height: heightRatio(size: 30, context: context)),
              ]),
            ),
          ),
        );
      }
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
        ),
      );
    });
  }
}
