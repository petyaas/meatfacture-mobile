class PurchasesSumModel {
  PurchasesSumModel({
    this.data,
  });

  var data;

  factory PurchasesSumModel.fromJson(Map<String, dynamic> json) =>
      PurchasesSumModel(
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
