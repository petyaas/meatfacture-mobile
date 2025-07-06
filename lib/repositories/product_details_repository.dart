import 'package:flutter/material.dart';
import 'package:smart/services/services.dart';

class ProductDetailsRepository {
  getProductDeatilsFromRepository({@required String uuid}) async {
    ProductDetailsProvider _productDetailsProvider =
        ProductDetailsProvider(uuid: uuid);
    return await _productDetailsProvider.getProductDetailsResponse();
  }
}
