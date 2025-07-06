import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/bloc_files/diverse_food_bloc.dart';
import 'package:smart/bloc_files/hisory_oder_details_bloc.dart';
import 'package:smart/bloc_files/history_check_details_bloc.dart';
import 'package:smart/services/services.dart';
import 'package:smart/services/ui_services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class SendMarkForProductBottomSheet extends StatefulWidget {
  final String checkUuid;
  final String checkLineUuid;
  final double rating;
  final String comment;
  final String orderOrCheck;

  const SendMarkForProductBottomSheet({@required this.checkLineUuid, @required this.checkUuid, this.rating, this.comment, @required this.orderOrCheck});

  @override
  _SendMarkForProductBottomSheetState createState() => _SendMarkForProductBottomSheetState();
}

class _SendMarkForProductBottomSheetState extends State<SendMarkForProductBottomSheet> {
  final TextEditingController commentTextController = TextEditingController();
  double myRating = 0;
  @override
  void initState() {
    super.initState();

    if (widget.rating != null) {
      myRating = widget.rating;
    }
    if (widget.comment != null) {
      commentTextController.text = widget.comment;
    }
  }

  @override
  Widget build(BuildContext context) {
    HistoryOrdertDetailsBloc _historyOrdertDetailsBloc = BlocProvider.of(context);
    DiverseFoodBloc _diverseFoodBloc = BlocProvider.of(context);
    HistoryCheckDetailsBloc _historyCheckDetailsBloc = BlocProvider.of<HistoryCheckDetailsBloc>(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(heightRatio(size: 15, context: context)),
          topRight: Radius.circular(heightRatio(size: 15, context: context)),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widthRatio(size: 20, context: context),
            vertical: heightRatio(size: 15, context: context),
          ),
          color: whiteColor,
          // height: heightRatio(
          //     size: widget.rating == null ? 310 : 260, context: context),
          child: Column(
            children: [
              SizedBox(height: heightRatio(size: 12, context: context)),
              Text(
                widget.rating == null ? 'Хотите оставить отзыв?' : 'Ваш отзыв',
                style: appHeadersTextStyle(
                  color: Colors.black,
                  fontSize: heightRatio(size: 20, context: context),
                ),
              ),
              SizedBox(height: heightRatio(size: 25, context: context)),
              Container(
                margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 40, context: context)),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //1
                    InkWell(
                      onTap: () {
                        if (widget.rating == null) setState(() => myRating = 1);
                      },
                      child: SvgPicture.asset(
                        myRating > 0 ? 'assets/images/redes_star_big_active.svg' : 'assets/images/redes_star_big.svg',
                        width: widthRatio(size: 30, context: context),
                        height: heightRatio(size: 30, context: context),
                      ),
                    ),
                    //2
                    InkWell(
                      onTap: () {
                        if (widget.rating == null) setState(() => myRating = 2);
                      },
                      child: SvgPicture.asset(
                        myRating > 1 ? 'assets/images/redes_star_big_active.svg' : 'assets/images/redes_star_big.svg',
                        width: widthRatio(size: 30, context: context),
                        height: heightRatio(size: 30, context: context),
                      ),
                    ),

                    //3
                    InkWell(
                      onTap: () {
                        if (widget.rating == null) setState(() => myRating = 3);
                      },
                      child: SvgPicture.asset(
                        myRating > 2 ? 'assets/images/redes_star_big_active.svg' : 'assets/images/redes_star_big.svg',
                        width: widthRatio(size: 30, context: context),
                        height: heightRatio(size: 30, context: context),
                      ),
                    ),
                    //4
                    InkWell(
                      onTap: () {
                        if (widget.rating == null) setState(() => myRating = 4);
                      },
                      child: SvgPicture.asset(
                        myRating > 3 ? 'assets/images/redes_star_big_active.svg' : 'assets/images/redes_star_big.svg',
                        width: widthRatio(size: 30, context: context),
                        height: heightRatio(size: 30, context: context),
                      ),
                    ),
                    //5
                    InkWell(
                      onTap: () {
                        if (widget.rating == null) setState(() => myRating = 5);
                      },
                      child: SvgPicture.asset(
                        myRating > 4 ? 'assets/images/redes_star_big_active.svg' : 'assets/images/redes_star_big.svg',
                        width: widthRatio(size: 30, context: context),
                        height: heightRatio(size: 30, context: context),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: heightRatio(size: 34, context: context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Напишите отзыв о товаре',
                    style: appLabelTextStyle(fontSize: heightRatio(size: 15, context: context), color: newBlack),
                  ),
                ],
              ),
              SizedBox(height: heightRatio(size: 16, context: context)),
              if (widget.rating == null)
                TextField(
                  onChanged: (value) => setState(() {}),
                  textCapitalization: TextCapitalization.sentences,
                  controller: commentTextController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    hintText: 'Укажите ваш комментарий о данном товаре',
                    hintStyle: appLabelTextStyle(color: colorBlack04, fontSize: heightRatio(size: 15, context: context)),
                    border: OutlineInputBorder(borderSide: BorderSide(color: newGrey)),
                  ),
                )
              else
                Container(
                  height: 111,
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.comment ?? "",
                    textAlign: TextAlign.start,
                    style: appLabelTextStyle(fontSize: heightRatio(size: 15, context: context)),
                  ),
                ),
              SizedBox(height: heightRatio(size: 24, context: context)),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
                  child: Text(
                    'Отменить',
                    style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                  ),
                ),
              ),
              SizedBox(height: heightRatio(size: 10, context: context)),
              widget.rating == null
                  ? InkWell(
                      onTap: () async {
                        if (commentTextController.text.length >= 10 && myRating != 0) {
                          if (widget.orderOrCheck == "order") {
                            if (await OrderProvider().setRatingForAssortmentInOrderResponse(orderUuid: widget.checkUuid, orderProductUuid: widget.checkLineUuid, value: myRating, comment: commentTextController.text)) {
                              _diverseFoodBloc.add(DiverseFoodLoadEvent());
                              _historyOrdertDetailsBloc.add(HistoryOrderDetailsLoadEvent(orderId: widget.checkUuid));
                            } else {
                              showSnackBar(context, 'comment_error_text'.tr());
                            }
                          } else {
                            if (await SetRatingForAssortmentProvider().setRatingForAssortmentResponse(receiptUuid: widget.checkUuid, receiptLineUuid: widget.checkLineUuid, value: myRating, comment: commentTextController.text)) {
                              _diverseFoodBloc.add(DiverseFoodLoadEvent());
                              _historyCheckDetailsBloc.add(HistoryCheckDetailsLoadEvent(receiptUuid: widget.checkUuid));
                            } else {
                              showSnackBar(context, 'comment_error_text'.tr());
                            }
                          }

                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(msg: "moreThan10SymbolsText".tr());
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                        child: Text(
                          'Отправить отзыв',
                          style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: heightRatio(size: 16, context: context)),
            ],
          ),
        ),
      ),
    );
  }
}
