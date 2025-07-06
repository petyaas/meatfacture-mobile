class UrlForCreditCardLinkModel {
  UrlForCreditCardLinkModel({
    this.data,
  });

  UrlForCreditCardLinkDataModel data;

  factory UrlForCreditCardLinkModel.fromJson(Map<String, dynamic> json) =>
      UrlForCreditCardLinkModel(
        data: UrlForCreditCardLinkDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class UrlForCreditCardLinkDataModel {
  UrlForCreditCardLinkDataModel({
    this.formUrl,
    this.orderId,
  });

  String formUrl;
  String orderId;

  factory UrlForCreditCardLinkDataModel.fromJson(Map<String, dynamic> json) =>
      UrlForCreditCardLinkDataModel(
        formUrl: json["form_url"],
        orderId: json["order_id"],
      );

  Map<String, dynamic> toJson() => {
        "form_url": formUrl,
        "order_id": orderId,
      };
}
