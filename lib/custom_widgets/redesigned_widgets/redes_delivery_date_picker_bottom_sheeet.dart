import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RedesDeliveryDatePickerBottomSheet extends StatefulWidget {
  final String titleText;
  final List<String> monthList;

  const RedesDeliveryDatePickerBottomSheet({
    @required this.titleText,
    @required this.monthList,
    // @required this.daysList,
  });

  @override
  State<RedesDeliveryDatePickerBottomSheet> createState() => _RedesDeliveryDatePickerBottomSheetState();
}

class _RedesDeliveryDatePickerBottomSheetState extends State<RedesDeliveryDatePickerBottomSheet> {
  List<String> daysList;
  String _selectedMonth = DateTime.now().month.toString();
  String _selectedDay = DateTime.now().day.toString();

  int getDaysInMonth(int year, int month) {
    var lastDayDate = (month < 12) ? DateTime(year, month + 1, 0) : DateTime(year + 1, 1, 0);
    return lastDayDate.day;
  }

  void setDeliveryDaysList() {
    daysList = [];
    int daysInMonth = getDaysInMonth(DateTime.now().year, int.parse(_selectedMonth));

    if (int.parse(_selectedMonth) == DateTime.now().month) {
      if (int.parse(_selectedDay) < DateTime.now().day) {
        _selectedDay = DateTime.now().day.toString();
      }

      for (var i = DateTime.now().day; i <= daysInMonth; i++) {
        daysList.add(i.toString());
      }
    } else {
      for (var i = 1; i <= daysInMonth; i++) {
        daysList.add(i.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setDeliveryDaysList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(heightRatio(size: 15, context: context)),
      height: screenHeight(context) / 2.5,
      clipBehavior: Clip.hardEdge,
      width: screenWidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(heightRatio(size: 15, context: context)),
          topRight: Radius.circular(heightRatio(size: 15, context: context)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: heightRatio(size: 10, context: context)),
          Text(
            widget.titleText,
            style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), color: newBlack),
          ),
          SizedBox(height: heightRatio(size: 15, context: context)),
          Expanded(
            child: Row(
              children: [
                //day picker
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: heightRatio(size: 50, context: context),
                    onSelectedItemChanged: (value) => _selectedDay = daysList[value],
                    children: daysList
                        .map((e) => Center(
                              child: Text(e, style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context))),
                            ))
                        .toList(),
                  ),
                ),
                //Month picker
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: heightRatio(size: 50, context: context),
                    onSelectedItemChanged: (value) {
                      setState(() {
                        _selectedMonth = widget.monthList[value];
                        setDeliveryDaysList();
                        _selectedDay = daysList.first;
                      });
                    },
                    children: widget.monthList
                        .map((e) => Center(
                              child: Text(
                                getMonthName(month: int.parse(e)),
                                style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context)),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(context, [_selectedMonth, _selectedDay]),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
              child: Text("toChooseText".tr(), style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context))),
            ),
          ),
          SizedBox(height: heightRatio(size: 15, context: context)),
        ],
      ),
    );
  }
}
