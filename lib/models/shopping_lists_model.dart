import 'package:smart/models/meta_model.dart';
import 'package:smart/models/shopping_list_data_model.dart';

class ShoppingListsModel {
  ShoppingListsModel({
    this.data,
    this.meta,
  });

  List<ShoppingListDataModel> data;
  MetaModel meta;

  factory ShoppingListsModel.fromJson(Map<String, dynamic> json) =>
      ShoppingListsModel(
        data: List<ShoppingListDataModel>.from(
            json["data"].map((x) => ShoppingListDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}
