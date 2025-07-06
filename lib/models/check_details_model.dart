import 'package:smart/models/loyalty_card_type.dart';

class CheckDetailsModel {
  CheckDetailsModel({
    this.checkDetailsDataModel,
  });

  CheckDetailsDataModel checkDetailsDataModel;

  factory CheckDetailsModel.fromJson(Map<String, dynamic> json) =>
      CheckDetailsModel(
        checkDetailsDataModel: CheckDetailsDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": checkDetailsDataModel.toJson(),
      };
}

class CheckDetailsDataModel {
  CheckDetailsDataModel({
    this.uuid,
    this.id,
    this.total,
    this.createdAt,
    this.storeBrandName,
    this.storeAddress,
    this.loyaltyCardTypes,
    this.totalBonus,
    this.paidBonus,
    this.bonusToCharge,
  });

  String uuid;
  int id;
  String total;
  String createdAt;
  String storeBrandName;
  String storeAddress;
  List<LoyaltyCardType> loyaltyCardTypes;
  int totalBonus;
  int paidBonus;
  int bonusToCharge;

  factory CheckDetailsDataModel.fromJson(Map<String, dynamic> json) =>
      CheckDetailsDataModel(
        uuid: json["uuid"],
        totalBonus: json["total_bonus"],
        bonusToCharge: json["bonus_to_charge"],
        paidBonus: json["paid_bonus"],
        id: json["id"],
        total: json["total"],
        createdAt: json["created_at"],
        storeBrandName: json["store_brand_name"],
        storeAddress: json["store_address"],
        loyaltyCardTypes: List<LoyaltyCardType>.from(
            json["loyalty_card_types"].map((x) => LoyaltyCardType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "total_bonus": totalBonus,
        "bonus_to_charge": bonusToCharge,
        "paid_bonus": paidBonus,
        "id": id,
        "total": total,
        "created_at": createdAt,
        "store_brand_name": storeBrandName,
        "store_address": storeAddress,
        "loyalty_card_types":
            List<dynamic>.from(loyaltyCardTypes.map((x) => x.toJson())),
      };
}
