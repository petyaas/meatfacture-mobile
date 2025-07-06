import 'package:flutter/material.dart';
import 'package:smart/services/services.dart';

class ShoppingListDetailsRepository {
  ShoppingListDetailsProvider _shoppingListDetailsProvider =
      ShoppingListDetailsProvider();
  getShoppingListDetailsFromProvider(
          {@required String shoppingListUuid}) async =>
      await _shoppingListDetailsProvider.getShoppingListDetailsResponse(
          shoppingListUuid: shoppingListUuid);
}
