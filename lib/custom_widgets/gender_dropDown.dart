import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/core/constants/source.dart';

class GenderDropDown extends StatefulWidget {
  final String sex;
  GenderDropDown({@required this.sex});

  @override
  _GenderDropDownState createState() => _GenderDropDownState(sex: sex);
}

class _GenderDropDownState extends State<GenderDropDown> {
  String _genderChoose;
  final String sex;

  List _gendrsList = ['Мужской', 'Женский'];

  _GenderDropDownState({this.sex});

  @override
  Widget build(BuildContext context) {
    ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
    return Container(
      child: DropdownButton(
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: SizedBox(),
        onChanged: (newval) {
          setState(() {
            _genderChoose = newval;
          });
          if (newval == "maleText".tr()) {
            _profileBloc.add(ProfileUpdateDataEvent(sex: "male"));
          } else {
            _profileBloc.add(ProfileUpdateDataEvent(sex: "female"));
          }
        },
        value: _genderChoose,
        hint: Text(
          sex,
          style: sex != "selectText".tr() ? notEmptyHintTextStyle : hintTextStyle,
        ),
        items: _gendrsList
            .map((valueItem) => DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                ))
            .toList(),
      ),
    );
  }
}
