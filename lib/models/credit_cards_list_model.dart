class CreditCardsListModel {
  CreditCardsListModel({
    this.data,
  });

  List<CreditCardsListDataModel> data;

  factory CreditCardsListModel.fromJson(Map<String, dynamic> json) =>
      CreditCardsListModel(
        data: List<CreditCardsListDataModel>.from(
            json["data"].map((x) => CreditCardsListDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CreditCardsListDataModel {
  CreditCardsListDataModel({
    this.uuid,
    this.cardMask,
  });

  String uuid;
  String cardMask;

  factory CreditCardsListDataModel.fromJson(Map<String, dynamic> json) =>
      CreditCardsListDataModel(
        uuid: json["uuid"],
        cardMask: json["card_mask"] == null ? null : json["card_mask"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "card_mask": cardMask == null ? null : cardMask,
      };
}
