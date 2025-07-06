import 'package:smart/models/loyalty_card_type.dart';

class BasketListStoreModel {
  BasketListStoreModel({
    this.uuid,
    this.brandName,
    this.address,
    this.addressLatitude,
    this.addressLongitude,
    this.loyaltyCardTypes,
    this.productsquantity,
  });

  String uuid;
  String brandName;
  String address;
  String addressLatitude;
  String addressLongitude;
  List<LoyaltyCardType> loyaltyCardTypes;
  double productsquantity;

  factory BasketListStoreModel.fromJson(Map<String, dynamic> json) => BasketListStoreModel(
        uuid: json["uuid"],
        productsquantity: json["products_quantity"] == null ? null : double.parse(json["products_quantity"].toString()),
        brandName: json["brand_name"],
        address: json["address"],
        addressLatitude: json["address_latitude"],
        addressLongitude: json["address_longitude"],
        loyaltyCardTypes: List<LoyaltyCardType>.from(json["loyalty_card_types"].map((x) => LoyaltyCardType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "products_quantity": productsquantity,
        "brand_name": brandName,
        "address": address,
        "address_latitude": addressLatitude,
        "address_longitude": addressLongitude,
        "loyalty_card_types": List<dynamic>.from(loyaltyCardTypes.map((x) => x.toJson())),
      };
}
