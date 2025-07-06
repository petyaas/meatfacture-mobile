import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class AppGenderSelection extends StatefulWidget {
  final String gender;
  AppGenderSelection({@required this.gender});

  @override
  State<AppGenderSelection> createState() => _AppGenderSelectionState(gender: gender);
}

class _AppGenderSelectionState extends State<AppGenderSelection> {
  String _genderChoose;
  final String gender;

  _AppGenderSelectionState({this.gender});

  @override
  void initState() {
    super.initState();
    _genderChoose = gender;
  }

  @override
  Widget build(BuildContext context) {
    ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              _genderChoose = 'male';
              _profileBloc.add(ProfileUpdateDataEvent(sex: "male"));
            });
          },
          child: Container(
            alignment: Alignment.center,
            width: widthRatio(size: 102, context: context),
            height: heightRatio(size: 34, context: context),
            decoration: BoxDecoration(
              border: Border.all(color: _genderChoose == 'male' ? newRedDark : newGrey),
              borderRadius: BorderRadius.circular(5),
              color: _genderChoose == 'male' ? newRedDark : Colors.white,
            ),
            child: Text(
              'Мужской',
              style: appLabelTextStyle(
                color: _genderChoose == 'male' ? Colors.white : newBlack,
                fontSize: heightRatio(size: 14, context: context),
              ),
            ),
          ),
        ),
        SizedBox(width: widthRatio(size: 20, context: context)),
        GestureDetector(
          onTap: () {
            setState(() {
              _genderChoose = 'female';
              _profileBloc.add(ProfileUpdateDataEvent(sex: "female"));
            });
          },
          child: Container(
            alignment: Alignment.center,
            width: widthRatio(size: 102, context: context),
            height: heightRatio(size: 34, context: context),
            decoration: BoxDecoration(
              border: Border.all(color: _genderChoose == 'female' ? newRedDark : newGrey),
              borderRadius: BorderRadius.circular(5),
              color: _genderChoose == 'female' ? newRedDark : Colors.white,
            ),
            child: Text(
              'Женский',
              style: appLabelTextStyle(
                color: _genderChoose == 'female' ? Colors.white : newBlack,
                fontSize: heightRatio(size: 14, context: context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
