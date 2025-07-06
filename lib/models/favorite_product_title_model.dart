import 'package:smart/models/meta_model.dart';

class FavoriteProductTitleModel {
  FavoriteProductTitleModel({
    this.data,
    this.meta,
  });

  List<FavoriteProductTitleDataModel> data;
  MetaModel meta;

  factory FavoriteProductTitleModel.fromJson(Map<String, dynamic> json) =>
      FavoriteProductTitleModel(
        data: List<FavoriteProductTitleDataModel>.from(
            json["data"].map((x) => FavoriteProductTitleDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class FavoriteProductTitleDataModel {
  FavoriteProductTitleDataModel({
    this.uuid,
    this.name,
    this.title,
    this.description,
    this.logoFileUuid,
    this.logoFilePath,
    this.discountType,
    this.color,
    this.isHidden,
    this.createdAt,
    this.updatedAt,
  });

  String uuid;
  String name;
  String title;
  String description;
  dynamic logoFileUuid;
  dynamic logoFilePath;
  String discountType;
  dynamic color;
  bool isHidden;
  String createdAt;
  String updatedAt;

  factory FavoriteProductTitleDataModel.fromJson(Map<String, dynamic> json) =>
      FavoriteProductTitleDataModel(
        uuid: json["uuid"],
        name: json["name"],
        title: json["title"],
        description: json["description"],
        logoFileUuid: json["logo_file_uuid"],
        logoFilePath: json["logo_file_path"],
        discountType: json["discount_type"],
        color: json["color"],
        isHidden: json["is_hidden"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
        "title": title,
        "description": description,
        "logo_file_uuid": logoFileUuid,
        "logo_file_path": logoFilePath,
        "discount_type": discountType,
        "color": color,
        "is_hidden": isHidden,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
