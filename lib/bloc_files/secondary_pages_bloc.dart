import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SecondaryPageEvent {}

class ShoppingListDetailsOpenEvent extends SecondaryPageEvent {
  final String shoppingListName;

  ShoppingListDetailsOpenEvent({@required this.shoppingListName});
}

class HomeEvent extends SecondaryPageEvent {}

class NotificationPageLoadEvent extends SecondaryPageEvent {}

// class ProductInShopPageLoadEvent extends SecondaryPageEvent {
//   final List<ProductDetailsStoreListModel> storesListModel;
//   final String assortmentUnitId;

//   ProductInShopPageLoadEvent(
//       {@required this.assortmentUnitId, @required this.storesListModel});
// }

class ShoppingListsPageEvent extends SecondaryPageEvent {}

class PromoDescriptionsPageopenEvent extends SecondaryPageEvent {}

class CatalogEvent extends SecondaryPageEvent {}

class ImInShopPageOpenEvent extends SecondaryPageEvent {}

class BasketPageLoadEvent extends SecondaryPageEvent {}

class DiverseFoodPageOpenEvent extends SecondaryPageEvent {}

class ProfilePageEvent extends SecondaryPageEvent {}

class FavoritePageOpenEvent extends SecondaryPageEvent {}

class HistoryCheckDetailsPageLoadEvent extends SecondaryPageEvent {
  final String checkNumber;
  HistoryCheckDetailsPageLoadEvent({@required this.checkNumber});
}

class HistoryOrderDetailsPageLoadEvent extends SecondaryPageEvent {
  final String orderNumber;

  HistoryOrderDetailsPageLoadEvent({@required this.orderNumber});
}

class ProfileSecondaryPageEvent extends SecondaryPageEvent {}

class ContactsEvent extends SecondaryPageEvent {}

class ShopsOpenEvent extends SecondaryPageEvent {
  final SecondaryPageEvent secondaryPageEvent;

  ShopsOpenEvent({@required this.secondaryPageEvent});
}

class ProductDetailsonSecondaryPageEvent extends SecondaryPageEvent {
  final String productsQuantity;

  ProductDetailsonSecondaryPageEvent({@required this.productsQuantity});
}

//states

abstract class SecondaryPageState {}

class SecondaryHomePageState extends SecondaryPageState {}

class SecondaryCatalogPageState extends SecondaryPageState {}

class SecondaryBasketPageState extends SecondaryPageState {}

class SecondaryProfilePageState extends SecondaryPageState {}

class SecondaryPageBloc extends Bloc<SecondaryPageEvent, SecondaryPageState> {
  // Widget _indexList = HomePage();
  SecondaryPageBloc(SecondaryPageState initialState) : super(initialState);

  @override
  Stream<SecondaryPageState> mapEventToState(event) async* {
    if (event is HomeEvent) {
      yield SecondaryHomePageState();
    }

    if (event is CatalogEvent) {
      yield SecondaryCatalogPageState();
    }

    if (event is BasketPageLoadEvent) {
      yield SecondaryBasketPageState();
    }

    if (event is ProfilePageEvent) {
      yield SecondaryProfilePageState();
    }

    // if (event is HistoryCheckDetailsPageLoadEvent) {
    //   _indexList = HistoryCheckDetailsPage(checkDate: event.checkNumber);
    // }
    // if (event is DiverseFoodPageOpenEvent) {
    //   _indexList = SecondaryPage(
    //       upText: "diverseFoodOneLineText".tr(),
    //       contentWidget: DiverseFoodContent());
    // }

    // if (event is HistoryOrderDetailsPageLoadEvent) {
    //   _indexList = HistoryOrderDetailsPage(
    //     orderDate: event.orderNumber,
    //   );
    // }

    // if (event is ProfileSecondaryPageEvent) {
    //   _indexList = ProfilePage();
    // }
    // if (event is ContactsEvent) {
    //   _indexList = SecondaryPage(
    //       upText: "contactsText".tr(),
    //       contentWidget: Center(child: ContactsWidget()));
    // }

    // if (event is NotificationPageLoadEvent) {
    //   _indexList = SecondaryPage(
    //       upText: "Уведомления",
    //       contentWidget: NotificationListWidget());
    // }

    // if (event is ShopsOpenEvent) {
    //   _indexList = ShopsPage(
    //     secondaryPageEvent: event.secondaryPageEvent,
    //   );
    // }
    // if (event is ProductDetailsonSecondaryPageEvent) {
    //   _indexList = ProductDetailsPage(
    //     productsQuantity: event.productsQuantity,
    //   );
    // }
    // if (event is ShoppingListsPageEvent) {
    //   _indexList = ShoppinglistsPage();
    // }
    // if (event is ShoppingListDetailsOpenEvent) {
    //   _indexList =
    //       ShoppingListDetailsPage(shoppingListName: event.shoppingListName);
    // }
    // if (event is FavoritePageOpenEvent) {
    //   _indexList = FavoriteProductPage();
    // }

    // if (event is PromoDescriptionsPageopenEvent) {
    //   _indexList = SecondaryPage(
    //       upText: "promoText".tr(), contentWidget: PromoDescriptionsContent());
    // }

    // if (event is ImInShopPageOpenEvent) {
    //   _indexList = ImInShopPage();
    // }

    // if (event is ProductInShopPageLoadEvent) {
    //   _indexList = ProductInShopPage(
    //     storesListModel: event.storesListModel,
    //     assortmentUnitId: event.assortmentUnitId,
    //   );
    // }
  }
}
