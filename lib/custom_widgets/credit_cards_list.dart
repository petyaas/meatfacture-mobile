// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc_files/credit_cards_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'credit_card_details.dart';

class CreditCardsList extends StatelessWidget {
  String getPaySystemByNumber({@required String number}) {
    switch (number[0]) {
      case "2":
        return "assets/images/mir_card.png";

        break;

      case "3":
        switch (number[1]) {
          case "6":
            return "dinersClubText".tr();
            break;
          case "0":
            return "dinersClubText".tr();
            break;

          case "8":
            return "dinersClubText".tr();
            break;
          case "1":
            return "JCBInternationalText".tr();
            break;

          case "5":
            return "JCBInternationalText".tr();
            break;

          case "4":
            return "americanExpressText".tr();
            break;
          case "7":
            return "americanExpressText".tr();
            break;

          default:
            return "";
        }
        break;

      case "4":
        return "assets/images/visa_card.png";
        break;

      case "5":
        switch (number[1]) {
          case "6":
            return "maestroText".tr();
            break;

          case "0":
            return "maestroText".tr();
            break;

          case "7":
            return "maestroText".tr();
            break;

          case "8":
            return "maestroText".tr();
            break;

          case "1":
            return "assets/images/master_card.png";
            break;

          case "2":
            return "assets/images/master_card.png";
            break;

          case "3":
            return "assets/images/master_card.png";
            break;

          case "4":
            return "assets/images/master_card.png";
            break;

          case "5":
            return "assets/images/master_card.png";
            break;

          default:
            return "";
        }
        break;

      case "6":
        switch (number[1]) {
          case "0":
            return "Discover";
            break;

          case "2":
            return "chinaUnionPayText".tr();
            break;

          case "3":
            return "maestroText".tr();
            break;

          case "7":
            return "maestroText".tr();
            break;

          default:
            return "";
        }
        break;

      case "7":
        return "YEKText".tr();
        break;

      default:
        return "";
    }
  }

  void openCardDetailsBottomSheet({BuildContext context, String paySystem, String mask, @required String cardUuid}) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(heightRatio(size: 25, context: context)),
            topRight: Radius.circular(heightRatio(size: 25, context: context)),
          ),
        ),
        builder: (BuildContext bc) {
          return Wrap(
            children: [
              CreditCardDetailsBottomSheet(
                cardUuid: cardUuid,
                mask: mask,
                paySystem: paySystem,
              ),
            ],
          );
        }).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreditCardsListBloc, CreditCardsListState>(
      builder: (context, state) {
        if (state is CreditCardsListLoadedState && state.cardsListModel.data != null && state.cardsListModel.data.isNotEmpty) {
          for (var i = 0; i < state.cardsListModel.data.length; i++) {
            if (state.cardsListModel.data[i].cardMask == null) {
              state.cardsListModel.data.removeAt(i);
              i--;
            }
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: heightRatio(size: 20, context: context)),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: heightRatio(size: 10, context: context)),
                      padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context), vertical: heightRatio(size: 10, context: context)),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)),
                        boxShadow: [BoxShadow(color: newShadow, offset: Offset(6, 6), blurRadius: 12, spreadRadius: 0)],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                getPaySystemByNumber(number: state.cardsListModel.data[index].cardMask),
                                height: heightRatio(size: 28, context: context),
                                errorBuilder: (context, error, stackTrace) => Text(getPaySystemByNumber(number: state.cardsListModel.data[index].cardMask),
                                    style: appTextStyle(fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w500)),
                              ),
                              SizedBox(width: widthRatio(size: 12, context: context)),
                              Text(
                                state.cardsListModel.data[index].cardMask.replaceAll("X", "*").substring(6),
                                style: appLabelTextStyle(fontSize: 16, color: newBlack),
                              ),
                              SizedBox(width: widthRatio(size: 25, context: context)),
                            ],
                          ),
                          InkWell(
                            // onTap: () async {
                            //   if (await CreditCardsProvider().deleteCreditCardResponse(cardUuid: state.cardsListModel.data[index].uuid)) {
                            //     _cardsListBloc.add(CreditCardsListLoadEvent());

                            //     selectedPayCardAndAddressForOrderBloc.add(SelectedPayCardAndAddressForOrderLoadEvent(
                            //       payCardNumber: null,
                            //       cardUuid: null,
                            //       addressForDelivery: null,
                            //       addressindex: null,
                            //       apartmentNumber: null,
                            //       entrance: null,
                            //       floor: null,
                            //       intercomCode: null,
                            //       orderType: null,
                            //       payType: "online",
                            //     ));
                            //   } else {
                            //     Fluttertoast.showToast(msg: "errorText".tr());
                            //   }
                            // },
                            onTap: () => openCardDetailsBottomSheet(
                                cardUuid: state.cardsListModel.data[index].uuid,
                                context: context,
                                mask: state.cardsListModel.data[index].cardMask.replaceAll("X", "*").substring(6),
                                paySystem: getPaySystemByNumber(number: state.cardsListModel.data[index].cardMask)),
                            child: SvgPicture.asset(
                              "assets/images/newTrash.svg",
                              height: heightRatio(size: 26, context: context),
                              width: widthRatio(size: 26, context: context),
                              fit: BoxFit.scaleDown,
                              color: newRedDark,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: state.cardsListModel.data.length),
            ],
          );
        }
        return SizedBox(
          height: 0,
        );
      },
    );
  }
}
