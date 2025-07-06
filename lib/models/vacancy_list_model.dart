import 'package:smart/models/meta_model.dart';

class VacancyListModel {
    VacancyListModel({
        this.data,
        this.meta,
    });

    List<VacancyListDataModel> data;
    MetaModel meta;

    factory VacancyListModel.fromJson(Map<String, dynamic> json) => VacancyListModel(
        data: List<VacancyListDataModel>.from(json["data"].map((x) => VacancyListDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
    };
}

class VacancyListDataModel {
    VacancyListDataModel({
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

    factory VacancyListDataModel.fromJson(Map<String, dynamic> json) => VacancyListDataModel(
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