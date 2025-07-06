import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/bloc_files/add_or_subtract_bonuses_bloc.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/features/basket/basket3/open_order_calculate_bottom_sheet.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/bloc_files/credit_cards_bloc.dart';
import 'package:smart/bloc_files/order_calculate_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/bloc_files/selected_pay_card_and_address_for_order_bloc.dart';
import 'package:smart/bloc_files/url_for_credit_card_bloc.dart';
import 'package:smart/custom_widgets/credit_cards_list.dart';
import 'package:smart/custom_widgets/redesigned_widgets/type_email_for_order_bottom_sheet.dart';
import 'package:smart/main.dart';
import 'package:smart/models/product_model_for_order_request.dart';
import 'package:smart/models/url_for_credit_carde_link_model.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/pages/redesigned_pages/open_url_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/bloc_files/basic_page_bloc.dart';

class BasketScreen3 extends StatefulWidget {
  final BasketLoadedState basketState;
  final String deliveryTimeChoose;
  final String emailText;
  final String deliveryAddress;
  final String orderDeliveryTypeId;
  final String paymentTypeChoose;
  final bool canMakeOrder;
  final String deliveryAppartmentNumber;
  final String orderComment;
  final String entrance;
  final String intercomCode;
  final String floor;
  final String payType;
  final String deliveryDayChoose;
  final String deliveryMonthChoose;
  final int subtractBonuses;

  const BasketScreen3({
    Key key,
    @required this.basketState,
    @required this.deliveryTimeChoose,
    @required this.emailText,
    @required this.deliveryAddress,
    @required this.orderDeliveryTypeId,
    @required this.paymentTypeChoose,
    @required this.canMakeOrder,
    @required this.deliveryAppartmentNumber,
    @required this.orderComment,
    @required this.entrance,
    @required this.intercomCode,
    @required this.floor,
    @required this.payType,
    @required this.deliveryDayChoose,
    @required this.deliveryMonthChoose,
    @required this.subtractBonuses,
  }) : super(key: key);
  @override
  State<BasketScreen3> createState() => _BasketScreen3State();
}

class _BasketScreen3State extends State<BasketScreen3> {
  List<ProductModelForOrderRequest> productModelForOrderRequestList = [];
  String selectedCardUuid;
  String selectedCardNumber;
  bool isCardLinkIsOpened = false;
  CreditCardsListBloc _cardsListBloc;
  String chosenCreditCardUuid;

  @override
  void initState() {
    super.initState();
    _cardsListBloc = BlocProvider.of(context);
    _cardsListBloc.add(CreditCardsListLoadEvent());
    productModelForOrderRequestList = widget.basketState.productModelForOrderRequestList;
  }

  @override
  void dispose() {
    print('im dieeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
    _cardsListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthPageBloc authPageBloc = BlocProvider.of(context);
    BasicPageBloc basicPageBloc = BlocProvider.of(context);
    OrderCalculateBloc _orderCalculateBloc = BlocProvider.of<OrderCalculateBloc>(context);
    UrlForCreditCardLinkBloc _urlForCreditCardLinkBloc = BlocProvider.of<UrlForCreditCardLinkBloc>(context);
    SelectedPayCardAndAddressForOrderBloc _selectedPayCardAndAddressForOrderBloc = BlocProvider.of(context);
    BasketListBloc basketListBloc = BlocProvider.of(context);

    return BlocConsumer<BasketListBloc, BasketState>(
      listener: (context, basketListState) {
        if (basketListState is BasketOldTokenState) {
          ProfilePage.logout(basicPageBloc: basicPageBloc, regBloc: authPageBloc);
        }
      },
      builder: (context, state) {
        debugPrint('🤞 deliveryTimeChoose: ${widget.deliveryTimeChoose}');
        debugPrint('🤞 emailText: ${widget.emailText}');
        debugPrint('🤞 deliveryAddress: ${widget.deliveryAddress}');
        debugPrint('🤞 orderDeliveryTypeId: ${widget.orderDeliveryTypeId}');
        debugPrint('🤞 paymentTypeChoose: ${widget.paymentTypeChoose}');
        debugPrint('🤞 canMakeOrder: ${widget.canMakeOrder}');
        debugPrint('🤞 deliveryAppartmentNumber: ${widget.deliveryAppartmentNumber}');
        debugPrint('🤞 orderComment: ${widget.orderComment}');
        debugPrint('🤞 entrance: ${widget.entrance}');
        debugPrint('🤞 intercomCode: ${widget.intercomCode}');
        debugPrint('🤞 floor: ${widget.floor}');
        debugPrint('🤞 payType: ${widget.payType}');
        debugPrint('🤞 deliveryDayChoose: ${widget.deliveryDayChoose}');
        debugPrint('🤞 deliveryMonthChoose: ${widget.deliveryMonthChoose}');
        debugPrint('🤞 subtractBonuses: ${widget.subtractBonuses}');

        return BlocBuilder<AddOrSubtractBonusesBloc, AddOrSubtractBonusesState>(
          builder: (context, addOrSubtractBonusesState) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                color: newRedDark,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: widthRatio(size: 10, context: context),
                          top: heightRatio(size: 16, context: context),
                          bottom: heightRatio(size: 20, context: context),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Icon(Icons.arrow_back_ios_new_rounded,
                                  size: heightRatio(size: 22, context: context), color: whiteColor),
                            ),
                            SizedBox(width: widthRatio(size: 15, context: context)),
                            Text(
                              "Оплата",
                              style: appHeadersTextStyle(
                                  color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: heightRatio(size: 20, context: context),
                              horizontal: widthRatio(size: 15, context: context)),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                              topRight: Radius.circular(heightRatio(size: 15, context: context)),
                            ),
                          ),
                          alignment: Alignment.topLeft,
                          child: BlocBuilder<SelectedPayCardAndAddressForOrderBloc,
                              SelectedPayCardAndAddressForOrderState>(
                            builder: (context, state) {
                              if (state is SelectedPayCardAndAddressForOrderLoadedState) {
                                if (state.cardUuid != null && state.payType != null && state.payType == "online") {
                                  chosenCreditCardUuid = state.cardUuid;
                                }
                                return BlocBuilder<CreditCardsListBloc, CreditCardsListState>(
                                    builder: (context, creditCardState) {
                                  if (creditCardState is CreditCardsListLoadingState) {
                                    return Container(
                                      height: heightRatio(size: 450, context: context),
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              valueColor: new AlwaysStoppedAnimation<Color>(mainColor))),
                                    );
                                  }
                                  if (creditCardState is CreditCardsListLoadedState) {
                                    if (creditCardState.cardsListModel.data.isEmpty) {
                                      _urlForCreditCardLinkBloc.add(UrlForCreditCardLinkLoadEvent());
                                      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!open from 3rd screen");
                                      openLinkPayCardPAge(cardsListBloc: _cardsListBloc);
                                    }
                                    if (selectedCardUuid == null) {
                                      selectedCardUuid = state.cardUuid == null
                                          ? creditCardState.cardsListModel.data.isNotEmpty
                                              ? creditCardState.cardsListModel.data.first.uuid
                                              : ""
                                          : state.cardUuid;

                                      selectedCardNumber = state.payCardNumber == null
                                          ? creditCardState.cardsListModel.data.isNotEmpty
                                              ? creditCardState.cardsListModel.data.first.cardMask
                                              : ""
                                          : state.payCardNumber;
                                    }
                                  }

                                  if (creditCardState is CreditCardsListLoadedState &&
                                      creditCardState.cardsListModel.data.isEmpty) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/newCreditCardIcon.svg',
                                                height: heightRatio(size: 131, context: context),
                                                width: widthRatio(size: 131, context: context),
                                              ),
                                              SizedBox(height: heightRatio(size: 20, context: context)),
                                              Text(
                                                "Карт еще не добавлено",
                                                style: appLabelTextStyle(
                                                    fontSize: heightRatio(size: 18, context: context), color: newBlack),
                                              ),
                                              SizedBox(height: heightRatio(size: 20, context: context)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: heightRatio(size: 20, context: context)),
                                        InkWell(
                                          onTap: () async => openLinkPayCardPAge(cardsListBloc: _cardsListBloc),
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(
                                              top: heightRatio(size: 15, context: context),
                                              bottom: heightRatio(size: 18, context: context),
                                            ),
                                            width: widthRatio(size: 205, context: context),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5), color: newRedDark),
                                            child: Text(
                                              "Добавить карту оплаты",
                                              style: appLabelTextStyle(
                                                  color: Colors.white,
                                                  fontSize: heightRatio(size: 16, context: context)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Способы оплаты",
                                            style: appHeadersTextStyle(
                                                fontSize: heightRatio(size: 16, context: context), color: newBlack)),
                                        SizedBox(height: heightRatio(size: 30, context: context)),
                                        Text("Сохраненные карты",
                                            style: appLabelTextStyle(
                                                fontSize: heightRatio(size: 12, context: context), color: newBlack)),
                                        Container(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: creditCardState is CreditCardsListLoadedState
                                                ? creditCardState.cardsListModel.data.length
                                                : 0,
                                            itemBuilder: (context, index) => GestureDetector(
                                              onTap: creditCardState is CreditCardsListLoadedState &&
                                                      creditCardState.cardsListModel.data.length == 1
                                                  ? () => print("+ клик по карте. но впустую ))")
                                                  : () {
                                                      print("++ клик по карте");
                                                      _selectCard(
                                                        creditCardState: creditCardState,
                                                        index: index,
                                                        selectedPayCardAndAddressForOrderBloc:
                                                            _selectedPayCardAndAddressForOrderBloc,
                                                        state: state,
                                                      );
                                                    },
                                              child: Slidable(
                                                actionPane: SlidableDrawerActionPane(),
                                                secondaryActions: [
                                                  IconSlideAction(
                                                    color: Colors.transparent,
                                                    onTap: () async {
                                                      if (creditCardState is CreditCardsListLoadedState &&
                                                          selectedCardUuid ==
                                                              creditCardState.cardsListModel.data[index].uuid) {
                                                        await _deleteCreditCard(
                                                            creditCardState: creditCardState,
                                                            index: index,
                                                            cardsListBloc: _cardsListBloc);
                                                        if (creditCardState.cardsListModel.data.isNotEmpty) {
                                                          _selectCard(
                                                            creditCardState: creditCardState,
                                                            index: 0,
                                                            selectedPayCardAndAddressForOrderBloc:
                                                                _selectedPayCardAndAddressForOrderBloc,
                                                            state: state,
                                                          );
                                                        } else {
                                                          _selectedPayCardAndAddressForOrderBloc
                                                              .add(SelectedPayCardAndAddressForOrderLoadEvent(
                                                            payCardNumber: null,
                                                            cardUuid: null,
                                                            addressForDelivery: state.addressForDelivery,
                                                            addressindex: state.addressindex,
                                                            apartmentNumber: state.apartmentNumber,
                                                            entrance: state.entrance,
                                                            floor: state.floor,
                                                            intercomCode: state.intercomCode,
                                                            orderType: state.orderType,
                                                            payType: "online",
                                                          ));
                                                          basketListBloc.add(BasketLoadEvent());
                                                        }
                                                      } else {
                                                        await _deleteCreditCard(
                                                            creditCardState: creditCardState,
                                                            index: index,
                                                            cardsListBloc: _cardsListBloc);
                                                      }
                                                    },
                                                    iconWidget: Container(
                                                      height: heightRatio(size: 65, context: context),
                                                      margin: EdgeInsets.only(
                                                        left: widthRatio(size: 8, context: context),
                                                        top: heightRatio(size: 15, context: context),
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "Удалить",
                                                        textAlign: TextAlign.center,
                                                        style: appLabelTextStyle(
                                                            fontSize: heightRatio(size: 12, context: context),
                                                            color: newRedDark),
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: whiteColor,
                                                        border: Border.all(color: newRedDark, width: 1),
                                                        borderRadius: BorderRadius.circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: newShadow,
                                                              offset: Offset(12, 12),
                                                              blurRadius: 24,
                                                              spreadRadius: 0)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: heightRatio(size: 15, context: context)),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: widthRatio(size: 19, context: context)),
                                                        height: heightRatio(size: 65, context: context),
                                                        decoration: BoxDecoration(
                                                          color: whiteColor,
                                                          border: Border.all(
                                                            color: (creditCardState is CreditCardsListLoadedState &&
                                                                    creditCardState.cardsListModel.data[index].uuid ==
                                                                        selectedCardUuid)
                                                                ? newRedDark
                                                                : whiteColor,
                                                            width: 1,
                                                          ),
                                                          borderRadius: BorderRadius.circular(10),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: newShadow,
                                                                offset: Offset(12, 12),
                                                                blurRadius: 24,
                                                                spreadRadius: 0)
                                                          ],
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            if (creditCardState is CreditCardsListLoadedState)
                                                              Image.asset(
                                                                CreditCardsList().getPaySystemByNumber(
                                                                  number: creditCardState
                                                                      .cardsListModel.data[index].cardMask,
                                                                ),
                                                                height: heightRatio(size: 28, context: context),
                                                                errorBuilder: (context, error, stackTrace) => Text(
                                                                  CreditCardsList().getPaySystemByNumber(
                                                                    number: creditCardState
                                                                        .cardsListModel.data[index].cardMask,
                                                                  ),
                                                                  style: appLabelTextStyle(
                                                                      fontSize: heightRatio(size: 16, context: context),
                                                                      color: newBlack),
                                                                ),
                                                              ),
                                                            SizedBox(width: widthRatio(size: 20, context: context)),
                                                            Text('****',
                                                                style: appLabelTextStyle(
                                                                    fontSize: heightRatio(size: 16, context: context),
                                                                    color: newBlack)),
                                                            if (creditCardState is CreditCardsListLoadedState)
                                                              Text(
                                                                "${creditCardState.cardsListModel.data[index].cardMask.replaceAll("X", "").substring(6)}",
                                                                style: appLabelTextStyle(
                                                                    fontSize: heightRatio(size: 16, context: context),
                                                                    color: newBlack),
                                                              ),
                                                            Spacer(),
                                                            //deleteCreditCard:
                                                            IconButton(
                                                              onPressed: () async {
                                                                if (creditCardState is CreditCardsListLoadedState &&
                                                                    selectedCardUuid ==
                                                                        creditCardState
                                                                            .cardsListModel.data[index].uuid) {
                                                                  await _deleteCreditCard(
                                                                      creditCardState: creditCardState,
                                                                      index: index,
                                                                      cardsListBloc: _cardsListBloc);
                                                                  if (creditCardState.cardsListModel.data.isNotEmpty) {
                                                                    _selectCard(
                                                                        creditCardState: creditCardState,
                                                                        index: 0,
                                                                        selectedPayCardAndAddressForOrderBloc:
                                                                            _selectedPayCardAndAddressForOrderBloc,
                                                                        state: state);
                                                                  } else {
                                                                    _selectedPayCardAndAddressForOrderBloc
                                                                        .add(SelectedPayCardAndAddressForOrderLoadEvent(
                                                                      payCardNumber: null,
                                                                      cardUuid: null,
                                                                      addressForDelivery: state.addressForDelivery,
                                                                      addressindex: state.addressindex,
                                                                      apartmentNumber: state.apartmentNumber,
                                                                      entrance: state.entrance,
                                                                      floor: state.floor,
                                                                      intercomCode: state.intercomCode,
                                                                      orderType: state.orderType,
                                                                      payType: "online",
                                                                    ));
                                                                    basketListBloc.add(BasketLoadEvent());
                                                                  }
                                                                } else {
                                                                  await _deleteCreditCard(
                                                                    creditCardState: creditCardState,
                                                                    index: index,
                                                                    cardsListBloc: _cardsListBloc,
                                                                  );
                                                                }
                                                              },
                                                              icon: SvgPicture.asset(
                                                                'assets/images/newTrash2.svg',
                                                                width: widthRatio(size: 15, context: context),
                                                                height: heightRatio(size: 16, context: context),
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
                                          ),
                                        ),
                                        SizedBox(height: heightRatio(size: 40, context: context)),
                                        InkWell(
                                          onTap: () async => openLinkPayCardPAge(cardsListBloc: _cardsListBloc),
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(
                                              top: heightRatio(size: 15, context: context),
                                              bottom: heightRatio(size: 18, context: context),
                                            ),
                                            width: MediaQuery.of(context).size.width,
                                            decoration:
                                                BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
                                            child: Text(
                                              'Добавить способ оплаты',
                                              style: appLabelTextStyle(
                                                  color: Colors.white,
                                                  fontSize: heightRatio(size: 16, context: context)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: heightRatio(size: 20, context: context)),
                                        InkWell(
                                          onTap: () async {
                                            if (widget.basketState is BasketLoadedState) {
                                              print(widget.basketState.basketListModel.data);
                                            }
                                            if (widget.canMakeOrder == true) {
                                              if (widget.basketState.basketListModel.data.length ==
                                                  productModelForOrderRequestList.length) {
                                                final String _emailresult = await showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    useSafeArea: true,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(heightRatio(size: 25, context: context)),
                                                        topRight:
                                                            Radius.circular(heightRatio(size: 25, context: context)),
                                                      ),
                                                    ),
                                                    builder: (BuildContext bc) =>
                                                        Wrap(children: [TypeEmailForOrderBottomSheet()]));
                                                if (_emailresult != null && _emailresult.isNotEmpty) {
                                                  String isTabCallText = prefs
                                                          .getBool(SharedKeys.basketSettingsIsTabCall)
                                                      ? '. Что делать если товара нет в наличии: Позвонить и согласовать изменение заказа. '
                                                      : '. Что делать если товара нет в наличии: Удалить товары из заказа. ';
                                                  String newOrderCommentText = widget.orderComment +
                                                      isTabCallText +
                                                      prefs.getString(SharedKeys.basketSettingsTypeText);
                                                  openOrderCalculateBottomSheet(
                                                      clientCreditCardUuid: chosenCreditCardUuid,
                                                      apartmentNumber: widget.deliveryAppartmentNumber != ""
                                                          ? int.parse(widget.deliveryAppartmentNumber)
                                                          : null,
                                                      clientComment: widget.orderComment + " | " + newOrderCommentText,
                                                      clientEmail: _emailresult,
                                                      entrance:
                                                          widget.entrance != "" ? int.parse(widget.entrance) : null,
                                                      floor: widget.floor != "" ? int.parse(widget.floor) : null,
                                                      intercomCode:
                                                          widget.intercomCode.isEmpty ? "none" : widget.intercomCode,
                                                      orderDeliveryTypeId: widget.orderDeliveryTypeId,
                                                      orderPaymentTypeId: widget.payType,
                                                      plannedDeliveryDatetimeFrom: int.parse(widget.deliveryDayChoose) <
                                                                  10 &&
                                                              int.parse(widget.deliveryMonthChoose) < 10
                                                          ? "${DateTime.now().year}-0${widget.deliveryMonthChoose}-0${widget.deliveryDayChoose} ${widget.deliveryTimeChoose[0]}${widget.deliveryTimeChoose[1]}:00:00+0300"
                                                          : int.parse(widget.deliveryDayChoose) < 10
                                                              ? "${DateTime.now().year}-${widget.deliveryMonthChoose}-0${widget.deliveryDayChoose} ${widget.deliveryTimeChoose[0]}${widget.deliveryTimeChoose[1]}:00:00+0300"
                                                              : int.parse(widget.deliveryMonthChoose) < 10
                                                                  ? "${DateTime.now().year}-0${widget.deliveryMonthChoose}-${widget.deliveryDayChoose} ${widget.deliveryTimeChoose[0]}${widget.deliveryTimeChoose[1]}:00:00+0300"
                                                                  : "${DateTime.now().year}-${widget.deliveryMonthChoose}-${widget.deliveryDayChoose} ${widget.deliveryTimeChoose[0]}${widget.deliveryTimeChoose[1]}:00:00+0300",
                                                      plannedDeliveryDatetimeTo: int.parse(widget.deliveryDayChoose) <
                                                                  10 &&
                                                              int.parse(widget.deliveryMonthChoose) < 10
                                                          ? "${DateTime.now().year}-0${widget.deliveryMonthChoose}-0${widget.deliveryDayChoose} ${widget.deliveryTimeChoose[8]}${widget.deliveryTimeChoose[9]}:00:00+0300"
                                                          : int.parse(widget.deliveryDayChoose) < 10
                                                              ? "${DateTime.now().year}-${widget.deliveryMonthChoose}-0${widget.deliveryDayChoose} ${widget.deliveryTimeChoose[8]}${widget.deliveryTimeChoose[9]}:00:00+0300"
                                                              : int.parse(widget.deliveryMonthChoose) < 10
                                                                  ? "${DateTime.now().year}-0${widget.deliveryMonthChoose}-${widget.deliveryDayChoose} ${widget.deliveryTimeChoose[8]}${widget.deliveryTimeChoose[9]}:00:00+0300"
                                                                  : "${DateTime.now().year}-${widget.deliveryMonthChoose}-${widget.deliveryDayChoose} ${widget.deliveryTimeChoose[8]}${widget.deliveryTimeChoose[9]}:00:00+0300",
                                                      productModelForOrderRequestList: productModelForOrderRequestList,
                                                      context: context,
                                                      address: widget.orderDeliveryTypeId == "pickup"
                                                          ? ""
                                                          : "${widget.deliveryAddress}");
                                                }
                                                _orderCalculateBloc.add(OrderCalculateLoadEvent(
                                                    subtractBonusesCount: addOrSubtractBonusesState is AddBonusesState
                                                        ? null
                                                        : widget.subtractBonuses,
                                                    orderDeliveryTypeId: widget.orderDeliveryTypeId,
                                                    orderPaymentTypeId:
                                                        state.payType, //selectedPayCardAndAddressForOrderState
                                                    productModelForOrderRequestList: productModelForOrderRequestList));
                                              } else {
                                                Fluttertoast.showToast(msg: "".tr());
                                              }
                                            } else {
                                              Fluttertoast.showToast(msg: "Заполните необходимые поля");
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(
                                              top: heightRatio(size: 15, context: context),
                                              bottom: heightRatio(size: 18, context: context),
                                            ),
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5), color: newRedDark),
                                            child: Text(
                                              'Оплатить',
                                              style: appLabelTextStyle(
                                                  color: Colors.white,
                                                  fontSize: heightRatio(size: 16, context: context)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                });
                              }
                              return SizedBox();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void openLinkPayCardPAge({@required CreditCardsListBloc cardsListBloc}) async {
    if (isCardLinkIsOpened == false) {
      isCardLinkIsOpened = true;
      Fluttertoast.showToast(msg: "Подождите...");
      final UrlForCreditCardLinkModel _urlForCreditCardLinkModel =
          await CreditCardsProvider().getUrlForCreditCardLinkResponse();
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return openUrlPage(
            url: _urlForCreditCardLinkModel.data.formUrl,
            context: context,
            cardsListBloc: cardsListBloc,
            orderId: _urlForCreditCardLinkModel.data.orderId,
          );
        },
      )).then((value) async {
        isCardLinkIsOpened = false;
        if (await CreditCardsProvider()
            .setSuccessStatusOfLinkingCardResponse(orderId: _urlForCreditCardLinkModel.data.orderId)) {
          cardsListBloc.add(CreditCardsListLoadEvent());
        }
      });
    }
  }

  _deleteCreditCard(
      {@required CreditCardsListLoadedState creditCardState,
      @required int index,
      CreditCardsListBloc cardsListBloc}) async {
    if (await CreditCardsProvider()
        .deleteCreditCardResponse(cardUuid: creditCardState.cardsListModel.data[index].uuid)) {
      setState(() {
        creditCardState.cardsListModel.data.removeWhere((element) => element.uuid == selectedCardUuid);
      });
      cardsListBloc.add(CreditCardsListLoadEvent());
    } else {
      Fluttertoast.showToast(msg: "errorText".tr());
    }
  }

  _selectCard({
    @required CreditCardsListLoadedState creditCardState,
    @required int index,
    @required SelectedPayCardAndAddressForOrderBloc selectedPayCardAndAddressForOrderBloc,
    @required SelectedPayCardAndAddressForOrderLoadedState state,
  }) {
    {
      setState(() {
        selectedCardUuid = creditCardState.cardsListModel.data[index].uuid;
        selectedCardNumber = creditCardState.cardsListModel.data[index].cardMask;
        print('_selectCard, setState');
      });

      selectedPayCardAndAddressForOrderBloc.add(SelectedPayCardAndAddressForOrderLoadEvent(
        payCardNumber: selectedCardNumber,
        cardUuid: selectedCardUuid,
        addressForDelivery: state.addressForDelivery,
        addressindex: state.addressindex,
        apartmentNumber: state.apartmentNumber,
        entrance: state.entrance,
        floor: state.floor,
        intercomCode: state.intercomCode,
        orderType: state.orderType,
        payType: "online",
      ));
    }
    ;
  }
}
