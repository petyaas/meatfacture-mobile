import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/bloc_files/order_created_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class OrderCreatedBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfileBloc _profileBloc = BlocProvider.of(context);
    SecondaryPageBloc _secondaryPageBloc = BlocProvider.of(context);
    BasketListBloc basketListBloc = BlocProvider.of<BasketListBloc>(context);
    void deleteAllBasket() async {
      await BasketProvider().removeAllBasket() == true ? basketListBloc.add(BasketLoadEvent()) : Fluttertoast.showToast(msg: "errorText".tr());
    }

    return BlocBuilder<OrderCreatedBloc, OrderCreatedState>(
      builder: (context, state) {
        if (state is OrderCreatedLoadedState) {
          _profileBloc.add(ProfileLoadEvent());
          deleteAllBasket();
          return Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(widthRatio(size: 20, context: context)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "yourOrderText".tr() +
                      " ${state.orderCreateResponseModel.data.number == null ? "" : state.orderCreateResponseModel.data.number} " +
                      "HasBeenCompletedText".tr() +
                      "!",
                  style: appTextStyle(fontWeight: FontWeight.w700, fontSize: heightRatio(size: 22, context: context)),
                ),
                SizedBox(height: heightRatio(size: 30, context: context)),
                Text(
                  state.orderCreateResponseModel.data.orderPaymentTypeId == "cash" ? "cashPaymentAtTheCheckoutText".tr() : "PaymentByCardAtTheCheckout".tr(),
                  style: appTextStyle(fontWeight: FontWeight.w700, fontSize: heightRatio(size: 18, context: context)),
                ),
                SizedBox(height: heightRatio(size: 20, context: context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.orderCreateResponseModel.data.totalQuantity.toInt().toString() +
                          " " +
                          getGoodsText(quanity: state.orderCreateResponseModel.data.totalQuantity.toInt().toString()) +
                          ":",
                      style: appTextStyle(fontWeight: FontWeight.w500, fontSize: heightRatio(size: 16, context: context)),
                    ),
                    Text(
                      state.orderCreateResponseModel.data.totalPriceForProductsWithDiscount.toString() + " ${"rubleSignText".tr()}",
                      style: appTextStyle(fontWeight: FontWeight.w500, fontSize: heightRatio(size: 16, context: context)),
                    ),
                  ],
                ),
                SizedBox(height: heightRatio(size: 10, context: context)),
                if (state.orderCreateResponseModel.data.orderDeliveryTypeId == "pickup")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "pickupText".tr(),
                        style: appTextStyle(fontWeight: FontWeight.w500, fontSize: heightRatio(size: 16, context: context)),
                      ),
                      Text(
                        "forFreeText".tr(),
                        style: appTextStyle(fontWeight: FontWeight.w500, fontSize: heightRatio(size: 16, context: context)),
                      )
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Доставка',
                        style: appTextStyle(fontWeight: FontWeight.w500, fontSize: heightRatio(size: 16, context: context)),
                      ),
                      Text(
                        "${state.orderCreateResponseModel.data.deliveryPrice == 0 ? "forFreeText".tr() : state.orderCreateResponseModel.data.deliveryPrice}",
                        style: appTextStyle(fontWeight: FontWeight.w500, fontSize: heightRatio(size: 16, context: context)),
                      )
                    ],
                  ),
                SizedBox(height: heightRatio(size: 5, context: context)),
                if (state.orderCreateResponseModel.data.paidBonus != null && state.orderCreateResponseModel.data.paidBonus != 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Списано ${state.orderCreateResponseModel.data.paidBonus} бонусов",
                        style: appTextStyle(fontWeight: FontWeight.w500, fontSize: heightRatio(size: 16, context: context)),
                      ),
                      Text(
                        "-" + state.orderCreateResponseModel.data.paidBonus.toString() + "" + "rubleSignText".tr(),
                        style: appTextStyle(fontWeight: FontWeight.w500, fontSize: heightRatio(size: 16, context: context)),
                      )
                    ],
                  ),
                SizedBox(height: heightRatio(size: 5, context: context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "totalText".tr() + ":",
                      style: appTextStyle(fontWeight: FontWeight.w600, fontSize: heightRatio(size: 16, context: context)),
                    ),
                    Text(
                      state.orderCreateResponseModel.data.totalPrice.toString() + " " + "rubleSignText".tr(),
                      style: appTextStyle(fontWeight: FontWeight.w500, fontSize: heightRatio(size: 16, context: context)),
                    ),
                  ],
                ),
                SizedBox(height: heightRatio(size: 25, context: context)),
                Text(
                  state.orderCreateResponseModel.data.orderDeliveryTypeId == "pickup" ? "Самовывоз из магазина" : "Доставка курьером",
                  style: appTextStyle(fontWeight: FontWeight.w700, fontSize: heightRatio(size: 18, context: context)),
                ),
                SizedBox(height: heightRatio(size: 15, context: context)),
                Text(
                  state.orderCreateResponseModel.data.storeUserAddress,
                  style: appTextStyle(fontWeight: FontWeight.w300, fontSize: heightRatio(size: 16, context: context)),
                ),
                SizedBox(height: heightRatio(size: 30, context: context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "purchasesText".tr(),
                      style: appTextStyle(fontWeight: FontWeight.w700, fontSize: heightRatio(size: 18, context: context)),
                    ),
                    Text(
                      state.orderCreateResponseModel.data.totalQuantity.toInt().toString() + " " + "товаров",
                      style: appTextStyle(fontWeight: FontWeight.w500, fontSize: heightRatio(size: 14, context: context), color: mainColor),
                    ),
                  ],
                ),
                SizedBox(height: heightRatio(size: 20, context: context)),
                Container(
                  height: heightRatio(size: 100, context: context),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.orderCreateResponseModel.data.products.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: widthRatio(size: 100, context: context),
                        margin: const EdgeInsets.only(right: 5),
                        child: Card(
                          color: Colors.black54,
                          clipBehavior: Clip.hardEdge,
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context))),
                          child: state.orderCreateResponseModel.data.products[index].assortment.images.isNotEmpty
                              ? Image.network(
                                  state.orderCreateResponseModel.data.products[index].assortment.images[0].path,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset("assets/images/notImage.png"),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: heightRatio(size: 25, context: context)),
                InkWell(
                  onTap: () {
                    _secondaryPageBloc.add(HomeEvent());
                    Navigator.of(context).pushNamedAndRemoveUntil(' ', (Route<dynamic> route) => false);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: heightRatio(size: 15, context: context)),
                    alignment: Alignment.center,
                    child: Text("thanksText".tr() + "!",
                        style: appTextStyle(fontWeight: FontWeight.w600, fontSize: heightRatio(size: 18, context: context), color: Colors.white)),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)), color: mainColor),
                  ),
                ),
              ],
            ),
          );
        }
        if (state is OrderCreatedLoadingState) {
          return Container(
            height: heightRatio(size: 400, context: context),
            child: Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor))),
          );
        }

        if (state is OrderCreatedTooFarForAddressErrorState) {
          return Container(
            alignment: Alignment.center,
            height: heightRatio(size: 250, context: context),
            width: screenWidth(context),
            child: Container(
              padding: EdgeInsets.all(widthRatio(size: 20, context: context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.errorText == 'Client address too far for delivering' ? "tooFarForOrderCreatingText".tr() : "paymentErrorFromBloc".tr(),
                    textAlign: TextAlign.center,
                    style: appTextStyle(fontSize: heightRatio(size: 20, context: context)),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: heightRatio(size: 15, context: context)),
                      alignment: Alignment.center,
                      child: Text("Понятно", style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), color: Colors.white)),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)), color: mainColor),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          height: heightRatio(size: 250, context: context),
          child: Center(child: Text("errorText".tr())),
        );
      },
    );
  }

  String getGoodsText({String quanity}) {
    switch (quanity) {
      case "1":
        return "товар";
        break;
      case "2":
        return "товарa";
        break;
      case "3":
        return "товарa";
        break;
      case "4":
        return "товарa";
        break;
      default:
        return "товаров";
    }
  }
}
