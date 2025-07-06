class DiverseFoodPersentListModel {
  DiverseFoodPersentListModel({
    this.data,
  });

  List<DiverseFoodPersentListDataModel> data;

  factory DiverseFoodPersentListModel.fromJson(Map<String, dynamic> json) =>
      DiverseFoodPersentListModel(
          data: json["data"] == null
              ? null
              : List<DiverseFoodPersentListDataModel>.from(json["data"]
                  .map((x) => DiverseFoodPersentListDataModel.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DiverseFoodPersentListDataModel {
  DiverseFoodPersentListDataModel({
    this.uuid,
    this.countPurchases,
    this.countRatingScores,
    this.discountPercent,
    this.isEnabled,
  });

  String uuid;
  int countPurchases;
  int countRatingScores;
  int discountPercent;
  bool isEnabled;

  factory DiverseFoodPersentListDataModel.fromJson(Map<String, dynamic> json) =>
      DiverseFoodPersentListDataModel(
        uuid: json["uuid"],
        countPurchases: json["count_purchases"],
        countRatingScores: json["count_rating_scores"],
        discountPercent: json["discount_percent"],
        isEnabled: json["is_enabled"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "count_purchases": countPurchases,
        "count_rating_scores": countRatingScores,
        "discount_percent": discountPercent,
        "is_enabled": isEnabled,
      };
}
