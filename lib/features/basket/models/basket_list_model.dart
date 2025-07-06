import 'package:smart/features/basket/models/basket_list_assortment_property_model.dart';
import 'package:smart/features/basket/models/basket_list_store_model.dart';
import 'package:smart/models/Assortments_image_model.dart';

class BasketListModel {
  BasketListModel({this.data});

  List<BasketListDataModel> data;

  factory BasketListModel.fromJson(Map<String, dynamic> json) => BasketListModel(
        data: List<BasketListDataModel>.from(json["data"].map((x) => BasketListDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BasketListDataModel {
  BasketListDataModel({
    this.assortment,
    this.quantity,
  });

  BasketListAssortmentModel assortment;
  double quantity;

  factory BasketListDataModel.fromJson(Map<String, dynamic> json) => BasketListDataModel(
        assortment: BasketListAssortmentModel.fromJson(json["assortment"]),
        quantity: double.parse(json["quantity"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "assortment": assortment.toJson(),
        "quantity": quantity,
      };

  @override
  String toString() {
    return "assortment - $assortment, quantity - $quantity";
  }
}

class BasketListAssortmentModel {
  BasketListAssortmentModel({
    this.uuid,
    this.discountType,
    this.discountTypeColor,
    this.discountTypeName,
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
    this.priceWithDiscount, //цена со скидкой
    this.totalAmountWithDiscount, //сумма позиции
    this.price, //актуальная цена
    this.originalPrice, //цена без скидки
    this.currentPrice,
    this.stores,
    this.tags,
    this.properties,
    this.userShoppingLists,
    this.quantityInStore,
    this.bonusPercent,
  });

  String uuid;
  double quantityInStore;
  double bonusPercent;
  String catalogUuid;
  String catalogName;
  String discountTypeName;
  String discountType;
  String discountTypeColor;
  String name;
  double priceWithDiscount;
  double totalAmountWithDiscount;
  double price;
  double originalPrice;
  double currentPrice;
  String shortName;
  String assortmentUnitId;
  String countryId;
  String weight;
  String volume;
  dynamic manufacturer;
  dynamic ingredients;
  String description;
  dynamic temperatureMin;
  int temperatureMax;
  String productionStandardId;
  String productionStandardNumber;
  int shelfLife;
  dynamic rating;
  List<ImageModel> images;
  List<BasketListStoreModel> stores;
  List<dynamic> tags;
  List<BasketListAssortmentPropertyModel> properties;
  dynamic userShoppingLists;

  factory BasketListAssortmentModel.fromJson(Map<String, dynamic> json) => BasketListAssortmentModel(
        uuid: json["uuid"],
        discountTypeColor: json["discount_type_color"],
        discountType: json["discount_type"],
        discountTypeName: json["discount_type_name"],
        bonusPercent: json["bonus_percent"] == null ? null : double.parse(json["bonus_percent"]),
        priceWithDiscount: json["price_with_discount"] == null ? null : double.parse(json["price_with_discount"].toString()),
        totalAmountWithDiscount: json["total_amount_with_discount"] == null ? null : double.parse(json["total_amount_with_discount"].toString()),
        price: json["price"] == null ? null : double.parse(json["price"].toString()),
        originalPrice: json["original_price"] == null ? null : double.parse(json["original_price"].toString()),
        currentPrice: json["current_price"] == null ? null : double.parse(json["current_price"].toString()),
        catalogUuid: json["catalog_uuid"],
        catalogName: json["catalog_name"],
        name: json["name"],
        shortName: json["short_name"],
        assortmentUnitId: json["assortment_unit_id"],
        countryId: json["country_id"],
        weight: json["weight"],
        volume: json["volume"],
        manufacturer: json["manufacturer"],
        ingredients: json["ingredients"],
        description: json["description"],
        temperatureMin: json["temperature_min"],
        temperatureMax: json["temperature_max"],
        productionStandardId: json["production_standard_id"],
        productionStandardNumber: json["production_standard_number"],
        shelfLife: json["shelf_life"],
        rating: json["rating"],
        images: List<ImageModel>.from(json["images"].map((x) => ImageModel.fromJson(x))),
        stores: List<BasketListStoreModel>.from(json["stores"].map((x) => BasketListStoreModel.fromJson(x))),
        tags: List<dynamic>.from(json["tags"].map((x) => x)),
        properties: List<BasketListAssortmentPropertyModel>.from(json["properties"].map((x) => BasketListAssortmentPropertyModel.fromJson(x))),
        userShoppingLists: json["user_shopping_lists"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "discount_type_color": discountTypeColor,
        "discount-type": discountType,
        "discount-type-name": discountTypeName,
        "price_with_discount": priceWithDiscount,
        "total_amount_with_discount": totalAmountWithDiscount,
        "price": price,
        "original_price": originalPrice,
        "current_price": currentPrice,
        "catalog_uuid": catalogUuid,
        "catalog_name": catalogName,
        "name": name,
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
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "properties": List<dynamic>.from(properties.map((x) => x.toJson())),
        "user_shopping_lists": userShoppingLists,
      };

  @override
  String toString() {
    return "name - $name";
  }
}
