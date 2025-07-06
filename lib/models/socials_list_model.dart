import 'package:smart/models/meta_model.dart';

class SocialsListModel {
  SocialsListModel({
    this.data,
    this.meta,
  });

  List<SocialsListDataModel> data;
  MetaModel meta;

  factory SocialsListModel.fromJson(Map<String, dynamic> json) =>
      SocialsListModel(
        data: List<SocialsListDataModel>.from(
            json["data"].map((x) => SocialsListDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class SocialsListDataModel {
  SocialsListDataModel({
    this.uuid,
    this.title,
    this.sortNumber,
    this.url,
    this.logoFileUuid,
    this.logoFilePath,
    this.createdAt,
  });

  String uuid;
  String title;
  int sortNumber;
  String url;
  String logoFileUuid;
  String logoFilePath;
  String createdAt;

  factory SocialsListDataModel.fromJson(Map<String, dynamic> json) =>
      SocialsListDataModel(
        uuid: json["uuid"],
        title: json["title"],
        sortNumber: json["sort_number"],
        url: json["url"],
        logoFileUuid: json["logo_file_uuid"],
        logoFilePath: json["logo_file_path"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "title": title,
        "sort_number": sortNumber,
        "url": url,
        "logo_file_uuid": logoFileUuid,
        "logo_file_path": logoFilePath,
        "created_at": createdAt,
      };
}
