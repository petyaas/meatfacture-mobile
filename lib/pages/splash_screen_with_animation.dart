import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/onboarding_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/pages/landing_page.dart';

class SplashScreenWithAniamtion extends StatefulWidget {
  @override
  State<SplashScreenWithAniamtion> createState() => _SplashScreenWithAniamtionState();
}

class _SplashScreenWithAniamtionState extends State<SplashScreenWithAniamtion> {
  var nowHour = DateTime.now().hour;

  @override
  void initState() {
    Timer(
      ///Время сплеша
      Duration(seconds: 1),
      () {
        setState(
          () {
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => LandingPage(),
            //     ),
            //     (route) => false);
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => LandingPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  // Просто возвращаем child без применения анимации
                  return child;
                },
              ),
              (route) => false,
            );
          },
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🍀');
    OnboardingBloc _onboardingBloc = BlocProvider.of(context);
    _onboardingBloc.add(OnboardingLoadEvent(context: context));
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<AuthPageBloc, Widget>(
          builder: (context, currentState) => Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/splash-bg.jpg"), fit: BoxFit.fill),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoActivityIndicator(radius: 20, color: Colors.white),
                SizedBox(height: 230),
              ],
            ),
          ),
        ),
      );
    });
  }

  // String getGifByHour() {
  //   if (0 <= nowHour && 6 > nowHour) {
  //     return 'assets/json/night.json';
  //   } else if (6 <= nowHour && 12 > nowHour) {
  //     return 'assets/json/morning.json';
  //   } else if (12 <= nowHour && 18 > nowHour) {
  //     return 'assets/json/day.json';
  //   } else {
  //     return 'assets/json/evening.json';
  //   }
  // }
}
