import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/basic_page_bloc.dart';
import 'package:smart/bloc_files/order_calculate_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/bloc_files/shopping_lists_bloc.dart';
import 'package:smart/bloc_files/smart_contacts_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/custom_widgets/recomendation_list_widget.dart';
import 'package:smart/features/basket/basket_screen2.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/features/basket/widgets/basket_empty.dart';
import 'package:smart/features/basket/widgets/basket_error.dart';
import 'package:smart/features/basket/widgets/basket_header.dart';
import 'package:smart/features/basket/widgets/basket_list.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/models/product_model_for_order_request.dart';

class BasketScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> basketNavKey;
  const BasketScreen({Key key, @required this.basketNavKey}) : super(key: key);

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  final ScrollController _scrollController = ScrollController();
  List<ProductModelForOrderRequest> productModelForOrderRequestList = [];

  @override
  Widget build(BuildContext context) {
    BasketListBloc _basketListBloc = BlocProvider.of<BasketListBloc>(context);
    AuthPageBloc authPageBloc = BlocProvider.of(context);
    ShoppingListsBloc _shoppingListsBloc = BlocProvider.of<ShoppingListsBloc>(context);
    BasicPageBloc basicPageBloc = BlocProvider.of(context);
    SmartContactsBloc _smartContactsBloc = BlocProvider.of(context);
    OrderCalculateBloc _orderCalculateBloc = BlocProvider.of<OrderCalculateBloc>(context);
    return Navigator(
      key: widget.basketNavKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => BlocConsumer<BasketListBloc, BasketState>(
          listener: (context, basketListState) {
            print('LOAD IN BASAKETT');
            if (basketListState is BasketOldTokenState) {
              ProfilePage.logout(basicPageBloc: basicPageBloc, regBloc: authPageBloc);
            }
            if (basketListState is BasketLoadedState) {
              productModelForOrderRequestList = basketListState.productModelForOrderRequestList;
              _orderCalculateBloc.add(OrderCalculateLoadEvent(
                orderDeliveryTypeId: "delivery",
                orderPaymentTypeId: "online",
                productModelForOrderRequestList: productModelForOrderRequestList,
              ));
              print(basketListState.productModelForOrderRequestList.map((e) => e.quantity));
            }
          },
          builder: (context, basketState) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              bottomNavigationBar: (basketState is BasketLoadedState)
                  ? Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(bottom: heightRatio(size: 20, context: context)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: heightRatio(size: 8, context: context)),
                          GestureDetector(
                            onTap: () {
                              if (basketState.orderCalculateResponseModel != null &&
                                  (basketState.orderCalculateResponseModel.data.toMinPrice == null ||
                                      basketState.orderCalculateResponseModel.data.toMinPrice == 0)) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => BasketScreen2()));
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                  top: heightRatio(size: 15, context: context),
                                  bottom: heightRatio(size: 18, context: context)),
                              margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
                              width: double.maxFinite,
                              height: heightRatio(size: 54, context: context),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: basketState.orderCalculateResponseModel != null
                                    ? (basketState.orderCalculateResponseModel.data.toMinPrice == null ||
                                            basketState.orderCalculateResponseModel.data.toMinPrice == 0)
                                        ? newRedDark
                                        : newBlackLight
                                    : newGrey,
                              ),
                              child: basketState.orderCalculateResponseModel != null
                                  ? (basketState.orderCalculateResponseModel.data.toMinPrice == null ||
                                          basketState.orderCalculateResponseModel.data.toMinPrice == 0)
                                      ? Text(
                                          'Перейти к оплате',
                                          style: appLabelTextStyle(
                                              color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                                        )
                                      : RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    'Минимальная сумма заказа ${basketState.orderCalculateResponseModel.data.minPrice % 1 == 0 ? basketState.orderCalculateResponseModel.data.minPrice.toInt().toString() : basketState.orderCalculateResponseModel.data.minPrice.toStringAsFixed(2)}',
                                                style: appLabelTextStyle(
                                                    color: Colors.white,
                                                    fontSize: heightRatio(size: 16, context: context)),
                                              ),
                                              TextSpan(
                                                text: ' ₽',
                                                style: appTextStyle(
                                                    fontSize: heightRatio(size: 16, context: context),
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        )
                                  : Text(
                                      'Нет в наличии',
                                      style: appLabelTextStyle(
                                          color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
              body: Container(
                color: newRedDark,
                child: SafeArea(
                  child: Column(
                    children: [
                      BasketHeader(
                          basketListBloc: _basketListBloc,
                          shoppingListsBloc: _shoppingListsBloc,
                          smartContactsBloc: _smartContactsBloc,
                          basketState: basketState),
                      if (basketState is BasketEmptyState) //в корзине нет товаров
                        BasketEmpty(decorationForContent: _decorationForContent)
                      // else if (basketState is BasketLoadingState)
                      //   Expanded(
                      //     child: Container(
                      //       decoration: _decorationForContent(context),
                      //       alignment: Alignment.center,
                      //       child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(blackColor)),
                      //     ),
                      //   )
                      else if (basketState is BasketErrorState)
                        BasketError(basketListBloc: _basketListBloc, decorationForContent: _decorationForContent)
                      else
                        Expanded(
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                                topRight: Radius.circular(heightRatio(size: 15, context: context)),
                              ),
                            ),
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: heightRatio(size: 20, context: context)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BasketList(),
                                    SizedBox(height: 16),
                                    // Введите промокод:
                                    BlocBuilder<OrderCalculateBloc, OrderCalculateState>(
                                      builder: (context, orderCalculateState) {
                                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: []);
                                      },
                                    ),
                                    SizedBox(height: 50),
                                    RecommendationListWidget(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

BoxDecoration _decorationForContent(BuildContext context) => BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(heightRatio(size: 15, context: context)),
        topRight: Radius.circular(heightRatio(size: 15, context: context)),
      ),
    );
