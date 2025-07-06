// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

import '../features/basket/bloc/basket_list_bloc.dart';

class SetWeigtForProductInBasketBottomSheet extends StatefulWidget {
  final String productUuid;
  final int gr;
  final int kg;
  final bool isupdate;

  const SetWeigtForProductInBasketBottomSheet({@required this.productUuid, @required this.gr, @required this.kg, @required this.isupdate});

  @override
  State<SetWeigtForProductInBasketBottomSheet> createState() => _SetWeigtForProductInBasketBottomSheetState();
}

class _SetWeigtForProductInBasketBottomSheetState extends State<SetWeigtForProductInBasketBottomSheet> {
  final TextEditingController kgTextController = TextEditingController();
  final TextEditingController grTextController = TextEditingController();
  double kgToAddToBasket = 0;

  @override
  void initState() {
    if (widget.kg != 0) {
      kgTextController.text = widget.kg.toString();
      _selectedKg = widget.kg;
    }
    if (widget.gr != 0) {
      grTextController.text = widget.gr.toString();
      _selectedG = widget.gr ~/ 100;
    }
    super.initState();
  }

  int _selectedKg = 0;
  int _selectedG = 0;
  bool _selectedGOpened = false;
  bool _selectedKgOpened = false;

  @override
  Widget build(BuildContext context) {
    BasketListBloc _basketListBloc = BlocProvider.of<BasketListBloc>(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: heightRatio(size: 280, context: context),
        margin: EdgeInsets.only(bottom: heightRatio(size: 32, context: context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: heightRatio(size: 25, context: context)),
            Text(
              'editWeightOfProductText'.tr(),
              style: appHeadersTextStyle(fontSize: heightRatio(size: 20, context: context), color: newBlack),
            ),
            // Container(
            //   margin: const EdgeInsets.only(left: 25, top: 20, bottom: 2),
            //   child: Text(
            //     'setPrductWeightText'.tr(),
            //     style: GoogleFonts.raleway(color: colorBlack04, fontSize: 14),
            //   ),
            // ),
            SizedBox(height: heightRatio(size: 15, context: context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          padding: EdgeInsets.only(bottom: heightRatio(size: 8, context: context)),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: newGrey, width: widthRatio(size: 1, context: context))),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _selectedKg.toString(),
                                style: appLabelTextStyle(color: _selectedKg == 0 ? newGrey : newBlack, fontSize: heightRatio(size: 18, context: context)),
                              ),
                              Text(
                                "kgText".tr(),
                                style: appLabelTextStyle(color: _selectedKg == 0 ? newGrey : newBlack, fontSize: heightRatio(size: 18, context: context)),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _selectedKgOpened ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: newRedDark,
                          size: heightRatio(size: 24, context: context),
                        ),
                      ],
                    ),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                                  topRight: Radius.circular(heightRatio(size: 15, context: context)),
                                )),
                            padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
                            height: heightRatio(size: 296, context: context),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: heightRatio(size: 220, context: context),
                                  child: CupertinoPicker(
                                    magnification: 1.22,
                                    squeeze: 1.2,
                                    useMagnifier: true,
                                    itemExtent: heightRatio(size: 50, context: context),
                                    scrollController: FixedExtentScrollController(initialItem: _selectedKg),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        _selectedKg = index;
                                      });
                                      kgTextController.text = _selectedKg.toString();
                                    },
                                    children: List.generate(
                                      21,
                                      (index) => Center(
                                        child: Text(
                                          '$index кг',
                                          style: GoogleFonts.roboto(fontSize: heightRatio(size: 18, context: context), fontWeight: FontWeight.w300, color: newBlack),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(top: heightRatio(size: 16, context: context), bottom: heightRatio(size: 19, context: context)),
                                    minimumSize: Size(MediaQuery.of(context).size.width, 0),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    backgroundColor: newRedDark,
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Подтвердить',
                                    style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ).then((value) {
                        setState(() {
                          _selectedKgOpened = false;
                        });
                      });
                      setState(() {
                        _selectedKgOpened = true;
                      });
                    }),
                SizedBox(width: widthRatio(size: 70, context: context)),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      Container(
                        width: widthRatio(size: 72, context: context),
                        padding: EdgeInsets.only(bottom: heightRatio(size: 8, context: context)),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: newGrey, width: 1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _selectedG < 10 ? (_selectedG * 100).toString() : _selectedG.toString(),
                              style: appLabelTextStyle(color: _selectedG == 0 ? newGrey : newBlack, fontSize: heightRatio(size: 18, context: context), fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "grText".tr(),
                              style: appLabelTextStyle(
                                color: _selectedG == 0 ? newGrey : newBlack,
                                fontSize: heightRatio(size: 18, context: context),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _selectedGOpened ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: newRedDark,
                        size: heightRatio(size: 24, context: context),
                      ),
                    ],
                  ),
                  onPressed: () {
                    showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(heightRatio(size: 25, context: context)),
                                topRight: Radius.circular(heightRatio(size: 25, context: context)),
                              )),
                          padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
                          height: heightRatio(size: 296, context: context),
                          child: Column(
                            children: [
                              SizedBox(
                                height: heightRatio(size: 220, context: context),
                                child: CupertinoPicker(
                                  magnification: 1.22,
                                  squeeze: 1.2,
                                  useMagnifier: true,
                                  itemExtent: heightRatio(size: 50, context: context),
                                  scrollController: FixedExtentScrollController(
                                    initialItem: _selectedG,
                                  ),
                                  onSelectedItemChanged: (index) {
                                    setState(() {
                                      _selectedG = index * 100;
                                    });
                                    grTextController.text = _selectedG.toString();
                                  },
                                  children: List.generate(
                                    10,
                                    (index) => Center(
                                      child: Text(
                                        '${index * 100} г',
                                        style: GoogleFonts.roboto(fontSize: heightRatio(size: 18, context: context), fontWeight: FontWeight.w300, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(top: heightRatio(size: 16, context: context), bottom: heightRatio(size: 19, context: context)),
                                  minimumSize: Size(MediaQuery.of(context).size.width, 0),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  backgroundColor: newRedDark,
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Подтвердить',
                                  style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ).then((value) {
                      setState(() {
                        _selectedGOpened = false;
                      });
                    });
                    setState(() {
                      _selectedGOpened = true;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Минимальный вес для заказа 100 гр',
              style: appLabelTextStyle(),
            ),
            SizedBox(height: heightRatio(size: 20, context: context)),
            InkWell(
              onTap: () async {
                kgToAddToBasket = double.parse(kgTextController.text.isEmpty ? "0" : kgTextController.text.replaceAll(",", ".")) + (double.parse(grTextController.text.isEmpty ? "0" : grTextController.text) / 1000);
                if ((kgTextController.text.isEmpty || kgTextController.text == "0") && (grTextController.text.isEmpty || grTextController.text == "0")) {
                  if (await BasketProvider().reomoveProductFromBasket(widget.productUuid)) {
                    _basketListBloc.add(BasketLoadEvent());
                  }
                  Navigator.pop(context, ["0", "0", false]);
                } else {
                  if (widget.isupdate) {
                    if (await BasketProvider().updateProductInBasket(productUuid: widget.productUuid, quantity: kgToAddToBasket)) {
                      _basketListBloc.add(BasketLoadEvent());
                    }
                  } else {
                    if (await BasketProvider().addProductInBasket(widget.productUuid, kgToAddToBasket)) {
                      _basketListBloc.add(BasketLoadEvent());
                    }
                  }
                }
                Navigator.pop(context, [kgTextController.text.replaceAll(",", "."), grTextController.text, true]);
              },
              child: Container(
                // Стиль кнопки
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                child: Text(
                  'Добавить в корзину',
                  style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                ),
              ),
            ),
            SizedBox(height: heightRatio(size: 15, context: context)),
            InkWell(
              onTap: () async {
                // _weightOfProductBloc
                //     .add(WeightOfProductDeleteFromBasketEvent());
                if (await BasketProvider().reomoveProductFromBasket(widget.productUuid)) {
                  _basketListBloc.add(BasketLoadEvent());
                }
                Navigator.pop(context, ["0", "0", false]);
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
                child: Text('Вернуться назад', style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
