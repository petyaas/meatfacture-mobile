import 'dart:async';
import 'dart:developer';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/bloc_files/add_or_subtract_bonuses_bloc.dart';
import 'package:smart/bloc_files/basic_page_bloc.dart';
import 'package:smart/features/addresses/addresses_delivery_and_shops.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_state.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/features/addresses/addresses_delivery/bloc/addresses_client_bloc.dart';
import 'package:smart/bloc_files/order_calculate_bloc.dart';
import 'package:smart/bloc_files/order_type_bloc.dart';
import 'package:smart/features/basket/widgets/basket_setting_order_bottom_sheet.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/bloc_files/shopping_lists_bloc.dart';
import 'package:smart/bloc_files/smart_contacts_bloc.dart';
import 'package:smart/features/basket/basket_screen.dart';
import 'package:smart/features/basket/basket_screen3.dart';
import 'package:smart/features/basket/widgets/basket_address.dart';
import 'package:smart/features/basket/widgets/basket_empty.dart';
import 'package:smart/features/basket/widgets/basket_error.dart';
import 'package:smart/features/basket/widgets/basket_header.dart';
import 'package:smart/features/basket/widgets/basket_total.dart';
import 'package:smart/features/addresses/addresses_my_delivery.dart';
import 'package:smart/custom_widgets/order_type_switch_button.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_delivery_date_picker_bottom_sheeet.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_delivery_time_picker_bottom_sheeet.dart';
import 'package:smart/models/product_model_for_order_request.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/services/services.dart';
import 'package:smart/theme/app_alert.dart';

class BasketScreen2 extends StatefulWidget {
  const BasketScreen2({Key key}) : super(key: key);

  @override
  State<BasketScreen2> createState() => _BasketScreen2State();
}

class _BasketScreen2State extends State<BasketScreen2> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController deliveryAppartmentnumberTextController = TextEditingController();
  final TextEditingController floorTextController = TextEditingController();
  final TextEditingController entranceTextController = TextEditingController();
  final TextEditingController intercomCodeTextController = TextEditingController();
  TextEditingController orderCommentTextController = TextEditingController();
  bool isInited = false;
  bool isInitCalculLoad = true;
  String fromTime;
  String tillTime;
  List<String> deliveryDaysList = [];
  List<String> deliveryMonthsList = [];
  List<ProductModelForOrderRequest> productModelForOrderRequestList = [];
  int getBonusesCount = 0;
  int subtractBonuses = 0;
  String chosenCreditCardUuid;
  List<String> deliveryTimeList = [];
  String orderDeliveryTypeId;
  String _deliveryDayChoose =
      DateTime.now().hour < 18 ? DateTime.now().day.toString() : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1).day.toString();
  String _deliveryMonthChoose =
      DateTime.now().hour < 18 ? DateTime.now().month.toString() : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1).month.toString();
  String _deliveryTimeChoose;
  String _paymentTypeChoose = "online";
  String emailText;
  String deliveryAddress;
  FocusNode focus = FocusNode();

  List<String> _getDeliveryInterval({@required int nowHour, @required int nowMinutes, @required String fromTime, @required String tillTime}) {
    log('🕘 _getDeliveryInterval nowHour=$nowHour, nowMinutes=$nowMinutes, fromTime=$fromTime, tillTime=$tillTime **');
    int _fromTime = fromTime == null ? 8 : int.parse(fromTime.substring(0, 2));
    int _tillTime = tillTime == null ? 20 : int.parse(tillTime.substring(0, 2));
    log('_deliveryDayChoose = $_deliveryDayChoose, _fromTime = $_fromTime, _tillTime = $_tillTime');

    final nowDate = DateTime.now();
    final selectedDate = DateTime(
      nowDate.year,
      int.parse(_deliveryMonthChoose),
      int.parse(_deliveryDayChoose),
    );
    // Если выбранный день — другой день
    if (nowDate.isBefore(selectedDate)) {
      print('Другой день _deliveryDayChoose=$_deliveryDayChoose');
      nowHour = _fromTime;
    } else {
      log('Заказываем на сегодняшний день nowHour:$nowHour, _fromTime=$_fromTime, _tillTime=$_tillTime');

      if (nowHour < _fromTime - 1) {
        print('👉 Еще нет 8ми');
        nowHour = _fromTime;
      } else if (nowHour == _fromTime - 1 && nowMinutes <= 30) {
        print('👉 Еще нет 8:30');
        nowHour = _fromTime;
      } else if (nowHour == _fromTime - 1 && nowMinutes > 30) {
        print('👉 Больше 8:30 но еще нет 9');
        nowHour = _fromTime + 1;
      } else if (nowHour == _fromTime && nowMinutes <= 30) {
        print('👉 Еще нет 9:30');
        nowHour = _fromTime + 1;
      } else if (nowHour == _fromTime && nowMinutes > 30) {
        print('👉 Больше 9:30 но еще нет 10');
        nowHour = _fromTime + 2;
      } else if (nowHour != 17 && nowHour > _fromTime && nowMinutes <= 30) {
        print('👉 Больше 9ч но еще не 17ч и минут <= 30');
        nowHour += 1;
      } else if (nowHour != 17 && nowHour > _fromTime && nowMinutes > 30) {
        print('👉 Больше 9ч но еще не 17ч и минут > 30');
        nowHour += 2;
      } else if (nowHour == 17 && nowMinutes <= 30) {
        print('👉 Уже 17часов но <= 30 минут');
        nowHour = 19;
      } else if (nowHour == 17 && nowMinutes > 30) {
        print('👉 Больше 17:30');
        nowHour = 20;
      }
    }
    List<String> periodList = [];

    log('_getDeliveryInterval nowHour=$nowHour, nowMinutes=$nowMinutes, fromTime=$fromTime, tillTime=$tillTime ****');
    // Генерация интервалов
    for (int i = nowHour; i + 1 <= _tillTime; i++) {
      periodList.add(i < 10 ? "0$i:00 - " + (i + 1 < 10 ? "0${i + 1}:00" : "${i + 1}:00") : "$i:00 - ${i + 1}:00");
    }

    log('🕘 $periodList');
    if (_deliveryTimeChoose == null && periodList.isNotEmpty) {
      _deliveryTimeChoose = periodList[0];
    }
    log('_getDeliveryInterval nowHour=$nowHour, nowMinutes=$nowMinutes, fromTime=$fromTime, tillTime=$tillTime ***********************************************');

    return periodList;
  }

  void setDeliveryDaysList() {
    deliveryDaysList = [];
    if (int.parse(_deliveryMonthChoose) == DateTime.now().month) {
      if (int.parse(_deliveryDayChoose) < DateTime.now().day) {
        _deliveryDayChoose = DateTime.now().day.toString();
      }
      for (var i = DateTime.now().day; i <= 31; i++) {
        deliveryDaysList.add(i.toString());
      }
    } else {
      for (var i = 1; i <= 31; i++) {
        deliveryDaysList.add(i.toString());
      }
    }
  }

  void setDeliveryMontsList() {
    deliveryMonthsList = [];
    for (var i = DateTime.now().month; i <= 12; i++) {
      deliveryMonthsList.add(i.toString());
    }
  }

  bool canMakeOrder = true;

  void checkMakeOrder() {
    if (emailText != "" &&
        _paymentTypeChoose != null &&
        ((deliveryAddress != null && deliveryAddress.length > 4) || orderDeliveryTypeId == "pickup") &&
        (_deliveryTimeChoose != null && _deliveryTimeChoose != "")) {
      canMakeOrder = true;
    } else {
      canMakeOrder = false;
    }
  }

  @override
  void initState() {
    focus.addListener(() {
      setState(() {});
    });
    super.initState();
    setDeliveryDaysList();
    setDeliveryMontsList();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      _ontextfieldFocus(visible);
    });
    initListeners();
  }

  _ontextfieldFocus(bool isvisible) {
    if (isvisible) {}
  }

  // для сохранения домофона подъезда этажа и квартиры: --начало
  String myAddressUuid;
  String myAddressTitle;
  String myAddressCity;
  String myAddressStreet;
  String myAddressHouse;
  Timer _debounce;
  bool _isInitializing = false;
  bool _hasUserInteracted = false; // Флаг для отслеживания меняет что то пользователь или нет
  bool _isAddressUpdateFromInitAddMyAddressList = false; //чтобы при смене адреса в InitAddMyAddressList обратно не отправлять запрос на обновление адреса

  void initListeners() {
    intercomCodeTextController.addListener(() => _onFieldChanged());
    entranceTextController.addListener(() => _onFieldChanged());
    floorTextController.addListener(() => _onFieldChanged());
    deliveryAppartmentnumberTextController.addListener(() => _onFieldChanged());
  }

  void _onFieldChanged() {
    if (_isInitializing || _isAddressUpdateFromInitAddMyAddressList) return; //  та инициализация в билде не является изменением пользователя
    _hasUserInteracted = true; // юзер что то меняет
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(seconds: 2), () {
      if (_hasUserInteracted) {
        log('_onFieldChanged тк _hasUserInteracted=true 🟡 отправка данных только при реальных изменениях _sendUpdatedData');
        _sendUpdatedData();
      }
    });
  }

  Future<void> _sendUpdatedData() async {
    final success = await AddressesClientProvider().changeClientAddressResponse(
      addressUuid: myAddressUuid,
      title: myAddressTitle,
      city: myAddressCity,
      street: myAddressStreet,
      house: myAddressHouse,
      floor: floorTextController.text,
      entrance: entranceTextController.text,
      apartmentNumber: deliveryAppartmentnumberTextController.text,
      intercomCode: intercomCodeTextController.text,
    );
    if (success) {
      context.read<AddressesClientBloc>().add(LoadedAddressesClientEvent());
    } else {
      log('Ошибка при сохранении адреса');
    }
  }
  // для сохранения домофона подъезда этажа и квартиры: --конец

  @override
  Widget build(BuildContext context) {
    BasketListBloc _basketListBloc = BlocProvider.of<BasketListBloc>(context);
    AuthPageBloc authPageBloc = BlocProvider.of(context);
    ShoppingListsBloc _shoppingListsBloc = BlocProvider.of<ShoppingListsBloc>(context);
    BasicPageBloc basicPageBloc = BlocProvider.of(context);
    SmartContactsBloc _smartContactsBloc = BlocProvider.of(context);
    OrderCalculateBloc _orderCalculateBloc = BlocProvider.of<OrderCalculateBloc>(context);
    final now = DateTime.now();

    return BlocBuilder<AddOrSubtractBonusesBloc, AddOrSubtractBonusesState>(
      builder: (context, addOrSubtractBonusesState) {
        return BlocConsumer<BasketListBloc, BasketState>(
          listener: (context, basketListState) {
            if (basketListState is BasketOldTokenState) {
              ProfilePage.logout(basicPageBloc: basicPageBloc, regBloc: authPageBloc);
            }
            if (basketListState is BasketLoadedState) {}
          },
          builder: (context, basketState) {
            if (basketState is BasketLoadedState) {
              tillTime = basketState.orderCalculateResponseModel != null ? basketState.orderCalculateResponseModel.data.workHoursTill : null;
              fromTime = basketState.orderCalculateResponseModel != null ? basketState.orderCalculateResponseModel.data.workHoursFrom : null;
              deliveryTimeList = _getDeliveryInterval(fromTime: fromTime, tillTime: tillTime, nowHour: DateTime.now().hour, nowMinutes: DateTime.now().minute);
              productModelForOrderRequestList = basketState.productModelForOrderRequestList;
              checkMakeOrder();
            }
            bool isNotAvailableToSale = (_deliveryDayChoose == now.day.toString() && _deliveryMonthChoose == now.month.toString()) &&
                (((now.hour == 18) && now.minute >= 00) || (now.hour > 18));
            return BlocBuilder<AddressesClientBloc, ClientAddressState>(
              builder: (context, clientAddressState) {
                if (clientAddressState is LoadedClientAddressState) {
                  final selected = clientAddressState.selectedAddress;
                  if (selected != null) {
                    _isInitializing = true;
                    deliveryAddress =
                        "${selected.city}, ${selected.street} ${selected.house} ${selected.apartmentNumber == null ? "" : "к ${selected.apartmentNumber}"}";

                    myAddressUuid = selected.uuid;
                    myAddressTitle = selected.title;
                    myAddressCity = selected.city;
                    myAddressStreet = selected.street;
                    myAddressHouse = selected.house;

                    intercomCodeTextController.text = selected.intercomCode ?? "";
                    entranceTextController.text = selected.entrance?.toString() ?? "";
                    floorTextController.text = selected.floor?.toString() ?? "";
                    deliveryAppartmentnumberTextController.text = selected.apartmentNumber?.toString() ?? "";

                    log("✏️ Адрес клиента: ${selected}");
                    log("✏️ Домофон: ${selected.intercomCode}");
                    log("✏️ Подъезд: ${selected.entrance}");
                    log("✏️ Этаж: ${selected.floor}");
                    log("✏️ Квартира: ${selected.apartmentNumber}");

                    _isInitializing = false;
                  }
                }

                return BlocBuilder<OrderTypeBloc, OrderTypeState>(
                  builder: (context, orderTypeState) {
                    if (orderTypeState is OrderTypeDeliveryState) {
                      orderDeliveryTypeId = "delivery";
                      log('🌱 delivery delivery delivery delivery delivery delivery delivery delivery delivery');
                      if (productModelForOrderRequestList.isNotEmpty && isInitCalculLoad) {}
                      checkMakeOrder();
                    } else {
                      orderDeliveryTypeId = "pickup";
                      log('🌱 pickup pickup pickup pickup pickup pickup pickup pickup pickup pickup pickup pickup');
                      if (productModelForOrderRequestList.isNotEmpty && isInitCalculLoad) {}

                      checkMakeOrder();
                    }
                    // Корзина 2
                    return Scaffold(
                      resizeToAvoidBottomInset: false,
                      bottomNavigationBar: BlocBuilder<OrderCalculateBloc, OrderCalculateState>(
                        builder: (context, calculateState) {
                          if (calculateState is! OrderCalculateErrorState) {
                            return Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(bottom: heightRatio(size: 20, context: context), top: heightRatio(size: 2, context: context)),
                              child: InkWell(
                                onTap: () async {
                                  if (isNotAvailableToSale) {
                                    AppAlert.show(
                                      context: context,
                                      message: "Заказы на сегодняшний день принимаются только до 18:00",
                                      sec: 2,
                                    );
                                  } else {
                                    await showModalBottomSheet<dynamic>(
                                      isScrollControlled: true,
                                      useSafeArea: true,
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(heightRatio(size: 25, context: context)),
                                          topRight: Radius.circular(heightRatio(size: 25, context: context)),
                                        ),
                                      ),
                                      builder: (BuildContext bc) {
                                        log('orderDeliveryTypeId::::::::::::::::: $orderDeliveryTypeId');
                                        return Wrap(
                                          children: [
                                            BasketSettingOrderBottomSheet(
                                              isPickup: orderDeliveryTypeId == "pickup" ? true : false,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => BasketScreen3(
                                                      basketState: basketState,
                                                      canMakeOrder: canMakeOrder,
                                                      deliveryAddress: deliveryAddress,
                                                      emailText: emailText,
                                                      orderDeliveryTypeId: orderDeliveryTypeId,
                                                      paymentTypeChoose: _paymentTypeChoose,
                                                      deliveryAppartmentNumber: deliveryAppartmentnumberTextController.text,
                                                      orderComment: orderCommentTextController.text,
                                                      entrance: entranceTextController.text,
                                                      floor: floorTextController.text,
                                                      intercomCode: intercomCodeTextController.text,
                                                      payType: "online", //selectedPayCardAndAddressForOrderState.payType,
                                                      deliveryTimeChoose: _deliveryTimeChoose,
                                                      deliveryDayChoose: _deliveryDayChoose,
                                                      deliveryMonthChoose: _deliveryMonthChoose,
                                                      subtractBonuses: subtractBonuses,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: heightRatio(size: 15, context: context)),
                                  margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
                                  width: double.maxFinite,
                                  height: heightRatio(size: 54, context: context),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                                  child: Text(
                                    orderTypeState is OrderTypePickupState ? 'Подтвердить' : 'Оплатить',
                                    style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                      body: Container(
                        color: newRedDark,
                        child: SafeArea(
                          child: Container(
                            child: Column(
                              children: [
                                BasketHeader(
                                    basketListBloc: _basketListBloc,
                                    shoppingListsBloc: _shoppingListsBloc,
                                    smartContactsBloc: _smartContactsBloc,
                                    basketState: basketState,
                                    isBasket: false),
                                if (basketState is BasketEmptyState) //в корзине нет товаров
                                  BasketEmpty(decorationForContent: _decorationForContent)
                                else if (basketState is BasketLoadingState)
                                  Expanded(
                                    child: Container(
                                      decoration: _decorationForContent(context),
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(newRedDark)),
                                    ),
                                  )
                                else if (basketState is BasketErrorState)
                                  BasketError(basketListBloc: _basketListBloc, decorationForContent: _decorationForContent)
                                else
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                                              topRight: Radius.circular(heightRatio(size: 15, context: context)),
                                            ),
                                          ),
                                          alignment: Alignment.topLeft,
                                          padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 3, context: context)),
                                          child: SingleChildScrollView(
                                            controller: _scrollController,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: heightRatio(size: 25, context: context)),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  orderTypeState is OrderTypePickupState
                                                      // Самовывоз:
                                                      ? Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            InkWell(
                                                              onTap: () => Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => BasketScreen(basketNavKey: GlobalKey<NavigatorState>())),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(width: widthRatio(size: 18, context: context)),
                                                                  SvgPicture.asset("assets/images/newBack.svg",
                                                                      height: heightRatio(size: 16, context: context),
                                                                      width: widthRatio(size: 8, context: context),
                                                                      color: newBlack,
                                                                      fit: BoxFit.scaleDown),
                                                                  SizedBox(width: widthRatio(size: 16, context: context)),
                                                                  Text('Вернуться назад',
                                                                      style: appHeadersTextStyle(
                                                                          fontSize: heightRatio(size: 16, context: context), color: newBlack)),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: heightRatio(size: 16, context: context)),
                                                            if (basketState is BasketLoadedState)
                                                              Padding(
                                                                padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                                                                child: OrderTypeSwitchButton(
                                                                  //кнопки доставка и самовывоз
                                                                  addOrSubtractBonusesState: addOrSubtractBonusesState,
                                                                  subtractBonuses: subtractBonuses,
                                                                  paymentTypeChoose: _paymentTypeChoose,
                                                                  productModelForOrderRequestList: productModelForOrderRequestList,
                                                                ),
                                                              ),
                                                            SizedBox(height: heightRatio(size: 25, context: context)),
                                                            // Самовывоз из магазина:
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) => AddressesDeliveryAndShops(hasBackBtn: true)),
                                                                  );
                                                                },
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "Самовывоз из магазина:",
                                                                      style: appHeadersTextStyle(
                                                                          fontSize: heightRatio(size: 16, context: context), color: newBlack),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                      children: [
                                                                        Flexible(
                                                                          child: BlocBuilder<AddressesShopBloc, AddressesShopState>(
                                                                            builder: (context, shopState) {
                                                                              String shopAddress = "Магазин не выбран";
                                                                              if (shopState is LoadedAddressesShopState && shopState.selectedShop != null) {
                                                                                shopAddress = shopState.selectedShop.address;
                                                                              }
                                                                              return Text(
                                                                                shopAddress,
                                                                                style: appLabelTextStyle(
                                                                                    fontSize: heightRatio(size: 14, context: context), color: newBlackLight),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                        SvgPicture.asset("assets/images/newEdit.svg",
                                                                            height: heightRatio(size: 26, context: context),
                                                                            width: widthRatio(size: 26, context: context),
                                                                            fit: BoxFit.scaleDown),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: heightRatio(size: 20, context: context)),
                                                            //когда заберете (самовывоз)
                                                            Container(
                                                              margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                                                              padding: EdgeInsets.all(16),
                                                              decoration: BoxDecoration(
                                                                color: whiteColor,
                                                                borderRadius: BorderRadius.circular(12),
                                                                boxShadow: [
                                                                  BoxShadow(color: newShadow, offset: Offset(12, 12), blurRadius: 24, spreadRadius: 0)
                                                                ],
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text("whenYouPickText".tr(),
                                                                      style: appHeadersTextStyle(
                                                                          fontSize: heightRatio(size: 16, context: context), color: newBlack)),
                                                                  SizedBox(height: heightRatio(size: 8, context: context)),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text("pickupDateText".tr(),
                                                                              style: appLabelTextStyle(
                                                                                  fontSize: heightRatio(size: 12, context: context), color: newGrey)),
                                                                          SizedBox(height: heightRatio(size: 10, context: context)),
                                                                          InkWell(
                                                                            onTap: () async {
                                                                              FocusScope.of(context).unfocus();
                                                                              final List<String> _deliveryDateResult = await showModalBottomSheet<dynamic>(
                                                                                  isScrollControlled: true,
                                                                                  useSafeArea: true,
                                                                                  context: context,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.only(
                                                                                      topLeft: Radius.circular(heightRatio(size: 25, context: context)),
                                                                                      topRight: Radius.circular(heightRatio(size: 25, context: context)),
                                                                                    ),
                                                                                  ),
                                                                                  builder: (BuildContext bc) {
                                                                                    return Wrap(children: [
                                                                                      RedesDeliveryDatePickerBottomSheet(
                                                                                          titleText: "Дата самовывоза", monthList: deliveryMonthsList),
                                                                                    ]);
                                                                                  });
                                                                              if (_deliveryDateResult != null) {
                                                                                setState(() {
                                                                                  _deliveryMonthChoose = _deliveryDateResult[0];
                                                                                  _deliveryDayChoose = _deliveryDateResult[1];
                                                                                  deliveryTimeList = _getDeliveryInterval(
                                                                                      fromTime: fromTime,
                                                                                      tillTime: tillTime,
                                                                                      nowHour: DateTime.now().hour,
                                                                                      nowMinutes: DateTime.now().minute);
                                                                                  _deliveryTimeChoose = deliveryTimeList[0];
                                                                                });
                                                                                _orderCalculateBloc.add(
                                                                                  OrderCalculateLoadEvent(
                                                                                    orderDeliveryTypeId: orderDeliveryTypeId,
                                                                                    orderPaymentTypeId: "online",
                                                                                    productModelForOrderRequestList: productModelForOrderRequestList,
                                                                                  ),
                                                                                );
                                                                              }
                                                                            },
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Container(
                                                                                  width: widthRatio(size: 55, context: context),
                                                                                  decoration: BoxDecoration(
                                                                                      border: Border(bottom: BorderSide(color: grey04, width: 1))),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text(
                                                                                        _deliveryDayChoose,
                                                                                        style: appLabelTextStyle(
                                                                                            fontSize: heightRatio(size: 16, context: context), color: newBlack),
                                                                                      ),
                                                                                      Icon(Icons.arrow_drop_down, color: newBlackLight),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: widthRatio(size: 16, context: context)),
                                                                                Container(
                                                                                  width: widthRatio(size: 55, context: context),
                                                                                  decoration: BoxDecoration(
                                                                                      border: Border(bottom: BorderSide(color: grey04, width: 1))),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text(
                                                                                        _deliveryMonthChoose,
                                                                                        style: appLabelTextStyle(
                                                                                            fontSize: heightRatio(size: 16, context: context), color: newBlack),
                                                                                      ),
                                                                                      Icon(Icons.arrow_drop_down, color: newBlackLight),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Время самовывоза",
                                                                            style: appLabelTextStyle(
                                                                                fontSize: heightRatio(size: 12, context: context), color: newGrey),
                                                                          ),
                                                                          SizedBox(height: heightRatio(size: 10, context: context)),
                                                                          InkWell(
                                                                            onTap: () async {
                                                                              if (isNotAvailableToSale) {
                                                                                log('InkWell не кликабельный в это время, так как после 18:00 не принимаются заказы');
                                                                                Fluttertoast.showToast(msg: "selectAnotherDayText".tr());
                                                                                return;
                                                                              }
                                                                              FocusScope.of(context).unfocus();
                                                                              if (deliveryTimeList.isNotEmpty) {
                                                                                final String _deliverytimeResult = await showModalBottomSheet<dynamic>(
                                                                                    isScrollControlled: true,
                                                                                    useSafeArea: true,
                                                                                    context: context,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.only(
                                                                                        topLeft: Radius.circular(heightRatio(size: 25, context: context)),
                                                                                        topRight: Radius.circular(heightRatio(size: 25, context: context)),
                                                                                      ),
                                                                                    ),
                                                                                    builder: (BuildContext bc) {
                                                                                      return Wrap(children: [
                                                                                        DeliveryTimePickerBottomSheet(
                                                                                            timeList: deliveryTimeList, titleText: 'chooseInterval'.tr()),
                                                                                      ]); //deliveryTimeList.sublist(1)
                                                                                    });
                                                                                if (_deliverytimeResult != null) {
                                                                                  setState(() {
                                                                                    _deliveryTimeChoose = _deliverytimeResult;
                                                                                  });
                                                                                  _orderCalculateBloc.add(
                                                                                    OrderCalculateLoadEvent(
                                                                                      orderDeliveryTypeId: orderDeliveryTypeId,
                                                                                      orderPaymentTypeId: "online",
                                                                                      productModelForOrderRequestList: productModelForOrderRequestList,
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              } else {
                                                                                Fluttertoast.showToast(msg: "selectAnotherDayText".tr());
                                                                              }
                                                                            },
                                                                            child: Container(
                                                                              width: widthRatio(size: 120, context: context),
                                                                              decoration:
                                                                                  BoxDecoration(border: Border(bottom: BorderSide(color: grey04, width: 1))),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  isNotAvailableToSale
                                                                                      ? SizedBox.shrink()
                                                                                      : Text(
                                                                                          _deliveryTimeChoose == null
                                                                                              ? deliveryTimeList.isEmpty
                                                                                                  ? ""
                                                                                                  : deliveryTimeList[0]
                                                                                              : _deliveryTimeChoose, //доставка
                                                                                          style: appLabelTextStyle(
                                                                                              fontSize: heightRatio(size: 16, context: context),
                                                                                              color: newBlack),
                                                                                        ),
                                                                                  Icon(Icons.arrow_drop_down, color: newBlackLight),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )
                                                                          // )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      // Доставка
                                                      : Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            InkWell(
                                                              onTap: () => Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => BasketScreen(basketNavKey: GlobalKey<NavigatorState>())),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(width: widthRatio(size: 18, context: context)),
                                                                  SvgPicture.asset(
                                                                    "assets/images/newBack.svg",
                                                                    height: heightRatio(size: 16, context: context),
                                                                    width: widthRatio(size: 8, context: context),
                                                                    color: newBlack,
                                                                    fit: BoxFit.scaleDown,
                                                                  ),
                                                                  SizedBox(width: widthRatio(size: 16, context: context)),
                                                                  Text(
                                                                    'Вернуться назад',
                                                                    style:
                                                                        appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: heightRatio(size: 16, context: context)),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                                                              child: OrderTypeSwitchButton(
                                                                addOrSubtractBonusesState: addOrSubtractBonusesState,
                                                                subtractBonuses: subtractBonuses,
                                                                paymentTypeChoose: _paymentTypeChoose,
                                                                productModelForOrderRequestList: productModelForOrderRequestList,
                                                              ),
                                                            ),
                                                            SizedBox(height: heightRatio(size: 28, context: context)),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) => AddressesDeliveryAndShops(hasBackBtn: true)),
                                                                  );
                                                                },
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "Доставка из магазина:",
                                                                      style: appHeadersTextStyle(
                                                                          fontSize: heightRatio(size: 16, context: context), color: newBlack),
                                                                    ),
                                                                    BlocBuilder<AddressesShopBloc, AddressesShopState>(
                                                                      builder: (context, shopState) {
                                                                        String shopAddress = "Магазин не выбран";
                                                                        if (shopState is LoadedAddressesShopState && shopState.selectedShop != null) {
                                                                          shopAddress = shopState.selectedShop.address;
                                                                        }
                                                                        return Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          children: [
                                                                            Flexible(
                                                                              child: Text(
                                                                                shopAddress,
                                                                                style: appLabelTextStyle(
                                                                                    fontSize: heightRatio(size: 14, context: context), color: newBlackLight),
                                                                              ),
                                                                            ),
                                                                            SvgPicture.asset(
                                                                              "assets/images/newEdit.svg",
                                                                              height: heightRatio(size: 26, context: context),
                                                                              width: widthRatio(size: 26, context: context),
                                                                              fit: BoxFit.scaleDown,
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: heightRatio(size: 30, context: context)),
                                                            // Доставка по адресу:
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
                                                              child: BlocBuilder<AddressesClientBloc, ClientAddressState>(
                                                                builder: (context, clientAddressState) {
                                                                  String deliveryAddress = "Адрес не выбран";
                                                                  String deliveryAddressUuid = null;
                                                                  if (clientAddressState is LoadedClientAddressState &&
                                                                      clientAddressState.selectedAddress != null) {
                                                                    deliveryAddress =
                                                                        "${clientAddressState.selectedAddress.city}, ${clientAddressState.selectedAddress.street} ${clientAddressState.selectedAddress.house ?? ""}";
                                                                    deliveryAddressUuid = clientAddressState.selectedAddress.uuid;
                                                                  }
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => AddressesMyDelivery(
                                                                            productModelForOrderRequestList: productModelForOrderRequestList,
                                                                            uuid: deliveryAddressUuid,
                                                                          ),
                                                                        ),
                                                                      ).then((_) => setState(() {}));
                                                                    },
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Доставка по адресу",
                                                                          style: appHeadersTextStyle(
                                                                              fontSize: heightRatio(size: 16, context: context), color: newBlack),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          children: [
                                                                            Flexible(
                                                                              child: Text(
                                                                                deliveryAddress,
                                                                                style: appLabelTextStyle(
                                                                                    fontSize: heightRatio(size: 14, context: context), color: newBlackLight),
                                                                              ),
                                                                            ),
                                                                            SvgPicture.asset(
                                                                              "assets/images/newEdit.svg",
                                                                              height: heightRatio(size: 26, context: context),
                                                                              width: widthRatio(size: 26, context: context),
                                                                              fit: BoxFit.scaleDown,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(height: heightRatio(size: 30, context: context)),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
                                                              child: Text(
                                                                "specifyDeliveryAddressText".tr(), //Уточните адрес доставки
                                                                style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                                                              ),
                                                            ),
                                                            SizedBox(height: heightRatio(size: 12, context: context)),
                                                            BlocBuilder<AddressesClientBloc, ClientAddressState>(
                                                              builder: (context, clientAddressState) {
                                                                return Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    SizedBox(width: widthRatio(size: 2, context: context)),
                                                                    BasketAddress(
                                                                      labelText: "Домофон",
                                                                      textController: intercomCodeTextController,
                                                                    ),
                                                                    BasketAddress(
                                                                      labelText: "Подъезд",
                                                                      textController: entranceTextController,
                                                                    ),
                                                                    BasketAddress(
                                                                      labelText: "Этаж",
                                                                      textController: floorTextController,
                                                                    ),
                                                                    BasketAddress(
                                                                      labelText: "Квартира",
                                                                      textController: deliveryAppartmentnumberTextController,
                                                                    ),
                                                                    SizedBox(width: widthRatio(size: 2, context: context)),
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                            SizedBox(height: heightRatio(size: 28, context: context)),
                                                            //когда заберете
                                                            Container(
                                                              margin: EdgeInsets.only(
                                                                left: widthRatio(size: 15, context: context),
                                                                right: widthRatio(size: 15, context: context),
                                                                top: heightRatio(size: 10, context: context),
                                                              ),
                                                              padding: EdgeInsets.all(
                                                                heightRatio(size: 12, context: context),
                                                              ),
                                                              decoration: BoxDecoration(
                                                                color: whiteColor,
                                                                borderRadius: BorderRadius.circular(
                                                                  heightRatio(size: 15, context: context),
                                                                ),
                                                                boxShadow: [
                                                                  BoxShadow(color: colorBlack03, spreadRadius: 0, blurRadius: 20, offset: Offset(0, 0)),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    "Когда доставить",
                                                                    style:
                                                                        appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
                                                                  ),
                                                                  SizedBox(height: heightRatio(size: 5, context: context)),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'Дата доставки',
                                                                            style: appLabelTextStyle(
                                                                                fontSize: heightRatio(size: 12, context: context), color: newGrey),
                                                                          ),
                                                                          SizedBox(height: heightRatio(size: 3, context: context)),
                                                                          InkWell(
                                                                            onTap: () async {
                                                                              FocusScope.of(context).unfocus();
                                                                              final List<String> _deliveryDateResult = await showModalBottomSheet<dynamic>(
                                                                                isScrollControlled: true,
                                                                                useSafeArea: true,
                                                                                context: context,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(heightRatio(size: 25, context: context)),
                                                                                    topRight: Radius.circular(heightRatio(size: 25, context: context)),
                                                                                  ),
                                                                                ),
                                                                                builder: (BuildContext bc) {
                                                                                  return Wrap(
                                                                                    children: [
                                                                                      RedesDeliveryDatePickerBottomSheet(
                                                                                        titleText: 'deliveryTimeText'.tr(),
                                                                                        monthList: deliveryMonthsList,
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              );
                                                                              if (_deliveryDateResult != null) {
                                                                                setState(
                                                                                  () {
                                                                                    _deliveryMonthChoose = _deliveryDateResult[0];
                                                                                    _deliveryDayChoose = _deliveryDateResult[1];
                                                                                    deliveryTimeList = _getDeliveryInterval(
                                                                                        fromTime: fromTime,
                                                                                        tillTime: tillTime,
                                                                                        nowHour: DateTime.now().hour,
                                                                                        nowMinutes: DateTime.now().minute);
                                                                                    if (deliveryTimeList.isNotEmpty) {
                                                                                      _deliveryTimeChoose = deliveryTimeList[0];
                                                                                    } else {
                                                                                      _deliveryTimeChoose = "";
                                                                                    }
                                                                                  },
                                                                                );
                                                                                _orderCalculateBloc.add(
                                                                                  OrderCalculateLoadEvent(
                                                                                    orderDeliveryTypeId: orderDeliveryTypeId,
                                                                                    orderPaymentTypeId: "online",
                                                                                    productModelForOrderRequestList: productModelForOrderRequestList,
                                                                                  ),
                                                                                );
                                                                              }
                                                                            },
                                                                            child: Container(
                                                                              width: 140,
                                                                              decoration:
                                                                                  BoxDecoration(border: Border(bottom: BorderSide(color: grey04, width: 1))),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    '$_deliveryDayChoose ${getMonthName(month: int.parse(_deliveryMonthChoose), isOfMode: true)}',
                                                                                    style: appLabelTextStyle(
                                                                                        fontSize: heightRatio(size: 16, context: context), color: newBlack),
                                                                                  ),
                                                                                  Icon(Icons.arrow_drop_down, color: newBlackLight),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Время доставки",
                                                                            style: appLabelTextStyle(
                                                                                fontSize: heightRatio(size: 12, context: context), color: newGrey),
                                                                          ),
                                                                          InkWell(
                                                                            onTap: () async {
                                                                              if (isNotAvailableToSale) {
                                                                                log('isNotAvailableToSale=$isNotAvailableToSale::::::::::::::: InkWell не кликабельный в это время, так как после 18:00 не принимаются заказы');
                                                                                Fluttertoast.showToast(msg: "selectAnotherDayText".tr());
                                                                                return;
                                                                              }
                                                                              FocusScope.of(context).unfocus();
                                                                              if (deliveryTimeList.isNotEmpty) {
                                                                                final String _deliverytimeResult = await showModalBottomSheet<dynamic>(
                                                                                    isScrollControlled: true,
                                                                                    useSafeArea: true,
                                                                                    context: context,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.only(
                                                                                        topLeft: Radius.circular(heightRatio(size: 25, context: context)),
                                                                                        topRight: Radius.circular(heightRatio(size: 25, context: context)),
                                                                                      ),
                                                                                    ),
                                                                                    builder: (BuildContext bc) {
                                                                                      return Wrap(children: [
                                                                                        DeliveryTimePickerBottomSheet(
                                                                                            timeList: deliveryTimeList, titleText: 'chooseInterval'.tr())
                                                                                      ]);
                                                                                    });
                                                                                if (_deliverytimeResult != null) {
                                                                                  setState(() => _deliveryTimeChoose = _deliverytimeResult);
                                                                                  _orderCalculateBloc.add(
                                                                                    OrderCalculateLoadEvent(
                                                                                      orderDeliveryTypeId: orderDeliveryTypeId,
                                                                                      orderPaymentTypeId: "online",
                                                                                      productModelForOrderRequestList: productModelForOrderRequestList,
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              } else {
                                                                                Fluttertoast.showToast(msg: "selectAnotherDayText".tr());
                                                                              }
                                                                            },
                                                                            child: Container(
                                                                              width: 140,
                                                                              decoration:
                                                                                  BoxDecoration(border: Border(bottom: BorderSide(color: grey04, width: 1))),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  isNotAvailableToSale
                                                                                      ? SizedBox.shrink()
                                                                                      : Text(
                                                                                          _deliveryTimeChoose == null
                                                                                              ? deliveryTimeList.isEmpty
                                                                                                  ? ""
                                                                                                  : deliveryTimeList[0]
                                                                                              : _deliveryTimeChoose, //доставка
                                                                                          style: appLabelTextStyle(
                                                                                              fontSize: heightRatio(size: 16, context: context),
                                                                                              color: newBlack),
                                                                                        ),
                                                                                  Icon(Icons.arrow_drop_down, color: newBlackLight),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                  SizedBox(height: heightRatio(size: 25, context: context)),
                                                  // Итоговые сводки: Товаров... Скидка по акциям... Доставка...
                                                  BasketTotal(),
                                                  SizedBox(height: heightRatio(size: 25, context: context)),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                                                    child: Text(
                                                      //Комментарий к заказу
                                                      "commentsonTheOrderText".tr(),
                                                      style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlackLight),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                                                    child: TextField(
                                                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                                                      focusNode: focus,
                                                      scrollPadding: EdgeInsets.only(bottom: focus.hasFocus ? MediaQuery.of(context).viewInsets.bottom : 0),
                                                      controller: orderCommentTextController,
                                                      maxLines: 1,
                                                      style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack),
                                                      decoration: InputDecoration(
                                                        hintText: 'SuggestionsClarificationsText'.tr(),
                                                        hintStyle: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newGrey),
                                                        border: InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: heightRatio(size: 15, context: context)),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                                    child: Divider(
                                                      height: 0,
                                                    ),
                                                  ),
                                                  SizedBox(height: heightRatio(size: 24, context: context)),
                                                  BlocBuilder<OrderCalculateBloc, OrderCalculateState>(
                                                    builder: (context, calculateState) {
                                                      if (calculateState is OrderCalculateErrorState) {
                                                        return SizedBox();
                                                      } else {
                                                        return Row(
                                                          children: [
                                                            SizedBox(width: widthRatio(size: 14, context: context)),
                                                            Container(
                                                              height: heightRatio(size: 52, context: context),
                                                              width: widthRatio(size: 52, context: context),
                                                              decoration: BoxDecoration(color: newRedDark, borderRadius: BorderRadius.circular(10)),
                                                              child:
                                                                  Icon(Icons.info_outline, color: Colors.white, size: heightRatio(size: 35, context: context)),
                                                            ),
                                                            SizedBox(width: widthRatio(size: 13, context: context)),
                                                            Flexible(
                                                              child: RichText(
                                                                text: TextSpan(children: [
                                                                  TextSpan(
                                                                    text:
                                                                        "Стоимость заказа может незначительно измениться из-за возможных замен весового товара и упаковки, необходимой для доставки вашего заказа. ",
                                                                    style: appLabelTextStyle(
                                                                        color: newBlack,
                                                                        fontSize: heightRatio(size: 12, context: context),
                                                                        height: heightRatio(size: 1.2, context: context)),
                                                                  ),
                                                                  TextSpan(
                                                                    text: "Разницу вернем или спишем после получения заказа",
                                                                    style: appLabelTextStyle(
                                                                        color: newRedDark,
                                                                        fontSize: heightRatio(size: 12, context: context),
                                                                        height: heightRatio(size: 1.2, context: context)),
                                                                  ),
                                                                ]),
                                                              ),
                                                            ),
                                                            SizedBox(width: widthRatio(size: 14, context: context)),
                                                          ],
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(height: heightRatio(size: 50, context: context)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    focus.dispose();
    _debounce?.cancel();
    intercomCodeTextController.dispose();
    entranceTextController.dispose();
    floorTextController.dispose();
    deliveryAppartmentnumberTextController.dispose();
    super.dispose();
  }
}

BoxDecoration _decorationForContent(BuildContext context) => BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(heightRatio(size: 15, context: context)),
        topRight: Radius.circular(heightRatio(size: 15, context: context)),
      ),
    );
