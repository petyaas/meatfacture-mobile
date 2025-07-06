import 'package:smart/models/Assortments_image_model.dart';

class AssortmentsListModel {
  AssortmentsListModel({
    this.uuid,
    this.catalogUuid,
    this.catalogName,
    this.name,
    this.shortName,
    this.weight,
    this.volume,
    this.rating,
    this.images,
    this.manufacturer,
    this.discountType,
    this.discountTypeColor,
    this.discountTypeName,
    this.isFavorite,
    this.tags,
    this.currentPrice,
    this.productsQuantity,
    this.priceWithDiscount,
    this.assortmentUnitId,
    this.isPromoFavorite,
    this.quantityInClientCart,
    this.totalBonus,
    this.hasYellowPrice,
    this.isShow = false,
    this.isEmpty = false,
  });

  String uuid;

  String discountTypeName;
  String discountType;
  String discountTypeColor;

  String catalogUuid;
  String catalogName;
  String name;
  String shortName;
  String assortmentUnitId;
  double quantityInClientCart;
  String weight;
  String volume;
  bool hasYellowPrice;
  dynamic rating;
  List<ImageModel> images;
  dynamic manufacturer;
  bool isFavorite;
  double priceWithDiscount;
  bool isPromoFavorite;
  List<dynamic> tags;
  String currentPrice;
  var productsQuantity;
  double totalBonus;
  bool isbasketAdding = false;
  bool isShow;
  bool isEmpty;

  factory AssortmentsListModel.fromJson(Map<String, dynamic> json) => AssortmentsListModel(
        quantityInClientCart: json["quantity_in_client_cart"] != null ? double.parse(json["quantity_in_client_cart"].toString()) : null,
        hasYellowPrice: json["has_yellow_price"],
        totalBonus: json["total_bonus"] == null ? null : double.parse(json["total_bonus"].toString()),
        isPromoFavorite: json["is_promo_favorite"],
        assortmentUnitId: json["assortment_unit_id"],
        uuid: json["uuid"],
        discountTypeColor: json["discount_type_color"],
        discountType: json["discount_type"],
        discountTypeName: json["discount_type_name"],
        catalogUuid: json["catalog_uuid"],
        catalogName: json["catalog_name"],
        name: json["name"],
        shortName: json["short_name"],
        weight: json["weight"],
        volume: json["volume"],
        rating: json["rating"],
        priceWithDiscount: json["price_with_discount"] == null ? null : double.parse(json["price_with_discount"].toString()),
        images: List<ImageModel>.from(json["images"].map((x) => ImageModel.fromJson(x))),
        manufacturer: json["manufacturer"],
        isFavorite: json["is_favorite"],
        tags: List<dynamic>.from(json["tags"].map((x) => x)),
        currentPrice: json["current_price"].toString(),
        productsQuantity: json["products_quantity"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "has_yellow_price": hasYellowPrice,
        "is_promo_favorite": isPromoFavorite,
        "catalog_uuid": catalogUuid,
        "catalog_name": catalogName,
        "discount_type_color": discountTypeColor,
        "discount-type": discountType,
        "discount-type-name": discountTypeName,
        "name": name,
        "assortment_unit_id": assortmentUnitId,
        "short_name": shortName,
        "weight": weight,
        "volume": volume,
        "rating": rating,
        "quantity_in_client_cart": quantityInClientCart,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "manufacturer": manufacturer,
        "is_favorite": isFavorite,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "price_with_discount": priceWithDiscount,
        "current_price": currentPrice,
        "products_quantity": productsQuantity,
      };
}
