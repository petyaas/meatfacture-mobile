import 'package:smart/models/meta_model.dart';

class FavoriteProductVariantUuidModel {
  FavoriteProductVariantUuidModel({
    this.data,
    this.meta,
  });

  List<FavoriteProductVariantUuidDataModel> data;
  MetaModel meta;

  factory FavoriteProductVariantUuidModel.fromJson(Map<String, dynamic> json) =>
      FavoriteProductVariantUuidModel(
        data: List<FavoriteProductVariantUuidDataModel>.from(json["data"]
            .map((x) => FavoriteProductVariantUuidDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class FavoriteProductVariantUuidDataModel {
  FavoriteProductVariantUuidDataModel({
    this.uuid,
    this.clientUuid,
    this.canBeActivatedTill,
    this.createdAt,
    this.updatedAt,
  });

  String uuid;
  String clientUuid;
  String canBeActivatedTill;
  String createdAt;
  String updatedAt;

  factory FavoriteProductVariantUuidDataModel.fromJson(
          Map<String, dynamic> json) =>
      FavoriteProductVariantUuidDataModel(
        uuid: json["uuid"],
        clientUuid: json["client_uuid"],
        canBeActivatedTill: json["can_be_activated_till"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "client_uuid": clientUuid,
        "can_be_activated_till": canBeActivatedTill,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
