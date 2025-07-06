// ignore: implementation_imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart/models/loyalty_cards_list_model.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class LoyaltyCardViewBottomSheetWidget extends StatelessWidget {
  final LoyaltyCardsListModel loyaltyCardsListModel;
  final String purchasesSum;

  const LoyaltyCardViewBottomSheetWidget({@required this.loyaltyCardsListModel, @required this.purchasesSum});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(heightRatio(size: 15, context: context)),
        topRight: Radius.circular(heightRatio(size: 15, context: context)),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widthRatio(size: 16, context: context),
          vertical: widthRatio(size: 25, context: context),
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Ваша виртуальная карта",
              style: appHeadersTextStyle(fontSize: heightRatio(size: 20, context: context), color: newBlack),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: heightRatio(size: 20, context: context)),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/newLoyaltyCardBG.png'), fit: BoxFit.cover),
                color: Colors.white,
                borderRadius: BorderRadius.circular(heightRatio(size: 20, context: context)),
              ),
              padding: EdgeInsets.symmetric(
                vertical: heightRatio(size: 26, context: context),
                horizontal: widthRatio(size: 16, context: context),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: heightRatio(size: 110, context: context),
                    width: widthRatio(size: 110, context: context),
                    child: InkWell(
                        onTap: () {
                          showDialog(context: context, barrierDismissible: true, builder: (context) => Dialog(backgroundColor: Colors.transparent, elevation: 30, child: QrImage(data: loyaltyCardsListModel.data[0].number, backgroundColor: Colors.white)));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            child: QrImage(data: loyaltyCardsListModel.data[0].number, size: heightRatio(size: 110, context: context), padding: const EdgeInsets.all(0), backgroundColor: Colors.white),
                          ),
                        )),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset("assets/images/newMFIcon.svg", width: widthRatio(size: 63, context: context), height: heightRatio(size: 48, context: context), fit: BoxFit.contain),
                      // BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
                      //   return state is ProfileLoadedState ? Text(state.profileModel.data.name) : SizedBox();
                      // }),
                      SizedBox(height: heightRatio(size: 20, context: context)),
                      Text(
                        loyaltyCardsListModel.data[0].number,
                        style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newGrey4),
                      ),
                      SizedBox(height: heightRatio(size: 6, context: context)),
                      // Text(
                      //   loyaltyCardsListModel.data[0].name, -- его пока вообще нет
                      //   style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), color: newBlack),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: heightRatio(size: 24, context: context)),
          ],
        ),
      ),
    );
  }
}
