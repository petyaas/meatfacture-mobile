import 'package:smart/models/meta_model.dart';

class BonusesListModel {
  BonusesListModel({
    this.data,
    this.meta,
  });

  List<BonusesListDataModel> data;
  MetaModel meta;

  factory BonusesListModel.fromJson(Map<String, dynamic> json) =>
      BonusesListModel(
        data: List<BonusesListDataModel>.from(
            json["data"].map((x) => BonusesListDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class BonusesListDataModel {
  BonusesListDataModel({
    this.uuid,
    this.clientUuid,
    this.relatedReferenceId,
    this.relatedReferenceType,
    this.reason,
    this.quantityOld,
    this.quantityNew,
    this.quantityDelta,
    this.createdAt,
  });

  String uuid;
  String clientUuid;
  String relatedReferenceId;
  String relatedReferenceType;
  String reason;
  int quantityOld;
  int quantityNew;
  int quantityDelta;
  DateTime createdAt;

  factory BonusesListDataModel.fromJson(Map<String, dynamic> json) =>
      BonusesListDataModel(
          uuid: json["uuid"],
          clientUuid: json["client_uuid"],
          relatedReferenceId: json["related_reference_id"] == null
              ? null
              : json["related_reference_id"],
          relatedReferenceType: json["related_reference_type"] == null
              ? null
              : json["related_reference_type"],
          reason: json["reason"],
          quantityOld: json["quantity_old"],
          quantityNew: json["quantity_new"],
          quantityDelta: json["quantity_delta"],
          createdAt:
              DateTime.parse(json["created_at"].replaceAll("+0300", "+0000")));

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "client_uuid": clientUuid,
        "related_reference_id":
            relatedReferenceId == null ? null : relatedReferenceId,
        "related_reference_type":
            relatedReferenceType == null ? null : relatedReferenceType,
        "reason": reason,
        "quantity_old": quantityOld,
        "quantity_new": quantityNew,
        "quantity_delta": quantityDelta,
        "created_at": createdAt.toString(),
      };
}
