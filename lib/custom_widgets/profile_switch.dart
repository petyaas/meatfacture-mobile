import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

// ignore: must_be_immutable
class ProfileSwitches extends StatefulWidget {
  final String switchText;
  bool check;
  ProfileSwitches({@required this.switchText, @required this.check});

  @override
  _ProfileSwitchesState createState() => _ProfileSwitchesState();
}

class _ProfileSwitchesState extends State<ProfileSwitches> {
  @override
  Widget build(BuildContext context) {
    bool switchState = widget.check;
    ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.switchText,
          style: appLabelTextStyle(color: newBlack, fontSize: 14),
        ),
        CupertinoSwitch(
          value: switchState,
          activeColor: newGreen32D74B,
          onChanged: (bool val) {
            setState(() {
              widget.check = val;
            });
            if (widget.switchText == "serviceText".tr()) {
              _profileBloc.add(ProfileUpdateDataEvent(consentToServiceNewsletter: val ? 1 : 0));
            }
            if (widget.switchText == "promoText".tr()) {
              _profileBloc.add(ProfileUpdateDataEvent(consentToReceivePromotionalMailings: val ? 1 : 0));
            }
          },
        ),
      ],
    );
  }
}
