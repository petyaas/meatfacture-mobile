import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class BirthdayPicker extends StatefulWidget {
  final String dateFromProfile;

  BirthdayPicker({@required this.dateFromProfile});

  @override
  _BirthdayPickerState createState() => _BirthdayPickerState(dateFromProfile: dateFromProfile);
}

class _BirthdayPickerState extends State<BirthdayPicker> {
  final String dateFromProfile;
  DateTime _birthdayDate;
  DateTime initDateFromProfile;

  _BirthdayPickerState({@required this.dateFromProfile});

  @override
  void initState() {
    super.initState();
    if (dateFromProfile != null) {
      DateTime parsedDate = DateTime.parse(dateFromProfile);
      initDateFromProfile = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
      _birthdayDate = initDateFromProfile;
    }
  }

  String dataAsMonthName(DateTime birthday) {
    String monthName;
    switch (birthday.month) {
      case 1:
        monthName = "januaryText".tr();
        break;
      case 2:
        monthName = "februaryText".tr();
        break;
      case 3:
        monthName = "marchText".tr();
        break;
      case 4:
        monthName = "aprilText".tr();
        break;
      case 5:
        monthName = "mayText".tr();
        break;
      case 6:
        monthName = "juneText".tr();
        break;
      case 7:
        monthName = "julyText".tr();
        break;
      case 8:
        monthName = "augustText".tr();
        break;
      case 9:
        monthName = "septemberText".tr();
        break;
      case 10:
        monthName = "octoberText".tr();
        break;
      case 11:
        monthName = "novemberText".tr();
        break;
      case 12:
        monthName = "decemberText".tr();
        break;
      default:
        monthName = '';
    }

    return "${birthday.day} $monthName ${birthday.year}";
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      locale: const Locale("ru", "RU"),
      context: context,
      initialDate: _birthdayDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 150),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _birthdayDate = date;
      });
      ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
      _profileBloc.add(ProfileUpdateDataEvent(
        birthdayDate: "${_birthdayDate.year}-${_birthdayDate.month.toString().padLeft(2, '0')}-${_birthdayDate.day.toString().padLeft(2, '0')}",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: _pickDate,
        child: Container(
          padding: EdgeInsets.only(bottom: 10),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: newGrey, width: 1)),
          ),
          child: _birthdayDate == null
              ? Text(
                  'Дата рождения',
                  style: appLabelTextStyle(color: newGrey, fontSize: heightRatio(size: 14, context: context)),
                )
              : Text(
                  dataAsMonthName(_birthdayDate),
                  style: appLabelTextStyle(color: newBlack, fontSize: heightRatio(size: 16, context: context)),
                ),
        ),
      ),
    );
  }
}
