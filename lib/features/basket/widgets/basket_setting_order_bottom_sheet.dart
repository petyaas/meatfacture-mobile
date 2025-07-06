import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/basket/widgets/basket_setting_order_btn.dart';
import 'package:smart/main.dart';

class BasketSettingOrderBottomSheet extends StatefulWidget {
  final bool isPickup;
  final VoidCallback onTap;

  const BasketSettingOrderBottomSheet({Key key, @required this.isPickup, @required this.onTap}) : super(key: key);
  @override
  State<BasketSettingOrderBottomSheet> createState() => _BasketSettingOrderBottomSheetState();
}

class _BasketSettingOrderBottomSheetState extends State<BasketSettingOrderBottomSheet> {
  bool isTabCall;
  String typeText;

  @override
  void initState() {
    super.initState();
    isTabCall = prefs.getBool(SharedKeys.basketSettingsIsTabCall) ?? true;
    typeText = prefs.getString(SharedKeys.basketSettingsTypeText) ?? 'Доставить заказ лично';
  }

  @override
  Widget build(BuildContext context) {
    log('isPickup: ${widget.isPickup}');
    double bottomSizedBox = MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : heightRatio(size: 32, context: context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: widthRatio(size: 16, context: context),
        right: widthRatio(size: 16, context: context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: heightRatio(size: 25, context: context)),
          Text(
            'Настройки заказа',
            style: appHeadersTextStyle(fontSize: heightRatio(size: 20, context: context), color: newBlack),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: heightRatio(size: 16, context: context)),
          Text(
            'Что делать если товара нет в наличии',
            style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: heightRatio(size: 12, context: context)),
          ClipRRect(
            borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context)),
            child: Container(
              height: 40,
              decoration: BoxDecoration(color: grey04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        isTabCall = true;
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: isTabCall ? [BoxShadow(color: Colors.black12, offset: Offset(-3, 4), blurRadius: 10, spreadRadius: 0)] : null,
                          borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context)),
                          color: isTabCall ? newRedDark : Colors.transparent,
                        ),
                        child: Text(
                          'Позвонить',
                          textAlign: TextAlign.center,
                          style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: isTabCall ? whiteColor : Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        isTabCall = false;
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: isTabCall ? null : [BoxShadow(color: Colors.black12, offset: Offset(-3, 4), blurRadius: 10, spreadRadius: 0)],
                          borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context)),
                          color: isTabCall ? Colors.transparent : newRedDark,
                        ),
                        child: Text(
                          'Не звонить',
                          style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: isTabCall ? Colors.black : whiteColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: heightRatio(size: 12, context: context)),
          Text(
            isTabCall ? 'Позвонить и согласовать изменение заказа' : 'Удалить товары из заказа',
            style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: heightRatio(size: widget.isPickup ? 40 : 20, context: context)),
          if (!widget.isPickup)
            Column(
              children: [
                Divider(color: grey04, height: 1.8),
                SizedBox(height: heightRatio(size: 20, context: context)),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Оставить заказ у двери?',
                    style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: heightRatio(size: 6, context: context)),
                BasketSettingOrderBtn(
                  title: 'Доставить заказ лично',
                  isActive: typeText == 'Доставить заказ лично' ? true : false,
                  onTap: () {
                    typeText = 'Доставить заказ лично';
                    setState(() {});
                  },
                ),
                BasketSettingOrderBtn(
                  title: 'Оставить у двери и позвонить по телефону',
                  isActive: typeText == 'Оставить у двери и позвонить по телефону' ? true : false,
                  onTap: () {
                    typeText = 'Оставить у двери и позвонить по телефону';
                    setState(() {});
                  },
                ),
                BasketSettingOrderBtn(
                  title: 'Просто оставить заказ у двери',
                  isActive: typeText == 'Просто оставить заказ у двери' ? true : false,
                  onTap: () {
                    typeText = 'Просто оставить заказ у двери';
                    setState(() {});
                  },
                ),
                SizedBox(height: heightRatio(size: 24, context: context)),
              ],
            ),
          InkWell(
            onTap: () async {
              print('Сохранили $isTabCall и $typeText');
              await prefs.setBool(SharedKeys.basketSettingsIsTabCall, isTabCall);
              await prefs.setString(SharedKeys.basketSettingsTypeText, typeText);
              widget.onTap();
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
              child: Text(
                'Сохранить',
                style: appLabelTextStyle(fontSize: heightRatio(size: 18, context: context), color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: bottomSizedBox),
        ],
      ),
    );
  }
}
