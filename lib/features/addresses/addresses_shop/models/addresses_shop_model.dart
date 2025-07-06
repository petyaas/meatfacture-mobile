
import 'package:smart/models/Assortments_image_model.dart';
import 'package:smart/models/loyalty_card_type.dart';

class AddressesShopModel {
  String uuid;
  String brandName;
  String organizationName;
  String workHoursFrom;
  String workHoursTill;
  String addressLatitude;
  String addressLongitude;
  List<LoyaltyCardType> loyaltyCardTypes;
  String address;
  String phone;
  bool hasParking;
  bool hasReadyMeals;
  bool hasAtms;
  ImageModel image;
  bool isFavorite;
  String deliveryPrice;
  int distance;

  AddressesShopModel({
    this.uuid,
    this.brandName,
    this.organizationName,
    this.workHoursFrom,
    this.workHoursTill,
    this.addressLatitude,
    this.addressLongitude,
    this.loyaltyCardTypes,
    this.address,
    this.phone,
    this.hasParking,
    this.hasReadyMeals,
    this.hasAtms,
    this.image,
    this.isFavorite,
    this.deliveryPrice,
    this.distance,
  });

  factory AddressesShopModel.fromJson(Map<String, dynamic> json) => AddressesShopModel(
        uuid: json["uuid"],
        brandName: json["brand_name"],
        organizationName: json["organization_name"],
        workHoursFrom: json["work_hours_from"],
        workHoursTill: json["work_hours_till"],
        addressLatitude: json["address_latitude"],
        addressLongitude: json["address_longitude"],
        loyaltyCardTypes: json["loyalty_card_types"] == null ? null : List<LoyaltyCardType>.from(json["loyalty_card_types"].map((x) => LoyaltyCardType.fromJson(x))),
        address: json["address"],
        phone: json["phone"],
        hasParking: json["has_parking"],
        hasReadyMeals: json["has_ready_meals"],
        hasAtms: json["has_atms"],
        image: json["image"] == null ? null : ImageModel.fromJson(json["image"]),
        isFavorite: json["is_favorite"],
        deliveryPrice: json["delivery_price"],
        distance: json["distance"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "brand_name": brandName,
        "organization_name": organizationName,
        "work_hours_from": workHoursFrom,
        "work_hours_till": workHoursTill,
        "address_latitude": addressLatitude,
        "address_longitude": addressLongitude,
        "loyalty_card_types": loyaltyCardTypes == null ? null : List<dynamic>.from(loyaltyCardTypes.map((x) => x.toJson())),
        "address": address,
        "phone": phone,
        "has_parking": hasParking,
        "has_ready_meals": hasReadyMeals,
        "has_atms": hasAtms,
        "image": image == null ? null : image.toJson(),
        "is_favorite": isFavorite,
        "delivery_price": deliveryPrice,
        "distance": distance,
      };
}
