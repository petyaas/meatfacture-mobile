import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/features/addresses/addresses_delivery/bloc/addresses_client_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_event.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_state.dart';
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_model.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/features/catalog/bloc/catalogs_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/features/addresses/addresses_my_delivery.dart';
import 'package:smart/models/product_model_for_order_request.dart';
import 'package:smart/pages/init_add_user_address_item.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

//Адрес доставки2 (Адреса магазинов2 из корзины)
class InitAddUserAddressListCart extends StatefulWidget {
  final String cardUuid;
  final String orderType;
  final String payType;
  final String uuid;
  final String payCardNumber;
  final List<ProductModelForOrderRequest> productModelForOrderRequestList;
  final int subtractBonusesCount;
  const InitAddUserAddressListCart({this.cardUuid, this.orderType, this.productModelForOrderRequestList, this.uuid, this.payType, this.payCardNumber, this.subtractBonusesCount});

  @override
  State<InitAddUserAddressListCart> createState() => _InitAddUserAddressListCartState();
}

class _InitAddUserAddressListCartState extends State<InitAddUserAddressListCart> {
  int selectedIndex;
  String selectedUuid;

  @override
  void initState() {
    super.initState();
    selectedUuid = widget.uuid;
    selectedIndex = 0;
    context.read<AddressesShopBloc>().add(ListAddressesShopEvent());
  }

  @override
  Widget build(BuildContext context) {
    print('🎨 InitAddUserAddressListCart');
    return BlocBuilder<AddressesShopBloc, AddressesShopState>(
      builder: (context, state) {
        if (state is OnMapEmptyAddressesShopState) {
          return _buildEmptyState();
        }
        if (state is LoadingMapAddressesShopState) {
          return _buildLoadingState();
        }
        if (state is LoadingAddressesShopState) {
          return _buildLoadingState();
        }
        if (state is LoadedAddressesShopState) {
          return _buildLoadedState(state.loadedShopsList.data);
        }
        return _buildErrorState();
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(alignment: Alignment.center, color: Colors.white);
  }

  Widget _buildLoadingState() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: newRedDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(heightRatio(size: 15, context: context)), topRight: Radius.circular(heightRatio(size: 15, context: context))),
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
                          Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(newRedDark))),
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

  Widget _buildErrorState() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Center(child: Text("Ошибка загрузки магазинов")),
    );
  }

  Widget _buildLoadedState(List<AddressesShopModel> shopsList) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: newRedDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildShopSelectionList(shopsList),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(height: heightRatio(size: 5, context: context)),
        Row(
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
        ),
        SizedBox(height: heightRatio(size: 12, context: context)),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddressesMyDelivery(
                  productModelForOrderRequestList: widget.productModelForOrderRequestList,
                  payCardNumber: widget.payCardNumber,
                  payType: widget.payType,
                  uuid: widget.uuid,
                  cardUuid: widget.cardUuid,
                  orderType: widget.orderType,
                ),
              ),
            );
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
                child: BlocBuilder<AddressesClientBloc, ClientAddressState>(
                  builder: (context, state) {
                    String addressText = "Адрес не выбран";
                    if (state is LoadedClientAddressState && state.selectedAddress != null) {
                      addressText = (state.selectedAddress.house == null || state.selectedAddress.house == "") ? "${state.selectedAddress.city}, ${state.selectedAddress.street}" : "${state.selectedAddress.city}, ${state.selectedAddress.street} ${state.selectedAddress.house}";
                    }
                    return Text(
                      addressText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appLabelTextStyle(color: whiteColor, fontSize: heightRatio(size: 14, context: context)),
                    );
                  },
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
  }

  Widget _buildShopSelectionList(List<AddressesShopModel> shopsList) {
    return Expanded(
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(heightRatio(size: 15, context: context)), topRight: Radius.circular(heightRatio(size: 15, context: context))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                'Эти магазины доставляют к вам',
                style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 17, context: context)),
                itemCount: shopsList.length,
                itemBuilder: (context, index) {
                  final store = shopsList[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        selectedUuid = store.uuid;
                      });
                      print(selectedIndex);
                      print(selectedUuid);
                    },
                    child: InitAddUserAddressItem(
                      isActive: selectedUuid != null ? store.uuid == selectedUuid : selectedIndex == index,
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
            InkWell(
              onTap: () async {
                print('Подтвердить InitAddUserAddressListCart');

                final selectedShop = shopsList[selectedIndex];
                // Обновляем выбранный магазин:
                context.read<AddressesShopBloc>().add(SelectAddressShopEvent(shopUuid: selectedShop.uuid));
                context.read<ProfileBloc>().add(ProfileUpdateDataEvent(selectedStoreUserUuid: selectedShop.uuid)); // Обновляем магазин в профиле вместо фриза
                await Future.delayed(Duration(seconds: 1));

                // Обновляем адреса клиента:
                context.read<AddressesClientBloc>().add(LoadedAddressesClientEvent());

                // Перезапрашиваем каталог и ассортимент товаров:
                context.read<CatalogsBloc>().add(CatalogsLoadEvent());
                // context.read<AssortmentsListBloc>().add(AssortmentsListLoadEvent());

                // Перезапрашиваем корзину
                context.read<BasketListBloc>().add(BasketLoadEvent());

                print('InitAddUserAddressListCart 🏬 Выбранный магазин: ${selectedShop.uuid} - ${selectedShop.address}');
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 17, context: context)),
                width: MediaQuery.of(context).size.width,
                height: heightRatio(size: 54, context: context),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                child: Text(
                  'Подтвердить',
                  style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                ),
              ),
            ),
            SizedBox(height: heightRatio(size: 24, context: context)),
          ],
        ),
      ),
    );
  }
}
