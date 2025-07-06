import 'package:smart/models/Assortments_image_model.dart';
import 'package:smart/models/meta_model.dart';

class DiverseFoodAssortmentListModel {
  DiverseFoodAssortmentListModel({
    this.data,
    this.meta,
  });

  List<DiverseFoodAssortmentListDataModel> data;
  MetaModel meta;

  factory DiverseFoodAssortmentListModel.fromJson(Map<String, dynamic> json) =>
      DiverseFoodAssortmentListModel(
        data: List<DiverseFoodAssortmentListDataModel>.from(json["data"]
            .map((x) => DiverseFoodAssortmentListDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class DiverseFoodAssortmentListDataModel {
  DiverseFoodAssortmentListDataModel({
    this.source,
    this.sourceId,
    this.sourceLine,
    this.sourceLineId,
    this.productUuid,
    this.assortment,
    this.quantity,
    this.totalWeight,
    this.priceWithDiscount,
    this.discount,
    this.originalPrice,
    this.totalDiscount,
    this.totalBonus,
    this.paidBonus,
    this.discountableType,
    this.discountTypeColor,
    this.discountTypeName,
    this.rating,
    this.ratingComment,
    this.createdAt,
  });

  String source;
  String sourceId;
  String sourceLine;
  String sourceLineId;
  String productUuid;
  Assortment assortment;
  String quantity;
  double totalWeight;
  String priceWithDiscount;
  String discount;
  double originalPrice;
  double totalDiscount;
  dynamic totalBonus;
  dynamic paidBonus;
  dynamic discountableType;
  String discountTypeColor;
  String discountTypeName;
  double rating;
  String ratingComment;
  String createdAt;

  factory DiverseFoodAssortmentListDataModel.fromJson(
          Map<String, dynamic> json) =>
      DiverseFoodAssortmentListDataModel(
        source: json["source"],
        sourceId: json["source_id"],
        sourceLine: json["source_line"],
        sourceLineId: json["source_line_id"],
        productUuid: json["product_uuid"],
        assortment: Assortment.fromJson(json["assortment"]),
        quantity: json["quantity"],
        totalWeight: json["total_weight"] == null
            ? null
            : double.parse(json["total_weight"].toString()),
        priceWithDiscount: json["price_with_discount"],
        discount: json["discount"],
        originalPrice: json["original_price"] == null
            ? null
            : double.parse(json["original_price"].toString()),
        totalDiscount: json["total_discount"] == null
            ? null
            : double.parse(json["total_discount"].toString()),
        totalBonus: json["total_bonus"],
        paidBonus: json["paid_bonus"],
        discountableType: json["discountable_type"],
        discountTypeColor: json["discount_type_color"],
        discountTypeName: json["discount_type_name"],
        rating: json["rating"] == null
            ? null
            : double.parse(json["rating"].toString()),
        ratingComment: json["rating_comment"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "source": source,
        "source_id": sourceId,
        "source_line": sourceLine,
        "source_line_id": sourceLineId,
        "product_uuid": productUuid,
        "assortment": assortment.toJson(),
        "quantity": quantity,
        "total_weight": totalWeight,
        "price_with_discount": priceWithDiscount,
        "discount": discount,
        "original_price": originalPrice,
        "total_discount": totalDiscount,
        "total_bonus": totalBonus,
        "paid_bonus": paidBonus,
        "discountable_type": discountableType,
        "discount_type_color": discountTypeColor,
        "discount_type_name": discountTypeName,
        "rating": rating,
        "rating_comment": ratingComment,
        "created_at": createdAt,
      };
}

class Assortment {
  Assortment({
    this.uuid,
    this.name,
    this.catalogUuid,
    this.catalogName,
    this.rating,
    this.images,
  });
  String uuid;
  String name;
  String catalogUuid;
  String catalogName;
  double rating;
  List<ImageModel> images;

  factory Assortment.fromJson(Map<String, dynamic> json) => Assortment(
        uuid: json["uuid"],
        name: json["name"],
        catalogUuid: json["catalog_uuid"],
        catalogName: json["catalog_name"],
        rating: json["rating"] == null
            ? null
            : double.parse(json["rating"].toString()),
        images: List<ImageModel>.from(
            json["images"].map((x) => ImageModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
        "catalog_uuid": catalogUuid,
        "catalog_name": catalogName,
        "rating": rating,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}
