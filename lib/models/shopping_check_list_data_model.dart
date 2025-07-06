// class ShoppingCheckListDataModel {
//   ShoppingCheckListDataModel({
//     this.uuid,
//     this.id,
//     this.total,
//     this.createdAt,
//   });

//   String uuid;
//   int id;
//   String total;
//   String createdAt;

//   factory ShoppingCheckListDataModel.fromJson(Map<String, dynamic> json) =>
//       ShoppingCheckListDataModel(
//         uuid: json["uuid"],
//         id: json["id"],
//         total: json["total"],
//         createdAt: json["created_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "uuid": uuid,
//         "id": id,
//         "total": total,
//         "created_at": createdAt,
//       };
// }
import 'package:smart/models/loyalty_card_type.dart';

class ShoppingCheckListDataModel {
  ShoppingCheckListDataModel(
      {this.uuid,
      this.id,
      this.total,
      this.createdAt,
      this.storeBrandName,
      this.storeAddress,
      this.receiptLinesCount,
      this.loyaltyCardTypes,
      this.bonusToCharge,
      this.paidBonus,
      this.totalBonus});

  String uuid;
  int id;
  String total;
  String createdAt;
  String storeBrandName;
  String storeAddress;
  int receiptLinesCount;
  List<LoyaltyCardType> loyaltyCardTypes;
  int totalBonus;
  int paidBonus;
  int bonusToCharge;

  factory ShoppingCheckListDataModel.fromJson(Map<String, dynamic> json) =>
      ShoppingCheckListDataModel(
        uuid: json["uuid"],
        id: json["id"],
        total: json["total"],
        createdAt: json["created_at"],
        storeBrandName: json["store_brand_name"],
        storeAddress: json["store_address"],
        receiptLinesCount: json["receipt_lines_count"],
        loyaltyCardTypes: List<LoyaltyCardType>.from(
            json["loyalty_card_types"].map((x) => LoyaltyCardType.fromJson(x))),
        paidBonus: json["paid_bonus"],
        bonusToCharge: json["bonus_to_charge"],
        totalBonus: json["total_bonus"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "paid_bonus": paidBonus,
        "bonus_to_charge": bonusToCharge,
        "total_bonus": totalBonus,
        "id": id,
        "total": total,
        "created_at": createdAt,
        "store_brand_name": storeBrandName,
        "store_address": storeAddress,
        "receipt_lines_count": receiptLinesCount,
        "loyalty_card_types":
            List<dynamic>.from(loyaltyCardTypes.map((x) => x.toJson())),
      };
}
