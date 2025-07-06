import 'package:flutter/cupertino.dart';
import 'package:smart/services/services.dart';

class ShopDetailRepository {
  String uuid;
  ShopDetailRepository({@required this.uuid}) : assert(uuid != null);
  ShopDetailsProvider _shopDetailsProvider = ShopDetailsProvider();
  getShopDetailsFromRepository() async =>
      await _shopDetailsProvider.getShopDetails(uuid);
}
