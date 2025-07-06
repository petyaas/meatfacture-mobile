import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/features/addresses/addresses_delivery/bloc/addresses_client_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_event.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_state.dart';
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_model.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/features/catalog/bloc/catalogs_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/features/addresses/addresses_my_delivery.dart';
import 'package:smart/pages/init_add_user_address_item.dart';

// Адрес доставки
// В шапке адрес доставки клиента, а в теле список магазинов
// 1: Из общего каталога при клике на адрес в его шапке
// 2: Из корзины2 при клике на "Доставка из магазина" и "Самовывоз из магазина"
class AddressesDeliveryAndShops extends StatefulWidget {
  final bool hasBackBtn;
  final bool isPopTwice;
  const AddressesDeliveryAndShops({Key key, this.hasBackBtn = false, this.isPopTwice = false}) : super(key: key);

  @override
  State<AddressesDeliveryAndShops> createState() => _AddressesDeliveryAndShopsState();
}

class _AddressesDeliveryAndShopsState extends State<AddressesDeliveryAndShops> {
  int selectedStoreIndex;
  String selectedStoreUuid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('🎨 AddressesDeliveryAndShops');
    final clientAddressState = context.watch<AddressesClientBloc>().state;
    final shopsState = context.watch<AddressesShopBloc>().state;

    if (clientAddressState is LoadingClientAddressState || shopsState is LoadingAddressesShopState) {
      return _buildLoadingScreen();
    }

    if (shopsState is LoadedAddressesShopState) {
      selectedStoreUuid = shopsState.selectedShop.uuid;
      return _buildShopsList(context, shopsState.loadedShopsList.data);
    }

    return _buildErrorScreen();
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: newRedDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddressHeader(context),
            Expanded(
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                    topRight: Radius.circular(heightRatio(size: 15, context: context)),
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 17, context: context), vertical: heightRatio(size: 25, context: context)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Эти магазины доставляют к вам',
                            style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                          ),
                          SizedBox(height: heightRatio(size: 88, context: context)),
                          Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(newRedDark),
                            ),
                          ),
                        ],
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
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text("Ошибка загрузки данных")),
    );
  }

  Widget _buildShopsList(BuildContext context, List<AddressesShopModel> shops) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: newRedDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddressHeader(context),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: heightRatio(size: 25, context: context)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(heightRatio(size: 15, context: context)), topRight: Radius.circular(heightRatio(size: 15, context: context))),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
                      child: Text(
                        'Эти магазины доставляют к вам',
                        style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: heightRatio(size: 40, context: context), left: widthRatio(size: 16, context: context), right: widthRatio(size: 16, context: context)),
                        itemCount: shops.length,
                        itemBuilder: (context, index) {
                          final store = shops[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedStoreUuid = store.uuid;
                                selectedStoreIndex = index;
                              });
                              log('click: $selectedStoreUuid');
                            },
                            child: InitAddUserAddressItem(
                              isActive: selectedStoreIndex != null ? selectedStoreIndex == index : selectedStoreUuid == store.uuid,
                              name: store.address,
                              nameId: store.uuid,
                              time: '${store.workHoursFrom} - ${store.workHoursTill}',
                              price: store.deliveryPrice,
                              thumbnail: store.image != null ? store.image.thumbnails.the1000X1000 : '',
                            ),
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        print('Подтвердить AddressesDeliveryAndShops');

                        if (selectedStoreIndex == null || selectedStoreIndex >= shops.length) {
                          Navigator.pop(context);
                          if (widget.isPopTwice) Navigator.pop(context);
                        } else {
                          final selectedShop = shops[selectedStoreIndex];

                          // Обновляем выбранные адреса:
                          context.read<AddressesClientBloc>().add(SelectAddressesClientEvent(selectedShop.uuid));
                          context.read<AddressesShopBloc>().add(SelectAddressShopEvent(shopUuid: selectedShop.uuid));
                          context.read<ProfileBloc>().add(ProfileUpdateDataEvent(selectedStoreUserUuid: selectedShop.uuid)); // Обновляем магазин в профиле
                          await Future.delayed(Duration(seconds: 1));

                          // Обновляем адреса клиента:
                          context.read<AddressesClientBloc>().add(LoadedAddressesClientEvent());

                          // Перезапрашиваем каталог и ассортимент товаров:
                          context.read<CatalogsBloc>().add(CatalogsLoadEvent());
                          // context.read<AssortmentsListBloc>().add(AssortmentsListLoadEvent());

                          // Перезапрашиваем корзину:
                          context.read<BasketListBloc>().add(BasketLoadEvent());

                          Navigator.pop(context);
                          if (widget.isPopTwice) Navigator.pop(context);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
                        width: MediaQuery.of(context).size.width,
                        height: heightRatio(size: 54, context: context),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                        child: Text(
                          'Подтвердить',
                          style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
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
  }

  Widget _buildAddressHeader(BuildContext context) {
    return BlocBuilder<AddressesClientBloc, ClientAddressState>(
      builder: (context, state) {
        String addressText = "Адрес не выбран";
        if (state is LoadedClientAddressState && state.selectedAddress != null) {
          addressText = (state.selectedAddress.house == null || state.selectedAddress.house == "") ? "${state.selectedAddress.city}, ${state.selectedAddress.street}" : "${state.selectedAddress.city}, ${state.selectedAddress.street} ${state.selectedAddress.house}";
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: heightRatio(size: 5, context: context)),
            widget.hasBackBtn
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 12.5),
                          child: Icon(Icons.arrow_back_ios_new_rounded, size: heightRatio(size: 25, context: context), color: whiteColor),
                        ),
                      ),
                      Text(
                        "Адрес доставки",
                        style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.only(left: widthRatio(size: 17, context: context)),
                    child: Text(
                      "Адрес доставки",
                      style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                      textAlign: TextAlign.left,
                    ),
                  ),
            SizedBox(height: heightRatio(size: 12, context: context)),
            InkWell(
              onTap: () async {
                final basketBloc = context.read<BasketListBloc>();
                final basketState = basketBloc.state;

                if (basketState is BasketLoadedState || basketState is BasketEmptyState) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressesMyDelivery(
                        uuid: (state is LoadedClientAddressState) ? state.selectedAddress.uuid : "",
                        productModelForOrderRequestList: basketState is BasketLoadedState ? basketState.productModelForOrderRequestList : [],
                      ),
                    ),
                  );
                } else {
                  log("Корзина пуста или данные ещё не загружены");
                }
              },
              child: Row(
                children: [
                  SizedBox(width: widthRatio(size: 16, context: context)),
                  SvgPicture.asset(
                    'assets/images/newStorBold.svg',
                    color: Colors.white,
                    height: heightRatio(size: 20, context: context),
                    width: widthRatio(size: 22, context: context),
                  ),
                  SizedBox(width: widthRatio(size: 12, context: context)),
                  Expanded(
                    child: Text(
                      addressText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appLabelTextStyle(color: whiteColor, fontSize: heightRatio(size: 14, context: context)),
                    ),
                  ),
                  SizedBox(width: widthRatio(size: 15, context: context)),
                  Container(
                    height: heightRatio(size: 28, context: context),
                    width: widthRatio(size: 1, context: context),
                    color: white03,
                  ),
                  SizedBox(width: widthRatio(size: 15, context: context)),
                  SvgPicture.asset(
                    "assets/images/newEdit2.svg",
                    height: heightRatio(size: 28, context: context),
                    width: widthRatio(size: 28, context: context),
                    fit: BoxFit.scaleDown,
                  ),
                  SizedBox(width: widthRatio(size: 16, context: context)),
                ],
              ),
            ),
            SizedBox(height: heightRatio(size: 12, context: context)),
          ],
        );
      },
    );
  }
}
