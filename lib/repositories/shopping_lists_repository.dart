import 'package:smart/services/services.dart';

class ShoppingListsRepository {
  ShoppingListsProvider _shoppingListsProvider = ShoppingListsProvider();
  getShoppingListsFromRepository() async =>
      await _shoppingListsProvider.getShoppingListsResponse();
}
