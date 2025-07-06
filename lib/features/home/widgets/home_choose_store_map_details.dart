import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/features/addresses/addresses_delivery/bloc/addresses_client_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_event.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/bloc_files/im_in_shop_bloc.dart';
import 'package:smart/features/catalog/bloc/catalogs_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/bloc_files/shop_details_bloc.dart';
import 'package:smart/custom_widgets/assortment_filter_button.dart';
import 'package:smart/main.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/theme/app_button.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeChooseStoreMapDetails extends StatefulWidget {
  const HomeChooseStoreMapDetails({Key key}) : super(key: key);

  @override
  _HomeChooseStoreMapDetailsState createState() => _HomeChooseStoreMapDetailsState();
}

class _HomeChooseStoreMapDetailsState extends State<HomeChooseStoreMapDetails> {
  Future<String> _loadToken() async => prefs.getString(SharedKeys.token);

  @override
  Widget build(BuildContext context) {
    // ImInShopBloc _imInShopBloc = BlocProvider.of(context);
    // ShopAddressBloc _shopAddressBloc = BlocProvider.of<ShopAddressBloc>(context);
    // BasketListBloc _basketListBloc = BlocProvider.of(context);
    // ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
    return BlocBuilder<ShopDetailsBloc, ShopDetailsState>(
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(heightRatio(size: 15, context: context)),
            topRight: Radius.circular(heightRatio(size: 15, context: context)),
          ),
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: state is ShopDetailLoadingState
                ? Container(
                    alignment: Alignment.center,
                    height: screenHeight(context) / 2,
                    child: CircularProgressIndicator(),
                  )
                : state is ShopDetailsErrorState
                    ? Container(
                        height: screenHeight(context) / 2,
                        alignment: Alignment.center,
                        child: Text('errorText'.tr()),
                      )
                    : state is ShopDetailLoadedgState
                        ? Container(
                            padding: EdgeInsets.only(bottom: heightRatio(size: 25, context: context), top: heightRatio(size: 25, context: context), left: widthRatio(size: 16, context: context), right: widthRatio(size: 16, context: context)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    state.shopDetailsLoadedModel.image != null
                                        ? SizedBox(
                                            height: heightRatio(size: 40, context: context),
                                            width: widthRatio(size: 50, context: context),
                                            child: Image.network(state.shopDetailsLoadedModel.image.path, fit: BoxFit.cover),
                                          )
                                        : SizedBox.shrink(),
                                    state.shopDetailsLoadedModel.image != null ? SizedBox(width: widthRatio(size: 12, context: context)) : SizedBox.shrink(),
                                    Expanded(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(maxHeight: 60),
                                        child: Text(
                                          state.shopDetailsLoadedModel.address,
                                          style: appLabelTextStyle(color: Colors.black, fontSize: heightRatio(size: 16, context: context)),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      child: state.shopDetailsLoadedModel.isFavorite
                                          ? SvgPicture.asset(
                                              'assets/images/active_tape_icon.svg',
                                              height: heightRatio(size: 25, context: context),
                                            )
                                          : SvgPicture.asset(
                                              'assets/images/not_active_tape_icon.svg',
                                              height: heightRatio(size: 25, context: context),
                                              color: mainColor,
                                            ),
                                      onTap: () async {
                                        if (await _loadToken() != "guest") {
                                          if (state.shopDetailsLoadedModel.isFavorite) {
                                            setState(() => state.shopDetailsLoadedModel.isFavorite = false);
                                            if (!await DeleteShopToFavoriteProvider(storeUuid: state.shopDetailsLoadedModel.uuid).getisDeleteShopTofavoriteresponse()) {
                                              Fluttertoast.showToast(msg: "failedToRemoveStorefromFavoritesText".tr());
                                            }
                                          } else {
                                            setState(() => state.shopDetailsLoadedModel.isFavorite = true);
                                            if (!await AddShopToFavoriteProvider(storeUuid: state.shopDetailsLoadedModel.uuid).getisAddShopTofavoriteresponse()) {
                                              Fluttertoast.showToast(msg: "failedToAddStoreToFavoritesText".tr());
                                            }
                                          }
                                        } else {
                                          AssortmentFilterButton().loginOrRegWarning(context);
                                        }
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(height: heightRatio(size: 20, context: context)),
                                Text(
                                  'График работы: ',
                                  style: appHeadersTextStyle(fontSize: heightRatio(size: 15, context: context), color: Colors.black),
                                ),
                                SizedBox(height: heightRatio(size: 6, context: context)),
                                Text(
                                  state.shopDetailsLoadedModel.workHoursFrom != "" ? "everydayText".tr() + " " + state.shopDetailsLoadedModel.workHoursFrom + " - " + state.shopDetailsLoadedModel.workHoursTill : "",
                                  style: appLabelTextStyle(fontSize: heightRatio(size: 15, context: context), color: Colors.black),
                                ),
                                SizedBox(height: heightRatio(size: 30, context: context)),
                                Text(
                                  'Номер телефона:',
                                  style: appHeadersTextStyle(fontSize: heightRatio(size: 15, context: context), color: Colors.black),
                                ),
                                SizedBox(height: heightRatio(size: 6, context: context)),
                                InkWell(
                                  onTap: () {
                                    if (state.shopDetailsLoadedModel.phone != null) {
                                      launchUrl(Uri.parse("tel://${state.shopDetailsLoadedModel.phone}"));
                                    }
                                  },
                                  child: Text(
                                    state.shopDetailsLoadedModel.phone == null ? 'notSpecifiedText'.tr() : state.shopDetailsLoadedModel.phone,
                                    style: appLabelTextStyle(fontSize: heightRatio(size: 15, context: context), color: Colors.black),
                                  ),
                                ),
                                SizedBox(height: heightRatio(size: 30, context: context)),
                                Text(
                                  'Особенности:',
                                  style: appHeadersTextStyle(fontSize: heightRatio(size: 15, context: context), color: Colors.black),
                                ),
                                SizedBox(height: heightRatio(size: 6, context: context)),
                                Text(
                                  [
                                    if (state.shopDetailsLoadedModel.hasAtms) 'Банкомат',
                                    if (state.shopDetailsLoadedModel.hasParking) 'Парковка',
                                    if (state.shopDetailsLoadedModel.hasReadyMeals) 'Готовая еда',
                                  ].join(', '),
                                  style: appLabelTextStyle(fontSize: heightRatio(size: 15, context: context), color: Colors.black),
                                ),
                                SizedBox(height: heightRatio(size: 30, context: context)),
                                Text(
                                  'В корзине могут произойти изменения',
                                  style: appLabelTextStyle(fontSize: heightRatio(size: 15, context: context)),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: heightRatio(size: 15, context: context)),
                                AppButton(
                                  text: 'Выбрать этот магазин',
                                  colorButton: newRedDark,
                                  hasMargin: false,
                                  onPress: () async {
                                    print('HomeChooseStoreMapDetails');
                                    if (await _loadToken() != "guest") {
                                      // Обновляем выбранный магазин:
                                      context.read<AddressesShopBloc>().add(SelectAddressShopEvent(shopUuid: state.shopDetailsLoadedModel.uuid));
                                      context.read<ProfileBloc>().add(ProfileUpdateDataEvent(selectedStoreUserUuid: state.shopDetailsLoadedModel.uuid)); // Обновляем магазин в профиле вместо фриза
                                      await Future.delayed(Duration(seconds: 1));

                                      // Обновляем адреса клиента:
                                      context.read<AddressesClientBloc>().add(LoadedAddressesClientEvent());

                                      // Перезапрашиваем каталог и ассортимент товаров:
                                      context.read<CatalogsBloc>().add(CatalogsLoadEvent());
                                      // context.read<AssortmentsListBloc>().add(AssortmentsListLoadEvent());

                                      // Перезапрашиваем корзину
                                      context.read<BasketListBloc>().add(BasketLoadEvent());

                                      print('InitAddUserAddressListCart 🏬 Выбранный магазин: ${state.shopDetailsLoadedModel.uuid} - ${state.shopDetailsLoadedModel.address}');
                                      Navigator.pop(context);

                                      context.read<BasketListBloc>().add(BasketLoadEvent());
                                      context.read<ImInShopBloc>().add(ImInShopLoadEvent());
                                    } else {
                                      context.read<AddressesShopBloc>().add(SelectAddressShopEvent(shopUuid: state.shopDetailsLoadedModel.uuid));
                                      context.read<ProfileBloc>().add(ProfileAsGuestEvent(shopAddress: state.shopDetailsLoadedModel.address)); // Обновляем магазин в профиле вместо фриза
                                    }
                                    // Перезапрашиваем корзину и я в мгазине:
                                    context.read<BasketListBloc>().add(BasketLoadEvent());
                                    context.read<ImInShopBloc>().add(ImInShopLoadEvent());
                                    Navigator.pop(context);
                                  },
                                ),
                                SizedBox(height: heightRatio(size: 10, context: context)),
                                AppButton(
                                  text: 'Проложить маршрут',
                                  colorButton: newBlack,
                                  hasMargin: false,
                                  onPress: () async {
                                    Fluttertoast.showToast(msg: "Подождите...");
                                    launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=${state.lat},${state.lon}'));
                                  },
                                ),
                              ],
                            ),
                          )
                        : Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
