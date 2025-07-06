import 'package:smart/models/meta_model.dart';

class OnboardingListModel {
  OnboardingListModel({
    this.data,
    this.meta,
  });

  List<OnboardingListDataModel> data;
  MetaModel meta;

  factory OnboardingListModel.fromJson(Map<String, dynamic> json) =>
      OnboardingListModel(
        data: List<OnboardingListDataModel>.from(
            json["data"].map((x) => OnboardingListDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class OnboardingListDataModel {
  OnboardingListDataModel({
    this.uuid,
    this.title,
    this.sortNumber,
    this.logoFileUuid,
    this.logoFilePath,
    this.createdAt,
  });

  String uuid;
  String title;
  int sortNumber;
  String logoFileUuid;
  String logoFilePath;
  String createdAt;

  factory OnboardingListDataModel.fromJson(Map<String, dynamic> json) =>
      OnboardingListDataModel(
        uuid: json["uuid"],
        title: json["title"],
        sortNumber: json["sort_number"],
        logoFileUuid: json["logo_file_uuid"],
        logoFilePath: json["logo_file_path"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "title": title,
        "sort_number": sortNumber,
        "logo_file_uuid": logoFileUuid,
        "logo_file_path": logoFilePath,
        "created_at": createdAt,
      };
}
