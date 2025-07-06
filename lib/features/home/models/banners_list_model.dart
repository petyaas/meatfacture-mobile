import 'package:smart/models/meta_model.dart';

class BannersListModel {
  BannersListModel({
    this.data,
    this.meta,
  });

  List<BannersListDataModel> data;
  MetaModel meta;

  factory BannersListModel.fromJson(Map<String, dynamic> json) => BannersListModel(
        data: List<BannersListDataModel>.from(json["data"].map((x) => BannersListDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class BannersListDataModel {
  BannersListDataModel({
    this.id,
    this.name,
    this.logoFilePath,
    this.description,
    this.number,
    this.enabled,
    this.createdAt,
    this.referenceType,
    this.referenceUuid,
  });

  int id;
  String name;
  String logoFilePath;
  String description;
  int number;
  bool enabled;
  String createdAt;
  String referenceType;
  String referenceUuid;

  factory BannersListDataModel.fromJson(Map<String, dynamic> json) => BannersListDataModel(
        id: json["id"],
        name: json["name"],
        logoFilePath: json["logo_file_path"],
        description: json["description"],
        number: json["number"],
        enabled: json["enabled"],
        createdAt: json["created_at"],
        referenceType: json["reference_type"],
        referenceUuid: json["reference_uuid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo_file_path": logoFilePath,
        "description": description,
        "number": number,
        "enabled": enabled,
        "created_at": createdAt,
        "reference_type": referenceType,
        "reference_uuid": referenceUuid,
      };
}
