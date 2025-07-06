import 'package:smart/models/Assortments_image_model.dart';

class ProductDetailsDataModel {
  ProductDetailsDataModel({
    this.uuid,
    this.catalogUuid,
    this.catalogName,
    this.name,
    this.shortName,
    this.assortmentUnitId,
    this.countryId,
    this.weight,
    this.volume,
    this.manufacturer,
    this.ingredients,
    this.description,
    this.temperatureMin,
    this.temperatureMax,
    this.productionStandardId,
    this.productionStandardNumber,
    this.shelfLife,
    this.rating,
    this.images,
    this.stores,
    this.isFavorite,
    this.tags,
    this.userShoppingLists,
    this.currentPrice,
    this.properties,
    this.discountTypeName,
    this.quantityInClientCart,
    this.priceWithDiscount,
    this.discountType,
    this.productsQuantity,
    this.discountTypeColor,
    this.isPromoFavorite,
    this.totalBonus,
    this.bonusPercent,
    this.discountActiveTill,
  });

  String uuid;
  String discountTypeName;
  String discountType;
  String discountTypeColor;
  int totalBonus;
  double bonusPercent;

  String currentPrice;
  double priceWithDiscount;
  String catalogUuid;
  String catalogName;
  String name;
  String shortName;
  String assortmentUnitId;
  List<ProductDetailsPropertyModel> properties;
  String countryId;
  String weight;
  double productsQuantity;
  String volume;
  dynamic manufacturer;
  double quantityInClientCart;
  dynamic ingredients;
  dynamic description;
  dynamic temperatureMin;
  int temperatureMax;
  String productionStandardId;
  String productionStandardNumber;
  int shelfLife;
  double rating;
  List<ImageModel> images;
  List<ProductDetailsStoreListModel> stores;
  bool isFavorite;
  bool isPromoFavorite;
  List<String> tags;
  List<ProductDetailsUserShoppingList> userShoppingLists;
  String discountActiveTill;

  factory ProductDetailsDataModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailsDataModel(
        discountActiveTill: json["discount_active_till"],
        uuid: json["uuid"],
        totalBonus: json["total_bonus"],
        bonusPercent: json["bonus_percent"] == null
            ? null
            : double.parse(json["bonus_percent"].toString()),
        productsQuantity: json["products_quantity"] == null
            ? null
            : double.parse(json["products_quantity"].toString()),
        discountTypeColor: json["discount_type_color"],
        discountType: json["discount_type"],
        discountTypeName: json["discount_type_name"],
        quantityInClientCart: json["quantity_in_client_cart"] != null
            ? double.parse(json["quantity_in_client_cart"].toString())
            : null,
        catalogUuid: json["catalog_uuid"],
        catalogName: json["catalog_name"],
        properties: List<ProductDetailsPropertyModel>.from(json["properties"]
            .map((x) => ProductDetailsPropertyModel.fromJson(x))),
        name: json["name"],
        shortName: json["short_name"],
        assortmentUnitId: json["assortment_unit_id"],
        countryId: json["country_id"],
        weight: json["weight"],
        volume: json["volume"],
        priceWithDiscount: json["price_with_discount"] == null
            ? null
            : double.parse(json["price_with_discount"].toString()),
        isPromoFavorite: json["is_promo_favorite"],
        manufacturer: json["manufacturer"],
        ingredients: json["ingredients"],
        description: json["description"],
        temperatureMin: json["temperature_min"],
        temperatureMax: json["temperature_max"],
        productionStandardId: json["production_standard_id"],
        productionStandardNumber: json["production_standard_number"],
        shelfLife: json["shelf_life"],
        rating: json["rating"] == null
            ? null
            : double.parse(json["rating"].toString()),
        images: List<ImageModel>.from(
            json["images"].map((x) => ImageModel.fromJson(x))),
        stores: List<ProductDetailsStoreListModel>.from(json["stores"]
            .map((x) => ProductDetailsStoreListModel.fromJson(x))),
        isFavorite: json["is_favorite"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        userShoppingLists: List<ProductDetailsUserShoppingList>.from(
            json["user_shopping_lists"]
                .map((x) => ProductDetailsUserShoppingList.fromJson(x))),
        currentPrice: json["current_price"] == null
            ? null
            : json["current_price"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "properties": List<dynamic>.from(properties.map((x) => x.toJson())),
        "uuid": uuid,
        "discount_active_till": discountActiveTill,
        "price_with_discount": priceWithDiscount,
        "discount_type_color": discountTypeColor,
        "discount-type": discountType,
        "discount-type-name": discountTypeName,
        "catalog_uuid": catalogUuid,
        "catalog_name": catalogName,
        "current_price": currentPrice,
        "products_quantity": productsQuantity,
        "name": name,
        "quantity_in_client_cart": quantityInClientCart,
        "is_promo_favorite": isPromoFavorite,
        "short_name": shortName,
        "assortment_unit_id": assortmentUnitId,
        "country_id": countryId,
        "weight": weight,
        "volume": volume,
        "manufacturer": manufacturer,
        "ingredients": ingredients,
        "description": description,
        "temperature_min": temperatureMin,
        "temperature_max": temperatureMax,
        "production_standard_id": productionStandardId,
        "production_standard_number": productionStandardNumber,
        "shelf_life": shelfLife,
        "rating": rating,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "stores": List<dynamic>.from(stores.map((x) => x.toJson())),
        "is_favorite": isFavorite,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "user_shopping_lists":
            List<dynamic>.from(userShoppingLists.map((x) => x.toJson())),
      };
}

//stores
class ProductDetailsStoreListModel {
  ProductDetailsStoreListModel({
    this.uuid,
    this.brandName,
    this.address,
    this.addressLatitude,
    this.addressLongitude,
    this.loyaltyCardTypes,
    this.isSelected,
    this.productsQuantity,
  });

  String uuid;
  bool isSelected = false;
  String brandName;
  String address;
  String addressLatitude;
  String addressLongitude;
  List<ProductDetailsStoreLoyaltyCardTypeModel> loyaltyCardTypes;
  dynamic productsQuantity;

  factory ProductDetailsStoreListModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailsStoreListModel(
        uuid: json["uuid"],
        brandName: json["brand_name"],
        address: json["address"],
        addressLatitude: json["address_latitude"],
        addressLongitude: json["address_longitude"],
        loyaltyCardTypes: List<ProductDetailsStoreLoyaltyCardTypeModel>.from(
            json["loyalty_card_types"].map(
                (x) => ProductDetailsStoreLoyaltyCardTypeModel.fromJson(x))),
        productsQuantity: json["products_quantity"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "brand_name": brandName,
        "address": address,
        "address_latitude": addressLatitude,
        "address_longitude": addressLongitude,
        "loyalty_card_types":
            List<dynamic>.from(loyaltyCardTypes.map((x) => x.toJson())),
        "products_quantity": productsQuantity,
      };
}

class ProductDetailsStoreLoyaltyCardTypeModel {
  ProductDetailsStoreLoyaltyCardTypeModel({
    this.uuid,
  });

  String uuid;

  factory ProductDetailsStoreLoyaltyCardTypeModel.fromJson(
          Map<String, dynamic> json) =>
      ProductDetailsStoreLoyaltyCardTypeModel(
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
      };
}

class ProductDetailsUserShoppingList {
  ProductDetailsUserShoppingList({
    this.uuid,
    this.name,
  });

  String uuid;
  String name;

  factory ProductDetailsUserShoppingList.fromJson(Map<String, dynamic> json) =>
      ProductDetailsUserShoppingList(
        uuid: json["uuid"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
      };
}

class ProductDetailsPropertyModel {
  ProductDetailsPropertyModel({
    this.uuid,
    this.name,
    this.assortmentPropertyDataTypeId,
    this.availableValues,
    this.isSearchable,
    this.value,
  });

  String uuid;
  String name;
  String assortmentPropertyDataTypeId;
  List<String> availableValues;
  bool isSearchable;
  String value;

  factory ProductDetailsPropertyModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailsPropertyModel(
        uuid: json["uuid"],
        name: json["name"],
        assortmentPropertyDataTypeId: json["assortment_property_data_type_id"],
        availableValues:
            List<String>.from(json["available_values"].map((x) => x)),
        isSearchable: json["is_searchable"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
        "assortment_property_data_type_id": assortmentPropertyDataTypeId,
        "available_values": List<dynamic>.from(availableValues.map((x) => x)),
        "is_searchable": isSearchable,
        "value": value,
      };
}
