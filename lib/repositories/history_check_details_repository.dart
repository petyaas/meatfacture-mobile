import 'package:flutter/material.dart';
import 'package:smart/services/services.dart';

class HistoryCheckDeatilsRepository {
  CheckDetailsProvider _checkDetailsProvider = CheckDetailsProvider();
  getHistoryCheckDeatilsFromRepository({@required String receiptUuid}) async {
    return await _checkDetailsProvider.getCheckDetailsResponse(
        receiptUuid: receiptUuid);
  }
}
