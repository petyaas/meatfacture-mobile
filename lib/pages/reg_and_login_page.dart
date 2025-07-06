import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/custom_widgets/login_widget.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RegAndLoginPAge extends StatefulWidget {
  const RegAndLoginPAge({Key key}) : super(key: key);

  @override
  State<RegAndLoginPAge> createState() => _RegAndLoginPAgeState();
}

class _RegAndLoginPAgeState extends State<RegAndLoginPAge> {
  @override
  Widget build(BuildContext context) {
    AuthPageBloc _regBloc = BlocProvider.of<AuthPageBloc>(context);
    return BlocBuilder<AuthPageBloc, Widget>(builder: (context, currentState) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.white,
          title: Row(
            mainAxisAlignment: currentState is LoginWidget ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              currentState is LoginWidget
                  ? SizedBox(width: widthRatio(size: 20, context: context))
                  : InkWell(
                      onTap: () => _regBloc.add(LoginEvent()),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: widthRatio(size: 50, context: context),
                        child: Icon(Icons.arrow_back, color: darkcGray),
                      ),
                    ),
              currentState is LoginWidget
                  ? Container(
                      width: widthRatio(size: 110, context: context),
                      child: SvgPicture.asset('assets/images/Logo.svg'),
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: Text("codeFromMessegeText".tr(), style: appTextStyle(color: Colors.black, fontSize: heightRatio(size: 17, context: context), fontWeight: FontWeight.w500)),
                    ),
              SizedBox(width: widthRatio(size: 20, context: context))
            ],
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: BlocBuilder<AuthPageBloc, Widget>(
            builder: (context, currentState) => Container(
              decoration: BoxDecoration(),
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [currentState],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  // void onboardingShowChek() async {
  //   SharedPreferences _shared = await SharedPreferences.getInstance();
  //   bool isFirstStart = _shared.getBool('isFirstStart');

  //   if (_isInit && (isFirstStart == null || isFirstStart != false)) {
  //     SchedulerBinding.instance.addPostFrameCallback((_) {
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingPAge()));
  //     });
  //     _isInit = false;
  //   }
  // }
}
