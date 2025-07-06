
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_model.dart';
import 'package:smart/models/meta_model.dart';

class AddressesShopListModel {
  List<AddressesShopModel> data;
  MetaModel meta;
  AddressesShopListModel({this.data, this.meta});

  factory AddressesShopListModel.fromJson(Map<String, dynamic> json) => AddressesShopListModel(
        data: List<AddressesShopModel>.from(json["data"].map((x) => AddressesShopModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}
