import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/addresses/addresses_delivery/bloc/addresses_client_bloc.dart';
import 'package:smart/features/addresses/addresses_delivery_and_shops.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_state.dart';
import 'package:smart/features/catalog/bloc/catalogs_bloc.dart';
import 'package:smart/features/catalog/cubit/catalog_rebuild_cubit.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/main.dart';

// Заказ на этот адрес? всплывает в общем каталоге только если isChoosenAddressesForThisSession == 'no'
class CatalogAddressConfirmationDialog extends StatelessWidget {
  final VoidCallback onChangeAddressDelivery;

  const CatalogAddressConfirmationDialog({@required this.onChangeAddressDelivery});

  @override
  Widget build(BuildContext context) {
    String shopAddress;
    String shopLogo;
    String shopUuid;
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.only(
            top: heightRatio(size: 40, context: context),
            left: widthRatio(size: 20, context: context),
            right: widthRatio(size: 20, context: context),
            bottom: heightRatio(size: 0, context: context)),
        title: Text(
          'Заказ на этот адрес?',
          textAlign: TextAlign.center,
          style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), color: newBlack),
        ),
        content: SizedBox(
          height: heightRatio(size: 283, context: context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<AddressesClientBloc, ClientAddressState>(
                builder: (context, clientAddressState) {
                  String deliveryAddress = "Адрес не выбран";
                  if (clientAddressState is LoadedClientAddressState && clientAddressState.selectedAddress != null) {
                    deliveryAddress =
                        "${clientAddressState.selectedAddress.city}, ${clientAddressState.selectedAddress.street} ${clientAddressState.selectedAddress.house ?? ""}";
                  }
                  return Text(
                    deliveryAddress,
                    textAlign: TextAlign.center,
                    style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack),
                  );
                },
              ),
              SizedBox(height: heightRatio(size: 15, context: context)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 6, context: context), vertical: heightRatio(size: 11, context: context)),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
                  boxShadow: [BoxShadow(color: newShadow, offset: Offset(12, 12), blurRadius: 24, spreadRadius: 0)],
                ),
                child: BlocBuilder<AddressesShopBloc, AddressesShopState>(
                  builder: (context, shopState) {
                    if (shopState is LoadedAddressesShopState && shopState.selectedShop != null) {
                      shopUuid = shopState.selectedShop.uuid;
                      shopAddress = shopState.selectedShop.address;
                      shopLogo = shopState.selectedShop.image?.thumbnails?.the1000X1000;
                    } else {
                      shopAddress = "Магазин не выбран";
                    }

                    return Row(
                      children: [
                        shopLogo != null && shopLogo != ""
                            ? Image.network(shopLogo,
                                fit: BoxFit.scaleDown, width: widthRatio(size: 51, context: context), height: heightRatio(size: 42, context: context)) //
                            : SizedBox(width: widthRatio(size: 52, context: context)),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Доставка из магазина:',
                              textAlign: TextAlign.center,
                              style: appHeadersTextStyle(fontSize: heightRatio(size: 12, context: context), color: newBlack),
                            ),
                            SizedBox(height: heightRatio(size: 8, context: context)),
                            SizedBox(
                              width: widthRatio(size: 182, context: context),
                              child: Text(
                                shopAddress,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newBlack),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: heightRatio(size: 30, context: context)),
              InkWell(
                onTap: () async {
                  final profileState = context.read<ProfileBloc>().state;
                  if (profileState is ProfileLoadedState) {
                    log('🏪 Выбранный магазин в профиле: ${profileState.profileModel.data.selectedStoreAddress}');
                    if (profileState.profileModel.data.selectedStoreAddress == null) {
                      log('🏪🏪🏪');
                      context.read<ProfileBloc>().add(ProfileUpdateDataEvent(selectedStoreUserUuid: shopUuid));
                      await Future.delayed(Duration(seconds: 1));
                      // Перезапрашиваем каталог:
                      context.read<CatalogRebuildCubit>().rebuild();
                      context.read<CatalogsBloc>().add(CatalogsLoadEvent());
                    }
                  }
                  await prefs.setString(SharedKeys.isChoosenAddressesForThisSession, 'yes');
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                  child: Text(
                    'Да, перейти к покупкам',
                    style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 14, context: context)),
                  ),
                ),
              ),
              SizedBox(height: heightRatio(size: 8, context: context)),
              InkWell(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddressesDeliveryAndShops()),
                  ) as Map<String, String>;
                  if (result != null) {
                    Navigator.pop(context);
                    onChangeAddressDelivery();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
                  child: Text(
                    'Изменить адрес доставки / магазина',
                    style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 14, context: context)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
