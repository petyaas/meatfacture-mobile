import 'package:smart/models/assortments_list_model.dart';
import 'package:smart/models/meta_model.dart';

class RecomendationListModel {
  RecomendationListModel({
    this.data,
    this.meta,
  });

  List<AssortmentsListModel> data;
  MetaModel meta;

  factory RecomendationListModel.fromJson(Map<String, dynamic> json) =>
      RecomendationListModel(
        data: List<AssortmentsListModel>.from(
            json["data"].map((x) => AssortmentsListModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}
