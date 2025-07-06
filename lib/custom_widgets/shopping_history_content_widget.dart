import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:smart/bloc_files/history_check_details_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/bloc_files/shopping_history_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/custom_widgets/order_list_widget.dart';
import 'package:smart/features/catalog/subcatalog_screen.dart';
import 'package:smart/main.dart';
import 'package:smart/models/shopping_check_list_data_model.dart';
import 'package:smart/pages/history_check_details_page.dart';
import 'package:smart/repositories/shopping_check_list_repository.dart';

// ignore: must_be_immutable
class ShoppingHisoryContentWidget extends StatelessWidget {
  final bool hasBack;
  final BuildContext mainContext;
  int i = 1;

  ShoppingHisoryContentWidget({Key key, @required this.hasBack, this.mainContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShoppingHistoryBloc _shoppingHistoryBloc = BlocProvider.of(context);
    HistoryCheckDetailsBloc _historyCheckDetailsBloc = BlocProvider.of<HistoryCheckDetailsBloc>(context);
    return BlocBuilder<ShoppingHistoryBloc, ShoppingHisoryState>(
      builder: (context, state) {
        if (state is ShoppingHistoryEmptytState) {
          BlocProvider.of<ShoppingHistoryBloc>(context).add(ShoppingHistoryCheckListEvent());
          return SizedBox.shrink();
        }

        if (state is ShoppingHistoryCheckLoadingState) {
          return SizedBox(
            height: heightRatio(size: 283, context: context),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(newRedDark),
              ),
            ),
          );
        }
        if (state is ShoppingHistoryCheckListLoadedState) {
          i = 1;
          return Expanded(
            child: PaginationView(
              // initialLoader: ShimmerHistoryCheckLoader(),
              initialLoader: SizedBox.shrink(),
              itemBuilder: (BuildContext context, ShoppingCheckListDataModel shoppingCheckListDataModel, int index) {
                DateTime createAt = DateTime.parse(shoppingCheckListDataModel.createdAt);
                return Slidable(
                  actionExtentRatio: 1 / 7,
                  actionPane: SlidableDrawerActionPane(),
                  child: InkWell(
                    onTap: () {
                      _historyCheckDetailsBloc.add(HistoryCheckDetailsLoadEvent(receiptUuid: shoppingCheckListDataModel.uuid));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return HistoryCheckDetailsPage(
                              checkDate: 'Чек' + " " + state.shoppingCheckListModel.data[index].id.toString(),
                            );
                          },
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: heightRatio(size: 18, context: context)),
                        Text(
                          'Магазин',
                          style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w400, color: colorBlack04),
                        ),
                        SizedBox(height: heightRatio(size: 5, context: context)),
                        Text(
                          shoppingCheckListDataModel.storeAddress,
                          style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), fontWeight: FontWeight.w400, color: Colors.black),
                        ),
                        SizedBox(height: heightRatio(size: 15, context: context)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${createAt.toFormatedDate()}",
                              style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w400, color: colorBlack04),
                            ),
                            Row(
                              children: [
                                shoppingCheckListDataModel.bonusToCharge != null && shoppingCheckListDataModel.bonusToCharge != 0
                                    ?
                                    // bonus container
                                    Container(
                                        margin: EdgeInsets.only(right: widthRatio(size: 15, context: context)),
                                        padding: EdgeInsets.all(widthRatio(size: 4, context: context)),
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius: BorderRadius.circular(heightRatio(size: 8, context: context)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: colorBlack03,
                                              spreadRadius: 0,
                                              blurRadius: 10,
                                              offset: Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: widthRatio(size: 20, context: context),
                                              height: heightRatio(size: 20, context: context),
                                              child: SvgPicture.asset('assets/images/bonus_vector.svg', width: widthRatio(size: 20, context: context), height: heightRatio(size: 20, context: context)),
                                            ),
                                            SizedBox(width: widthRatio(size: 5, context: context)),
                                            Text(shoppingCheckListDataModel.bonusToCharge.toString())
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: shoppingCheckListDataModel.total,
                                        style: appLabelTextStyle(fontSize: heightRatio(size: 17, context: context), color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: " ₽",
                                        style: appTextStyle(fontSize: heightRatio(size: 17, context: context), color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: heightRatio(size: 8, context: context)),
                        Divider()
                      ],
                    ),
                  ),
                );
              },
              preloadedItems: state.shoppingCheckListModel.data,
              paginationViewType: PaginationViewType.listView,
              pageFetch: (currentListSize) async {
                List<ShoppingCheckListDataModel> fetchPage = await ShoppingCheckListRepository().getShoppingCheckListForPaginationFromRepository(currentPage: ++i);
                state.shoppingCheckListModel.data += fetchPage;
                return fetchPage;
              },
              onEmpty: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/u_has_no_checks.svg',
                      width: widthRatio(size: 131, context: context),
                      height: heightRatio(size: 131, context: context),
                    ),
                    SizedBox(height: heightRatio(size: 30, context: context)),
                    Text(
                      'У вас еще нет чеков покупок',
                      textAlign: TextAlign.center,
                      style: appLabelTextStyle(
                        fontSize: heightRatio(size: 18, context: context),
                        color: newBlack,
                      ),
                    ),
                    SizedBox(height: heightRatio(size: 25, context: context)),
                    InkWell(
                      onTap: () {
                        hasBack ? Navigator.pop(mainContext) : BlocProvider.of<SecondaryPageBloc>(context).add(CatalogEvent());
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        margin: const EdgeInsets.only(right: 20, left: 20),
                        width: widthRatio(size: 205, context: context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: newRedDark,
                        ),
                        child: Text(
                          'Перейти к покупкам',
                          style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                        ),
                      ),
                    ),
                    SizedBox(height: heightRatio(size: 15, context: context)),
                    InkWell(
                      onTap: () async {
                        BlocProvider.of<SecondaryPageBloc>(context).add(CatalogEvent());
                        navigatorKey.currentState?.push(
                          MaterialPageRoute(
                            builder: (context) => SubcatalogScreen(isSearchPage: false, isFavorite: true),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        margin: const EdgeInsets.only(right: 20, left: 20),
                        width: widthRatio(size: 205, context: context),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
                        child: Text(
                          'Перейти в избранное',
                          style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onError: (dynamic error) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 15, context: context), left: widthRatio(size: 15, context: context), right: widthRatio(size: 15, context: context)),
                      decoration: BoxDecoration(color: colorBlack03, shape: BoxShape.circle),
                      child: SvgPicture.asset(
                        'assets/images/netErrorIcon.svg',
                        color: Colors.white,
                        height: heightRatio(size: 30, context: context),
                      ),
                    ),
                    SizedBox(height: heightRatio(size: 15, context: context)),
                    Text('Ошибка соединения с сервером', style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500)),
                    SizedBox(height: heightRatio(size: 10, context: context)),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        color: Colors.transparent,
                        child: Text(
                          'Попробуйте еще раз',
                          style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state is ShoppingHistoryOrdersListLoadedState) {
          return OrderListWidget();
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: heightRatio(size: 15, context: context),
                bottom: heightRatio(size: 15, context: context),
                left: widthRatio(size: 15, context: context),
                right: widthRatio(size: 15, context: context),
              ),
              decoration: BoxDecoration(color: colorBlack03, shape: BoxShape.circle),
              child: SvgPicture.asset('assets/images/netErrorIcon.svg', color: Colors.white, height: heightRatio(size: 30, context: context)),
            ),
            SizedBox(height: heightRatio(size: 15, context: context)),
            Text(
              'Ошибка соединения с сервером',
              style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: heightRatio(size: 10, context: context)),
            InkWell(
              onTap: () => _shoppingHistoryBloc.add(ShoppingHistoryCheckListEvent()),
              child: Container(
                color: Colors.transparent,
                child: Text(
                  'Попробуйте еще раз',
                  style: appHeadersTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
