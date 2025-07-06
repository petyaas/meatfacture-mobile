import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/smart_contacts_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class HomeIconBottomSheet extends StatelessWidget {
  final String infoText;
  final String promoName;
  final String subtitle;
  final Widget icon;
  const HomeIconBottomSheet({this.infoText, this.promoName, this.subtitle, this.icon});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmartContactsBloc, SmartContactsState>(
      builder: (context, state) {
        if (infoText != null) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: screenHeight(context) * 0.8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: heightRatio(size: 24, context: context)),
                    Center(
                      child: Text(
                        promoName == null ? "" : promoName,
                        style: appHeadersTextStyle(fontSize: heightRatio(size: 20, context: context), color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: heightRatio(size: 17, context: context)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)), color: newIconBg),
                          child: icon,
                        ),
                        SizedBox(width: widthRatio(size: 16, context: context)),
                        Text(
                          subtitle == null ? "" : subtitle,
                          style: appHeadersTextStyle(
                              fontSize: heightRatio(size: 15, context: context), color: Colors.black, height: 1.2, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(height: heightRatio(size: 20, context: context)),
                    Text(
                      infoText,
                      style: appLabelTextStyle(fontSize: heightRatio(size: 15, context: context), color: Colors.grey[700], height: 1.2),
                    ),
                    SizedBox(height: heightRatio(size: 24, context: context)),
                    backBottom(context: context),
                  ],
                ),
              ),
            ),
            // alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                topRight: Radius.circular(heightRatio(size: 15, context: context)),
              ),
            ),
          );
        }
        if (state is SmartContactsLoadedState) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: screenHeight(context) * 0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: heightRatio(size: 25, context: context)),
                  Text("Условия доставки:", style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack)),
                  SizedBox(height: heightRatio(size: 15, context: context)),
                  Text(
                    state.smartContactsModel.data.deliveyInformation,
                    style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: heightRatio(size: 20, context: context)),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                      child: Text(
                        "Продолжить",
                        style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                      ),
                    ),
                  ),
                  SizedBox(height: heightRatio(size: 35, context: context)),
                ],
              ),
            ),
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                topRight: Radius.circular(heightRatio(size: 15, context: context)),
              ),
            ),
          );
        }
        if (state is SmartContactsErrorState) {
          return Container(
            child: Text("errorText".tr()),
            alignment: Alignment.center,
            height: screenHeight(context) / 1.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                topRight: Radius.circular(heightRatio(size: 15, context: context)),
              ),
            ),
          );
        }

        return Container(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(mainColor)),
          alignment: Alignment.center,
          height: 272,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(heightRatio(size: 15, context: context)),
              topRight: Radius.circular(heightRatio(size: 15, context: context)),
            ),
          ),
        );
      },
    );
  }

  Widget backBottom({BuildContext context}) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: heightRatio(size: 20, context: context)),
        alignment: Alignment.center,
        height: heightRatio(size: 57, context: context),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)), color: newBlack),
        child: Text("Понятно", style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context))),
      ),
    );
  }
}
