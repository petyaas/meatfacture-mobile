import 'package:flutter/material.dart';
import 'package:smart/services/services.dart';

class HistoryCheckDetailsProductRepository {
  CheckDetailsProductsProvider _checkDetailsProductsProvider =
      CheckDetailsProductsProvider();
  getHistoryCheckDeatilsFromRepository({@required String receiptUuid}) async {
    return await _checkDetailsProductsProvider.getCheckDetailsProductsResponse(
        receiptUuid: receiptUuid);
  }
}
