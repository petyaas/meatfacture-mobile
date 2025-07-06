import 'package:easy_localization/src/public_ext.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool isPhoneFull = false;
  bool isPhoneCorrect = true;
  final TextEditingController phoneController = TextEditingController();
  final scrollController = ScrollController();
  double paddingForScroll = 0;

  String clearMask(String text) {
    text = text.replaceAll('(', '');
    text = text.replaceAll(')', '');
    text = text.replaceAll(' ', '');
    text = text.replaceAll('-', '');
    return text;
  }

  FocusNode focus = FocusNode();

  @override
  void initState() {
    focus.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthPageBloc _regBloc = BlocProvider.of<AuthPageBloc>(context);

    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - heightRatio(size: 100, context: context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
                child: Text(
                  "Войдите в свой Профиль Покупателя, чтобы\nполучать больше выгоды и бонусов",
                  textAlign: TextAlign.center,
                  style: appLabelTextStyle(color: newBlack, fontSize: heightRatio(size: 16, context: context), height: 1.5),
                ),
              ),
              SizedBox(height: heightRatio(size: 30, context: context)),
              Container(
                  decoration: BoxDecoration(
                    color: colorBlack03,
                    borderRadius: BorderRadius.circular(heightRatio(size: 15, context: context)),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
                  padding: EdgeInsets.only(top: heightRatio(size: 8, context: context), right: widthRatio(size: 19, context: context), left: widthRatio(size: 23, context: context), bottom: heightRatio(size: 8, context: context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/phoneIcon.svg"),
                      SizedBox(width: widthRatio(size: 19, context: context)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("phoneText".tr(), style: appTextStyle(fontSize: heightRatio(size: 12, context: context), color: colorBlack04)),
                            SizedBox(height: heightRatio(size: 7, context: context)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('+7', style: appHeadersTextStyle(color: isPhoneCorrect ? Colors.black : Colors.red, fontSize: heightRatio(size: 17, context: context))),
                                Flexible(
                                  child: TextField(
                                    focusNode: focus,
                                    scrollPadding: EdgeInsets.only(bottom: focus.hasFocus ? MediaQuery.of(context).viewInsets.bottom : 0),
                                    onChanged: (value) {
                                      setState(() {
                                        isPhoneCorrect = true;
                                        if (phoneController.text.length == 16) {
                                          isPhoneFull = true;
                                        } else {
                                          isPhoneFull = false;
                                        }
                                      });
                                    },
                                    autofocus: true,
                                    inputFormatters: [
                                      TextInputMask(
                                        mask: ' (999) 999-99-99',
                                      )
                                    ],
                                    keyboardType: TextInputType.phone,
                                    controller: phoneController,
                                    style: appHeadersTextStyle(color: isPhoneCorrect ? Colors.black : Colors.red, fontSize: heightRatio(size: 16, context: context)),
                                    decoration: InputDecoration(border: InputBorder.none, isCollapsed: true, counterText: '', contentPadding: EdgeInsets.zero, enabledBorder: InputBorder.none),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: heightRatio(size: 2, context: context)),
                          ],
                        ),
                      ),
                      !isPhoneCorrect ? SvgPicture.asset("assets/images/phoneWarningIcon.svg") : SizedBox(),
                    ],
                  )),
              !isPhoneCorrect
                  ? Container(
                      alignment: Alignment.center,
                      child: Text(
                        'checkCorrectPhone'.tr(),
                        style: appTextStyle(fontSize: heightRatio(size: 12, context: context), color: Colors.red),
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: heightRatio(size: 10, context: context)),

              //get code button
              Container(
                margin: EdgeInsets.only(right: widthRatio(size: 20, context: context), left: widthRatio(size: 20, context: context)),
                width: screenWidth(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(heightRatio(size: 15, context: context)),
                  color: isPhoneFull ? mainColor : secondGradientMainColor.withOpacity(0.2),
                ),
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(widthRatio(size: 20, context: context)),
                    child: Text(
                      'loginText'.tr(),
                      style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: Colors.white),
                    ),
                  ),
                  onTap: () async {
                    if (!isPhoneFull) {
                    } else {
                      setState(() {
                        isPhoneFull = false;
                      });
                      bool isLogined = await GetCodeByPhoneProvider().getAuthResponse(phone: '+7' + clearMask(phoneController.text));

                      if (isLogined) {
                        //_setphoneNumberShared(phoneController.text);
                        _regBloc.add(GetCodeEvent(phone: '+7' + clearMask(phoneController.text)));
                      } else {
                        setState(() {
                          isPhoneCorrect = false;
                        });
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: heightRatio(size: 99, context: context)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    focus.dispose();
    super.dispose();
  }
}
