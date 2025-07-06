import 'package:smart/models/meta_model.dart';
import 'package:smart/models/shopping_check_list_data_model.dart';

class ShoppingCheckListModel {
  ShoppingCheckListModel({
    this.data,
    this.meta,
  });

  List<ShoppingCheckListDataModel> data;
  MetaModel meta;

  factory ShoppingCheckListModel.fromJson(Map<String, dynamic> json) =>
      ShoppingCheckListModel(
        data: List<ShoppingCheckListDataModel>.from(
            json["data"].map((x) => ShoppingCheckListDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}
