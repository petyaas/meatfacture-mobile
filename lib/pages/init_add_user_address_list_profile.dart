import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smart/features/addresses/addresses_delivery/bloc/addresses_client_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_event.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_state.dart';
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_model.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/features/catalog/bloc/catalogs_bloc.dart';
import 'package:smart/features/addresses/addresses_my_delivery.dart';
import 'package:smart/pages/init_add_user_address_item.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

//Адрес доставки (Адреса магазинов)
class InitAddUserAddressListProfile extends StatefulWidget {
  final List<AddressesShopModel> findNearbyStoreDataModelList;
  final Function(String shopUuid, String shopAddress, String shopLogo) onSave;
  const InitAddUserAddressListProfile({Key key, @required this.findNearbyStoreDataModelList, @required this.onSave}) : super(key: key);

  @override
  State<InitAddUserAddressListProfile> createState() => _InitAddUserAddressListProfileState();
}

class _InitAddUserAddressListProfileState extends State<InitAddUserAddressListProfile> {
  int selectedIndex;
  String selectedUuid;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
    final shopState = context.read<AddressesShopBloc>().state;
    if (shopState is LoadedAddressesShopState) {
      selectedUuid = shopState.selectedShop?.uuid ?? widget.findNearbyStoreDataModelList.first.uuid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: newRedDark,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: heightRatio(size: 5, context: context)),
              Padding(
                padding: EdgeInsets.only(left: widthRatio(size: 17, context: context)),
                child: Text(
                  "Адрес доставки",
                  style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: heightRatio(size: 12, context: context)),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddressesMyDelivery())),
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
                        selectedUuid != null ? widget.findNearbyStoreDataModelList.firstWhere((store) => store.uuid == selectedUuid, orElse: () => null)?.address ?? "notSelectedText".tr() : "notSelectedText".tr(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: appLabelTextStyle(
                          color: whiteColor,
                          fontSize: heightRatio(size: 14, context: context),
                        ),
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
              SizedBox(height: heightRatio(size: 20, context: context)),
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
                      SingleChildScrollView(
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 17, context: context), vertical: heightRatio(size: 25, context: context)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Эти магазины доставляют к вам',
                                  style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                                ),
                                SizedBox(
                                  height: (heightRatio(size: 110, context: context) * widget.findNearbyStoreDataModelList.length).toDouble(),
                                  child: ListView.builder(
                                    itemCount: widget.findNearbyStoreDataModelList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      AddressesShopModel store = widget.findNearbyStoreDataModelList[index];
                                      return InkWell(
                                        onTap: () {
                                          selectedUuid = store.uuid;
                                          selectedIndex = index;
                                          print(selectedIndex);
                                          print(selectedUuid);
                                          setState(() {});
                                        },
                                        child: InitAddUserAddressItem(
                                          isActive: selectedUuid != null ? store.uuid == selectedUuid : selectedIndex == index,
                                          name: '${store.organizationName}, ${store.address}',
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
                                  onTap: () {
                                    final selectedShop = widget.findNearbyStoreDataModelList[selectedIndex];
                                    widget.onSave(
                                      selectedShop.uuid,
                                      selectedShop.address,
                                      selectedShop.image != null && selectedShop.image != "" ? selectedShop.image.thumbnails.the1000X1000 : "",
                                    );
                                    // Обновляем выбранный магазин:
                                    context.read<AddressesShopBloc>().add(SelectAddressShopEvent(shopUuid: selectedShop.uuid));

                                    // Обновляем адреса клиента:
                                    context.read<AddressesClientBloc>().add(LoadedAddressesClientEvent());

                                    // Перезапрашиваем каталог
                                    context.read<CatalogsBloc>().add(CatalogsLoadEvent());
                                    // context.read<AssortmentsListBloc>().add(AssortmentsListLoadEvent());

                                    // Перезапрашиваем корзину (так как цены и доступность могут измениться)
                                    context.read<BasketListBloc>().add(BasketLoadEvent());

                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 37, context: context)),
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
                      ),
                    ],
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
