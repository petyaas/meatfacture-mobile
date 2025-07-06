import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/addresses/addresses_delivery_and_shops.dart';

class AddressesChangeSelectedShopBottomSheet extends StatelessWidget {
  const AddressesChangeSelectedShopBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: heightRatio(size: 30, context: context), left: widthRatio(size: 15, context: context), right: widthRatio(size: 15, context: context)),
      child: Column(
        children: [
          Text(
            "Адрес магазина будет изменен",
            textAlign: TextAlign.center,
            style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), color: newBlack),
          ),
          SizedBox(height: heightRatio(size: 15, context: context)),
          Text(
            "В другом магазине цены на товары из вашей корзины могут отличаться, а некоторых товаров может не быть в наличии",
            textAlign: TextAlign.center,
            style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack, height: 1.3),
          ),
          SizedBox(height: heightRatio(size: 30, context: context)),
          GestureDetector(
            onTap: () async {
              // _shopsBloc.add(MapAddressesShopEvent()); // Пробую это убрать, но если что нужно вернуть
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddressesDeliveryAndShops(
                          hasBackBtn: true,
                          isPopTwice: true,
                        )),
              );
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
              child: Text(
                "Продолжить",
                style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
              ),
            ),
          ),
          SizedBox(height: heightRatio(size: 8, context: context)),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
              child: Text(
                "Вернуться назад",
                style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
              ),
            ),
          ),
          SizedBox(height: heightRatio(size: 34, context: context)),
        ],
      ),
    );
  }
}
