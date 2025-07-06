import 'package:smart/models/meta_model.dart';
import 'package:smart/order_process/order_process_item_model.dart';

class OrderProcessListModel {
  OrderProcessListModel({
    this.data,
    this.meta,
  });

  List<OrderProcessItemModel> data;
  MetaModel meta;

  factory OrderProcessListModel.fromJson(Map<String, dynamic> json) => OrderProcessListModel(
        data: List<OrderProcessItemModel>.from(json["data"].map((x) => OrderProcessItemModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}
