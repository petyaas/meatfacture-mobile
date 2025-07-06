import 'package:smart/models/Assortments_image_model.dart';

class ShoppingListsAssortmentModel {
  String uuid;
  double productsQuantity;
  String discountTypeName;
  String discountType;
  String discountTypeColor;
  double priceWithDiscount;
  String name;
  double rating;
  List<ImageModel> images;
  String currentPrice;
  double quantity;
  String assortmentUnitId;
  String weight;
  bool isFavorite;
  ShoppingListsAssortmentModel({
    this.uuid,
    this.name,
    this.rating,
    this.images,
    this.quantity,
    this.currentPrice,
    this.discountType,
    this.discountTypeColor,
    this.discountTypeName,
    this.priceWithDiscount,
    this.productsQuantity,
    this.assortmentUnitId,
    this.weight,
    this.isFavorite,
  });

  factory ShoppingListsAssortmentModel.fromJson(Map<String, dynamic> json) => ShoppingListsAssortmentModel(
        weight: json["weight"],
        isFavorite: json["is_favorite"],
        currentPrice: json["current_price"] == null ? null : json["current_price"],
        priceWithDiscount: json["price_with_discount"] == null ? null : double.parse(json["price_with_discount"].toString()),
        productsQuantity: json["products_quantity"] == null ? null : double.parse(json["products_quantity"].toString()),
        discountTypeColor: json["discount_type_color"],
        discountType: json["discount_type"],
        discountTypeName: json["discount_type_name"],
        uuid: json["uuid"],
        assortmentUnitId: json["assortment_unit_id"],
        name: json["name"],
        rating: json["rating"] != null ? (json["rating"] as num).toDouble() : null,
        images: List<ImageModel>.from(json["images"].map((x) => ImageModel.fromJson(x))),
        quantity: double.parse(json["quantity"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "current_price": currentPrice,
        "price_with_discount": priceWithDiscount,
        "uuid": uuid,
        "products_quantity": productsQuantity,
        "discount_type_color": discountTypeColor,
        "discount-type": discountType,
        "discount-type-name": discountTypeName,
        "name": name,
        "weight": weight,
        "rating": rating,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "quantity": quantity,
        "is_favorite": isFavorite,
      };
}
