import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/bloc_files/order_calculate_bloc.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/features/addresses/addresses_delivery/bloc/addresses_client_bloc.dart';
import 'package:smart/bloc_files/selected_pay_card_and_address_for_order_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_event.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_state.dart';
import 'package:smart/features/catalog/bloc/catalogs_bloc.dart';
import 'package:smart/features/catalog/cubit/catalog_rebuild_cubit.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/main.dart';
import 'package:smart/models/product_model_for_order_request.dart';
import 'package:smart/pages/init_add_user_address.dart';
import 'package:smart/pages/init_add_my_address_item.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:collection/collection.dart';

// Мои адреса доставки
// 1) из общего каталога -> InitAddUserAddressListIndependent -> AddressesMyDelivery
class AddressesMyDelivery extends StatefulWidget {
  final String cardUuid;
  final String orderType;
  final String payType;
  final String uuid;
  final String payCardNumber;
  final List<ProductModelForOrderRequest> productModelForOrderRequestList;
  final int subtractBonusesCount;
  const AddressesMyDelivery(
      {this.cardUuid, this.orderType, this.productModelForOrderRequestList, this.uuid, this.payType, this.payCardNumber, this.subtractBonusesCount});
  @override
  State<AddressesMyDelivery> createState() => _AddressesMyDeliveryState();
}

class _AddressesMyDeliveryState extends State<AddressesMyDelivery> {
  String selectedStoreUuid;
  String newStoreAddress = "";
  String oldStoreCity = "";
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (selectedStoreUuid == null) {
      final shopState = context.read<AddressesShopBloc>().state;
      if (shopState is LoadedAddressesShopState) {
        selectedStoreUuid = widget.uuid ?? shopState.selectedShop.uuid;
      }
    }
    SelectedPayCardAndAddressForOrderBloc _selectedPayCardAndAddressForOrderBloc = BlocProvider.of(context);
    return BlocBuilder<SelectedPayCardAndAddressForOrderBloc, SelectedPayCardAndAddressForOrderState>(builder: (context, state) {
      if (state is SelectedPayCardAndAddressForOrderLoadedState) {
        return BlocBuilder<AddressesClientBloc, ClientAddressState>(
          builder: (context, clientAddressState) {
            if (clientAddressState is LoadingClientAddressState) {
              return Container(
                height: screenHeight(context) / 2,
                child: Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor))),
              );
            }
            if (clientAddressState is LoadedClientAddressState) {
              if (clientAddressState.clientAddressModelList.isEmpty) {
                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: newRedDark,
                  body: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: heightRatio(size: 5, context: context)),
                        Padding(
                          padding: EdgeInsets.only(left: widthRatio(size: 16, context: context)),
                          child: Text(
                            "Мои адреса доставки",
                            style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: heightRatio(size: 16, context: context)),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                                  topRight: Radius.circular(heightRatio(size: 15, context: context))),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: heightRatio(size: 20, context: context)),
                                  child: Text("orderAddressText".tr(),
                                      style: appTextStyle(fontWeight: FontWeight.w500, fontSize: heightRatio(size: 24, context: context))),
                                ),
                                SvgPicture.asset(
                                  'assets/images/addressIsEmptyIcon.svg',
                                  color: colorBlack03,
                                  height: heightRatio(size: 50, context: context),
                                ),
                                SizedBox(height: heightRatio(size: 10, context: context)),
                                Text("noAddressesAddedText".tr(),
                                    style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: colorBlack04, fontWeight: FontWeight.w500)),
                                InkWell(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => InitAddUserAddress(heightOfBottomNavBar: 60, isNewAddress: true),
                                        ));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(widthRatio(size: 15, context: context)),
                                    padding: EdgeInsets.symmetric(vertical: heightRatio(size: 15, context: context)),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: mainColor),
                                      borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)),
                                    ),
                                    child: Text(
                                      "Добавить новый",
                                      style: appTextStyle(color: mainColor, fontWeight: FontWeight.w500, fontSize: heightRatio(size: 18, context: context)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: newRedDark,
                  body: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: heightRatio(size: 5, context: context)),
                        Padding(
                          padding: EdgeInsets.only(left: widthRatio(size: 16, context: context)),
                          child: Text(
                            "Мои адреса доставки",
                            style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: heightRatio(size: 16, context: context)),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                                  topRight: Radius.circular(heightRatio(size: 15, context: context))),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
                                  child: Text(
                                    'Выберите адрес доставки',
                                    style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                                  ),
                                ),
                                Expanded(
                                  child: Builder(
                                    builder: (context) {
                                      oldStoreCity = clientAddressState.clientAddressModelList[0].city;
                                      return ListView(
                                        children: clientAddressState.clientAddressModelList.mapIndexed(
                                          (index, address) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 17, context: context)),
                                              child: GestureDetector(
                                                onTap: () => setState(() {
                                                  selectedIndex = index;
                                                  selectedStoreUuid = clientAddressState.clientAddressModelList[index].uuid;
                                                  newStoreAddress = clientAddressState.clientAddressModelList[index].city;
                                                  log(index.toString());
                                                  log(clientAddressState.clientAddressModelList[index].uuid);
                                                  log(clientAddressState.clientAddressModelList[index].city);
                                                  log(clientAddressState.clientAddressModelList[index].street);
                                                  // context.read<ClientAddressBloc>().add(SelectClientAddressEvent(selectedUuid));
                                                }),
                                                child: InitAddMyAddressItem(
                                                  isActive: clientAddressState.clientAddressModelList[index].uuid == selectedStoreUuid,
                                                  address:
                                                      "${clientAddressState.clientAddressModelList[index].city}, ${clientAddressState.clientAddressModelList[index].street} ${clientAddressState.clientAddressModelList[index].house == null ? "" : clientAddressState.clientAddressModelList[index].house} ${clientAddressState.clientAddressModelList[index].apartmentNumber == null ? "" : "к${clientAddressState.clientAddressModelList[index].apartmentNumber}"}",
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    Fluttertoast.showToast(msg: "Подождите...");
                                    final selectedAddress = clientAddressState.clientAddressModelList[selectedIndex];
                                    _selectedPayCardAndAddressForOrderBloc.add(SelectedPayCardAndAddressForOrderLoadEvent(
                                      addressindex: 0,
                                      payType: state.payType,
                                      cardUuid: state.cardUuid,
                                      orderType: state.orderType,
                                      addressForDelivery:
                                          "${selectedAddress.city}, ${selectedAddress.street} ${selectedAddress.house ?? ""} ${selectedAddress.apartmentNumber == null ? "" : "к${selectedAddress.apartmentNumber}"}",
                                      apartmentNumber: selectedAddress.apartmentNumber,
                                      floor: selectedAddress.floor,
                                      entrance: selectedAddress.entrance,
                                      intercomCode: selectedAddress.intercomCode,
                                      payCardNumber: widget.payCardNumber,
                                    ));

                                    await AddressesClientProvider().changeClientAddressResponse(
                                      city: selectedAddress.city,
                                      street: selectedAddress.street,
                                      house: selectedAddress.house,
                                      apartmentNumber: selectedAddress.apartmentNumber.toString(),
                                      entrance: selectedAddress.entrance.toString(),
                                      floor: selectedAddress.floor.toString(),
                                      intercomCode: selectedAddress.intercomCode,
                                      title: selectedAddress.title,
                                      addressUuid: selectedAddress.uuid,
                                    );

                                    // Обновляем адреса клиента:
                                    context.read<AddressesClientBloc>().add(SelectAddressesClientEvent(selectedStoreUuid));
                                    log('🏠 Новый адрес::::::::: ${selectedAddress.uuid} ----- ${selectedAddress.title}');
                                    await Future.delayed(Duration(milliseconds: 300));

                                    // Список адресов меняется же на серваке, выбранный становится первым + на всякий -> обновляем его:
                                    // context.read<AddressesClientBloc>().add(LoadedAddressesClientEvent());

                                    log('Старый: $oldStoreCity');
                                    log('Новый: $newStoreAddress');
                                    if (newStoreAddress != "" && newStoreAddress != oldStoreCity) {
                                      log('📍📍 Город доставки у клиента изменился и поэтому запрашиваем магазины и ставим выбранным первый из списка:');
                                      context
                                          .read<AddressesShopBloc>()
                                          .add(ListAddressesShopEvent(notNeedToAskLocationAgain: true, isSetNearestAsSelected: true));
                                      await Future.delayed(Duration(milliseconds: 1500));
                                      String finalSelectedShopUuid = prefs.getString(SharedKeys.shopUuid);
                                      log('🔄 Отправляем событие ProfileUpdateDataEvent с UUID магазина: $finalSelectedShopUuid');
                                      context.read<ProfileBloc>().add(ProfileUpdateDataEvent(selectedStoreUserUuid: finalSelectedShopUuid));
                                      await Future.delayed(Duration(milliseconds: 500));
                                      // Перезапрашиваем каталог:
                                      context.read<CatalogRebuildCubit>().rebuild();
                                      context.read<CatalogsBloc>().add(CatalogsLoadEvent());
                                      // context.read<AssortmentsListBloc>().add(AssortmentsListLoadEvent());

                                      // Перезапрашиваем корзину (так как цены и доступность могут измениться)
                                      // context.read<BasketListBloc>().add(BasketLoadEvent());
                                      log('📍📍');
                                    }
                                    log('ПЕРЕКАЛЬКУЛЯЦИЯ так как адрес изменился'); //стоимость доставки же может изменится
                                    context.read<OrderCalculateBloc>().add(
                                          OrderCalculateLoadEvent(
                                            subtractBonusesCount: widget.subtractBonusesCount,
                                            orderDeliveryTypeId: "delivery",
                                            orderPaymentTypeId: widget.payType,
                                            productModelForOrderRequestList: widget.productModelForOrderRequestList,
                                          ),
                                        );
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                                    width: MediaQuery.of(context).size.width,
                                    height: heightRatio(size: 54, context: context),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                                    child: Text(
                                      'Подтвердить адрес',
                                      style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: heightRatio(size: 8, context: context)),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InitAddUserAddress(heightOfBottomNavBar: 60, isNewAddress: true),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                                    width: MediaQuery.of(context).size.width,
                                    height: heightRatio(size: 54, context: context),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
                                    child: Text(
                                      "Добавить новый адрес",
                                      style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: heightRatio(size: 8, context: context)),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                                    width: MediaQuery.of(context).size.width,
                                    height: heightRatio(size: 54, context: context),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
                                    child: Text(
                                      'Вернуться назад',
                                      style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: heightRatio(size: 30, context: context)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: newRedDark,
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: heightRatio(size: 5, context: context)),
                    Padding(
                      padding: EdgeInsets.only(left: widthRatio(size: 16, context: context)),
                      child: Text(
                        "Мои адреса доставки",
                        style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: heightRatio(size: 16, context: context)),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                            topRight: Radius.circular(heightRatio(size: 15, context: context)),
                          ),
                        ),
                        child: Center(
                          child: Text("errorText".tr()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      return SizedBox();
    });
  }
}
