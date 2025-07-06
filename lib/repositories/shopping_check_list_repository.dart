import 'package:flutter/material.dart';
import 'package:smart/services/services.dart';

class ShoppingCheckListRepository {
  ShoppingCheckListProvider _shoppingCheckListProvider = ShoppingCheckListProvider();
  getShoppingCheckListFromRepository() async {
    return await _shoppingCheckListProvider.getShoppingCheckListResponse();
  }

  getShoppingCheckListForPaginationFromRepository({@required int currentPage}) async {
    return await _shoppingCheckListProvider.getShoppingCheckListForPaginationResponse(
      currentPage: currentPage,
    );
  }
}
