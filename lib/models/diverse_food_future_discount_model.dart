class DiverseFoodFutureDiscountModel {
  DiverseFoodFutureDiscountModel({
    this.data,
  });

  DiverseFoodFutureDiscountDataModel data;

  factory DiverseFoodFutureDiscountModel.fromJson(Map<String, dynamic> json) =>
      DiverseFoodFutureDiscountModel(
        data: json["data"] == null
            ? null
            : DiverseFoodFutureDiscountDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class DiverseFoodFutureDiscountDataModel {
  DiverseFoodFutureDiscountDataModel({
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

  factory DiverseFoodFutureDiscountDataModel.fromJson(
          Map<String, dynamic> json) =>
      DiverseFoodFutureDiscountDataModel(
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
