import 'package:smart/features/catalog/models/catalog_list_model.dart';
import 'package:smart/models/meta_model.dart';

class CatalogsModel {
  CatalogsModel({
    this.data,
    this.meta,
  });

  List<CatalogListModel> data;
  MetaModel meta;

  factory CatalogsModel.fromJson(Map<String, dynamic> json) => CatalogsModel(
        data: List<CatalogListModel>.from(json["data"].map((x) => CatalogListModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}
