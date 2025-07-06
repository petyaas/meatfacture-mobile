
import 'package:smart/features/basket/models/basket_list_model.dart';
import 'package:smart/services/services.dart';

class BasketListRepository {
  Future<BasketListModel> getBasketListFromRepository() async {
    BasketProvider _basketProvider = BasketProvider();
    return await _basketProvider.getBasketListResponse();
  }
}
