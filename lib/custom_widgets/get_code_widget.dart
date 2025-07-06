import 'dart:async';

// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/bloc_files/basic_page_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class GetCodeWidget extends StatefulWidget {
  final String phone;

  GetCodeWidget({@required this.phone});

  @override
  _GetCodeWidgetState createState() => _GetCodeWidgetState();
}

class _GetCodeWidgetState extends State<GetCodeWidget> {
  String clearMask(String text) {
    text = text.replaceAll('(', '');
    text = text.replaceAll(')', '');
    text = text.replaceAll(' ', '');
    text = text.replaceAll('-', '');
    return text;
  }

  bool isPincorrect = true;
  final _getTokenByPhoneProvider = GetTokenByPhoneProvider();
  FocusNode _focusNodeForPin = new FocusNode();

  final TextEditingController codeController = TextEditingController();
  final scrollController = ScrollController();

  Future<void> _settokenAndPhone(String token, String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedKeys.token, token);
    await prefs.setString(SharedKeys.phone, phone);
    await prefs.setBool(SharedKeys.isFirstStart, false);
    await prefs.setBool(SharedKeys.popupBetaVersion, false);
  }

  _ontextfuildFocusingedcodePage(bool isvisible) {
    if (isvisible) {
      // scrollController.animateTo(MediaQuery.of(context).size.height,
      //     duration: Duration(milliseconds: 10), curve: Curves.ease);
      // scrollController.jumpTo(
      //   MediaQuery.of(context).size.height / 3,
      // );
    }
  }

  Timer timer;
  int seconds = 10;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        }
      });
    });
  }

  @override
  void initState() {
    _focusNodeForPin.addListener(() {
      setState(() {});
    });
    super.initState();
    _focusNodeForPin.requestFocus();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      _ontextfuildFocusingedcodePage(visible);
    });
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    _focusNodeForPin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
    String _token;
    // ignore: close_sinks
    SecondaryPageBloc _secondaryBloc = BlocProvider.of<SecondaryPageBloc>(context);
    // ignore: close_sinks
    AuthPageBloc _regBloc = BlocProvider.of<AuthPageBloc>(context);
    // ignore: close_sinks
    BasicPageBloc _basicPageBloc = BlocProvider.of<BasicPageBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        _regBloc.add(LoginEvent());
        return false;
      },
      child: Expanded(
        child: SingleChildScrollView(
          controller: scrollController,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenHeight(context) - heightRatio(size: 80, context: context)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
                      child: Text('pleaseConfirmYourPhoneNumberText'.tr() + ' ${widget.phone}', textAlign: TextAlign.center, style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(height: heightRatio(size: 30, context: context)),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 0),
                      child: Focus(
                        onFocusChange: (value) => _ontextfuildFocusingedcodePage(value),
                        child: PinCodeTextField(
                            mainAxisAlignment: MainAxisAlignment.center,
                            autoFocus: true,
                            focusNode: _focusNodeForPin,
                            scrollPadding: EdgeInsets.only(bottom: _focusNodeForPin.hasFocus ? MediaQuery.of(context).viewInsets.bottom : 0),
                            animationType: AnimationType.fade,
                            keyboardType: TextInputType.number,
                            appContext: context,
                            cursorColor: mainColor,
                            obscuringCharacter: '*',
                            obscureText: isPincorrect,
                            enableActiveFill: true,
                            blinkWhenObscuring: true,
                            pinTheme: PinTheme(
                                fieldOuterPadding: EdgeInsets.symmetric(horizontal: 8),
                                fieldHeight: 60,
                                fieldWidth: 50,
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)),
                                disabledColor: isPincorrect ? colorBlack03 : secondColorButtonDisableOrangeGradient,
                                activeFillColor: isPincorrect ? colorBlack03 : secondColorButtonDisableOrangeGradient,
                                inactiveFillColor: isPincorrect ? colorBlack03 : secondColorButtonDisableOrangeGradient,
                                selectedFillColor: isPincorrect ? colorBlack03 : secondColorButtonDisableOrangeGradient,
                                activeColor: isPincorrect ? colorBlack03 : Colors.red,
                                inactiveColor: isPincorrect ? colorBlack03 : Colors.red,
                                selectedColor: isPincorrect ? colorBlack03 : Colors.red,
                                borderWidth: 0),
                            length: 4,
                            controller: codeController,
                            textStyle: appTextStyle(color: isPincorrect ? Colors.black : Colors.red, fontSize: widthRatio(size: 24, context: context)),
                            onChanged: (val) async {
                              setState(() {
                                isPincorrect = true;
                              });
                              if (codeController.text.length == 4) {
                                _focusNodeForPin.requestFocus();
                                // Fluttertoast.showToast(
                                //     msg: 'Подождите...',
                                //     backgroundColor: Colors.grey,
                                //     textColor: Colors.black);
                                _token = await _getTokenByPhoneProvider.getTokenResponse(phone: widget.phone, code: codeController.text);
                                switch (_token) {
                                  case '422':
                                    {
                                      Fluttertoast.showToast(msg: 'codeMustContainAtLeast4DigitsText'.tr(), backgroundColor: Colors.grey, textColor: Colors.black);
                                    }
                                    break;
                                  case '400':
                                    {
                                      setState(() {
                                        isPincorrect = false;
                                      });
                                    }
                                    break;
                                  case 'error':
                                    {
                                      Fluttertoast.showToast(msg: 'errorText'.tr(), backgroundColor: Colors.grey, textColor: Colors.black);
                                    }
                                    break;

                                  default:
                                    {
                                      _settokenAndPhone(
                                          _token,
                                          // "943cc801-569b-4f71-9de0-a53c2111b8ea",
                                          widget.phone);
                                      ProfileProvider().loginResponse();
                                      _profileBloc.add(ProfileLoadEvent());
                                      _secondaryBloc.add(HomeEvent());
                                      timer.cancel();
                                      _basicPageBloc.add(BasicPagesEvent.mainPageEvent);
                                    }
                                }
                              }
                            }),
                      ),
                    ),

                    //get code button
                    SizedBox(height: heightRatio(size: 20, context: context)),
                    // Container(
                    //   margin: const EdgeInsets.only(right: 20, left: 20),
                    //   width: MediaQuery.of(context).size.width,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     gradient: LinearGradient(
                    //         begin: Alignment.centerLeft,
                    //         end: Alignment.centerRight,
                    //         colors: [
                    //           Color.fromRGBO(255, 107, 44, 1),
                    //           Color.fromRGBO(255, 178, 148, 1)
                    //         ]),
                    //   ),
                    //   child: InkWell(
                    //       child: Container(
                    //         alignment: Alignment.center,
                    //         margin: const EdgeInsets.all(13),
                    //         child: Text(
                    //           'Войти',
                    //           style: GoogleFonts.raleway(
                    //               fontSize: 18, color: Colors.white),
                    //         ),
                    //       ),
                    //       onTap: () async {}),
                    // ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !isPincorrect
                            ? Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'wrongCodeText'.tr(),
                                  style: appHeadersTextStyle(fontSize: widthRatio(size: 12, context: context), color: colorBlack04),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(width: widthRatio(size: 10, context: context)),
                        seconds <= 0
                            ? InkWell(
                                onTap: () async {
                                  bool isLogined = await GetCodeByPhoneProvider().getAuthResponse(phone: widget.phone);

                                  if (isLogined) {
                                    setState(() {
                                      seconds = 10;
                                    });
                                    codeController.clear();
                                  } else {
                                    Fluttertoast.showToast(msg: 'errorText'.tr(), backgroundColor: Colors.grey, textColor: Colors.black);
                                  }
                                },
                                child: Text(
                                  'resendCodeText'.tr(),
                                  style: appHeadersTextStyle(color: mainColor, fontSize: widthRatio(size: 14, context: context)),
                                ))
                            : Text('sendAgaenText'.tr() + ' $seconds ' + 'secText'.tr(), style: appHeadersTextStyle(color: colorBlack04, fontSize: widthRatio(size: 14, context: context))),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: heightRatio(size: 100, context: context))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
