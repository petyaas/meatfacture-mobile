import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/onboarding_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SecondaryPageBloc>(context);
    OnboardingBloc _onboardingBloc = BlocProvider.of(context);
    _onboardingBloc.add(OnboardingLoadEvent(context: context));
    log('SplashScreen=========');
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
  }
}
