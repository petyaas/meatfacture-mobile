import 'package:smart/models/assortments_list_model.dart';
import 'package:smart/models/meta_model.dart';

class AssortmentsModel {
  AssortmentsModel({
    this.data,
    this.meta,
  });

  List<AssortmentsListModel> data;
  MetaModel meta;

  factory AssortmentsModel.fromJson(Map<String, dynamic> json) =>
      AssortmentsModel(
        data: List<AssortmentsListModel>.from(
            json["data"].map((x) => AssortmentsListModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}
