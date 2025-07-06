import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/im_in_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_delivery/bloc/addresses_client_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_event.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_state.dart';
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_model.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/features/catalog/bloc/catalogs_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/main.dart';
import 'package:smart/pages/init_add_user_address_item.dart';
import 'package:smart/pages/redesigned_pages/redes_im_in_shop_page.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RedesImInShopBeforePage extends StatefulWidget {
  const RedesImInShopBeforePage({Key key});

  @override
  State<RedesImInShopBeforePage> createState() => _RedesImInShopBeforePageState();
}

class _RedesImInShopBeforePageState extends State<RedesImInShopBeforePage> {
  int selectedIndex;
  String selectedUuid;

  @override
  void initState() {
    super.initState();
    context.read<AddressesShopBloc>().add(ListAddressesShopEvent());
    final shopState = context.read<AddressesShopBloc>().state;
    if (shopState is LoadedAddressesShopState) {
      selectedUuid = shopState.selectedShop?.uuid ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final _imInShopBloc = context.read<ImInShopBloc>();
    return BlocBuilder<AddressesShopBloc, AddressesShopState>(
      builder: (context, state) {
        if (state is LoadingAddressesShopState) {
          return _buildLoadingScreen();
        }
        if (state is LoadedAddressesShopState) {
          return _buildLoadedScreen(state.loadedShopsList.data, _imInShopBloc);
        }
        return _buildErrorScreen();
      },
    );
  }

  Widget _buildLoadingScreen() {
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                    topRight: Radius.circular(heightRatio(size: 15, context: context)),
                  ),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      height: heightRatio(size: 283, context: context),
                      child: Center(
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(newRedDark)),
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
      body: Center(child: Text("Ошибка загрузки")),
    );
  }

  Widget _buildLoadedScreen(List<AddressesShopModel> shopsList, ImInShopBloc imInShopBloc) {
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
                                'Выберите магазин:',
                                style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                              ),
                              SizedBox(
                                height: (heightRatio(size: 120, context: context) * shopsList.length).toDouble(),
                                child: ListView.builder(
                                  itemCount: shopsList.length,
                                  itemBuilder: (BuildContext context, int index) {
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
                                  final selectedShop = shopsList[selectedIndex];
                                  // Обновляем выбранный магазин:
                                  context.read<AddressesShopBloc>().add(SelectAddressShopEvent(shopUuid: selectedShop.uuid));
                                  context.read<ProfileBloc>().add(ProfileUpdateDataEvent(selectedStoreUserUuid: selectedShop.uuid)); // Обновляем магазин в профиле вместо фриза
                                  await Future.delayed(Duration(seconds: 1));

                                  // Обновляем адреса клиента:
                                  context.read<AddressesClientBloc>().add(LoadedAddressesClientEvent()); //-

                                  // Обновляем состояние "Я в магазине" // TODO узнать у Ивана нужно ли менять в других местах состояние я в магазине при смене магазинов из других экранов
                                  imInShopBloc.add(ImInShopLoadEvent());

                                  // Сохраняем выбор магазина
                                  await prefs.setString(SharedKeys.isChoosenAddressesForThisSessionIamInShop, 'yes');

                                  // Перезапрашиваем каталог и ассортимент товаров:
                                  context.read<CatalogsBloc>().add(CatalogsLoadEvent()); //-
                                  // context.read<AssortmentsListBloc>().add(AssortmentsListLoadEvent()); //-

                                  // Перезапрашиваем корзину
                                  context.read<BasketListBloc>().add(BasketLoadEvent()); //-

                                  print('RedesImInShopBeforePage 🏬 Выбранный магазин: ${selectedShop.uuid} - ${selectedShop.address}');

                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RedesImInShopPage()));
                                },
                                child: Container(
                                  alignment: Alignment.center,
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
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              "Я в магазине",
              style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        SizedBox(height: heightRatio(size: 20, context: context)),
      ],
    );
  }
}
