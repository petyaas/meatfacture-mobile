import 'package:smart/models/Assortments_image_model.dart';
import 'package:smart/models/meta_model.dart';
import 'package:smart/core/constants/source.dart';

class FavoriteProductModel {
  FavoriteProductModel({
    this.data,
    this.meta,
  });

  List<FavoriteProductDataModel> data;
  MetaModel meta;

  factory FavoriteProductModel.fromJson(Map<String, dynamic> json) => FavoriteProductModel(
        data: List<FavoriteProductDataModel>.from(json["data"].map((x) => FavoriteProductDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class FavoriteProductDataModel {
  FavoriteProductDataModel({
    this.uuid,
    this.clientUuid,
    this.assortmentUuid,
    this.assortmentName,
    this.discountPercent,
    this.activeFrom,
    this.activeTo,
    this.createdAt,
    this.updatedAt,
    this.images,
    this.assortmentUnitId,
    this.priceWithDiscount,
    this.currentPrice,
  });

  String uuid;
  String clientUuid;
  double priceWithDiscount;
  double currentPrice;
  String assortmentUuid;
  String assortmentName;
  String discountPercent;
  String activeFrom;
  String activeTo;
  String createdAt;
  String updatedAt;
  String assortmentUnitId;
  List<ImageModel> images;

  factory FavoriteProductDataModel.fromJson(Map<String, dynamic> json) => FavoriteProductDataModel(
      uuid: json["uuid"],
      currentPrice: json["current_price"].toString().toDouble(),
      assortmentUnitId: json["assortment_unit_id"],
      clientUuid: json["client_uuid"],
      images: List<ImageModel>.from(json["images"].map((x) => ImageModel.fromJson(x))),
      assortmentUuid: json["assortment_uuid"],
      assortmentName: json["assortment_name"],
      discountPercent: json["discount_percent"],
      activeFrom: json["active_from"],
      activeTo: json["active_to"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      priceWithDiscount: json["price_with_discount"].toString().toDouble());

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "current_price": currentPrice,
        "price_with_discount": priceWithDiscount,
        "assortment_unit_id": assortmentUnitId,
        "client_uuid": clientUuid,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "assortment_uuid": assortmentUuid,
        "assortment_name": assortmentName,
        "discount_percent": discountPercent,
        "active_from": activeFrom,
        "active_to": activeTo,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
