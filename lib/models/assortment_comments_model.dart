import 'package:smart/models/meta_model.dart';

class AssortmentCommentsModel {
  AssortmentCommentsModel({
    this.data,
    this.meta,
  });

  List<AssortmentCommentsDataModel> data;
  MetaModel meta;

  factory AssortmentCommentsModel.fromJson(Map<String, dynamic> json) =>
      AssortmentCommentsModel(
        data: List<AssortmentCommentsDataModel>.from(
            json["data"].map((x) => AssortmentCommentsDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class AssortmentCommentsDataModel {
  AssortmentCommentsDataModel({
    this.createdAt,
    this.assortmentUuid,
    this.assortmentName,
    this.value,
    this.comment,
    this.clientUuid,
    this.clientName,
  });

  String createdAt;
  String assortmentUuid;
  String assortmentName;
  int value;
  String comment;
  String clientUuid;
  String clientName;

  factory AssortmentCommentsDataModel.fromJson(Map<String, dynamic> json) =>
      AssortmentCommentsDataModel(
        createdAt: json["created_at"],
        assortmentUuid: json["assortment_uuid"],
        assortmentName: json["assortment_name"],
        value: json["value"],
        comment: json["comment"],
        clientUuid: json["client_uuid"],
        clientName: json["client_name"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "assortment_uuid": assortmentUuid,
        "assortment_name": assortmentName,
        "value": value,
        "comment": comment,
        "client_uuid": clientUuid,
        "client_name": clientName,
      };
}
