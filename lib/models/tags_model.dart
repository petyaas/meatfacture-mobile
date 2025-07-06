import 'package:smart/models/meta_model.dart';
import 'package:smart/models/tags_list_model.dart';

class TagsModel {
  TagsModel({
    this.data,
    this.meta,
  });

  List<TagsListModel> data;
  MetaModel meta;

  factory TagsModel.fromJson(Map<String, dynamic> json) => TagsModel(
        data: List<TagsListModel>.from(
            json["data"].map((x) => TagsListModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}
