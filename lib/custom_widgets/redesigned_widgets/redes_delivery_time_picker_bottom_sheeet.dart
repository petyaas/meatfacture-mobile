import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/order_calculate_bloc.dart';
import 'package:smart/custom_widgets/redesigned_widgets/custom_loadable_screen.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class DeliveryTimePickerBottomSheet extends StatefulWidget {
  final String titleText;
  final List<String> timeList;

  const DeliveryTimePickerBottomSheet({@required this.titleText, @required this.timeList, function({String deliveryTimeChoose})});

  @override
  State<DeliveryTimePickerBottomSheet> createState() => _DeliveryTimePickerBottomSheetState();
}

class _DeliveryTimePickerBottomSheetState extends State<DeliveryTimePickerBottomSheet> {
  @override
  Widget build(BuildContext context) {
    String _selectedTime = widget.timeList.isNotEmpty ? widget.timeList.first : null;
    return BlocBuilder<OrderCalculateBloc, OrderCalculateState>(builder: (context, state) {
      return CustomLoadableScreen(
        loading: state is OrderCalculateLoadingState,
        child: Container(
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
          child: state is OrderCalculateLoadedState
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: heightRatio(size: 10, context: context)),
                    Text(
                      widget.titleText,
                      style: appHeadersTextStyle(fontSize: heightRatio(size: 20, context: context), color: newBlack),
                    ),
                    Flexible(
                        child: CupertinoPicker(
                            itemExtent: heightRatio(size: 50, context: context),
                            onSelectedItemChanged: (value) {
                              _selectedTime = widget.timeList[value];
                            },
                            children: widget.timeList
                                .map((e) => Center(
                                      child: Text(e, style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context))),
                                    ))
                                .toList())),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context, _selectedTime);
                      },
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
                )
              : SizedBox(),
        ),
      );
    });
  }
}
