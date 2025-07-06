// ignore: implementation_imports
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/bloc_files/onboarding_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class OnboardingPAge extends StatefulWidget {
  @override
  _OnboardingPAgeState createState() => _OnboardingPAgeState();
}

class _OnboardingPAgeState extends State<OnboardingPAge> {
  PageController _pageController;
  int currentPage = 0;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingErrorstate) {
          SchedulerBinding.instance.addPostFrameCallback((_) => Navigator.pop(context));
        }
        if (state is OnboardingLoadedstate) {
          return Scaffold(
            body: Stack(
              children: [
                PageView.builder(
                  onPageChanged: (index) {
                    setState(() => currentPage = index);
                  },
                  controller: _pageController,
                  itemCount: state.onboardingListModel.data.length,
                  itemBuilder: (context, index) {
                    if (screenHeight(context) >= 790)
                      return Container(
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.only(left: widthRatio(size: 20, context: context), right: widthRatio(size: 20, context: context), top: heightRatio(size: 130, context: context), bottom: heightRatio(size: 80, context: context)),
                        // alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 20, context: context)), image: DecorationImage(image: AdvancedNetworkImage(state.onboardingListModel.data[index].logoFilePath, useDiskCache: true), fit: BoxFit.cover)),
                      );
                    else
                      return Container(
                        clipBehavior: Clip.hardEdge,
                        //   child: Image(
                        // image: state.imageList[index],

                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(image: AdvancedNetworkImage(state.onboardingListModel.data[index].logoFilePath, useDiskCache: true), fit: BoxFit.cover),
                        ),
                      );
                  },
                ),
                if (screenHeight(context) >= 790)
                  Positioned(
                    child: Column(
                      children: [
                        // Text('onboarding'),
                        SafeArea(
                          child: SvgPicture.asset("assets/images/Logo.svg", height: screenWidth(context) / 4),
                        ),
                      ],
                    ),
                    top: 0,
                    left: 0,
                    right: 0,
                  ),
                Positioned(
                  child: Padding(
                    padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            state.onboardingListModel.data.length,
                            (index) => InkWell(
                              onTap: () {
                                _pageController.animateToPage(index, duration: Duration(milliseconds: 600), curve: Curves.ease);
                              },
                              child: Container(
                                width: widthRatio(size: 15, context: context),
                                height: heightRatio(size: 15, context: context),
                                margin: EdgeInsets.symmetric(horizontal: screenWidth(context) / widthRatio(size: 40, context: context)),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: currentPage == index ? mainColor : colorBlack04),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: heightRatio(size: 25, context: context)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: mainColor, width: widthRatio(size: 1.5, context: context)), borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context))),
                                  child: Text(
                                    "skipText".tr(),
                                    style: appTextStyle(fontSize: heightRatio(size: 18, context: context), fontWeight: FontWeight.w500, color: mainColor),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: widthRatio(size: 12, context: context)),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (currentPage < state.onboardingListModel.data.length - 1) {
                                    _pageController.animateToPage(currentPage + 1, duration: Duration(milliseconds: 600), curve: Curves.ease);
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context))),
                                  child: Text(
                                    "nextText".tr(),
                                    style: appTextStyle(fontSize: heightRatio(size: 18, context: context), fontWeight: FontWeight.w500, color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  bottom: 0,
                  left: 0,
                  right: 0,
                )
              ],
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(mainColor)),
          );
        }
      },
    );
  }
}
