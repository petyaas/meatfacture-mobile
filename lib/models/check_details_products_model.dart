import 'package:smart/models/assortments_thumbnails_model.dart';

class CheckDetailsProductsModel {
  CheckDetailsProductsModel({
    this.data,
  });

  List<CheckDetailsProductsDataModel> data;

  factory CheckDetailsProductsModel.fromJson(Map<String, dynamic> json) =>
      CheckDetailsProductsModel(
        data: List<CheckDetailsProductsDataModel>.from(
            json["data"].map((x) => CheckDetailsProductsDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CheckDetailsProductsDataModel {
  CheckDetailsProductsDataModel(
      {this.uuid,
      this.assortmentUuid,
      this.assortmentName,
      this.quantity,
      this.total,
      this.rating,
      this.ratingComment,
      this.assortmentImages,
      this.originalPrice,
      this.assortmentRating,
      this.price,
      this.discountableType,
      this.discountTypeColor,
      this.discountTypeName,
      this.discount,
      this.totalDiscount,
      this.assortmentUnitId,
      this.paidBonus,
      this.totalBonus,
      this.assortmentWeight});

  String uuid;
  String assortmentUuid;
  String assortmentName;
  double quantity;
  String total;
  double rating;
  String ratingComment;
  double assortmentRating;
  List<HistoryCheckAssortmentImage> assortmentImages;
  double originalPrice;
  double price;
  String discountableType;
  String discountTypeColor;
  String discountTypeName;
  String discount;
  double totalDiscount;
  String assortmentUnitId;
  double paidBonus;
  double totalBonus;
  double assortmentWeight;

  factory CheckDetailsProductsDataModel.fromJson(Map<String, dynamic> json) =>
      CheckDetailsProductsDataModel(
        assortmentWeight: double.tryParse(json["assortment_weight"].toString()),
        paidBonus: double.tryParse(json["paid_bonus"].toString()),
        totalBonus: double.tryParse(json["total_bonus"].toString()),
        assortmentUnitId: json["assortment_unit_id"],
        totalDiscount: json["total_discount"] == null
            ? null
            : double.parse(json["total_discount"].toString()),
        uuid: json["uuid"],
        discount: json["discount"],
        discountTypeName: json["discount_type_name"],
        discountTypeColor: json["discount_type_colorß"],
        discountableType: json["discountable_type"],
        originalPrice: json["original_price"] == null
            ? null
            : double.parse(json["original_price"].toString()),
        price: json["price"] == null
            ? null
            : double.parse(json["price"].toString()),
        assortmentUuid: json["assortment_uuid"],
        assortmentName: json["assortment_name"],
        quantity: double.parse(json["quantity"].toString()),
        total: json["total"],
        assortmentRating: json["assortment_rating"] == null
            ? null
            : double.parse(json["assortment_rating"].toString()),
        rating: json["rating"] == null
            ? null
            : double.parse(json["rating"].toString()),
        ratingComment: json["rating_comment"],
        assortmentImages: List<HistoryCheckAssortmentImage>.from(
            json["assortment_images"]
                .map((x) => HistoryCheckAssortmentImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "assortment_weight": assortmentWeight,
        "total_bonus": totalBonus,
        "paid_bonus": paidBonus,
        "uuid": uuid,
        "assortment_uuid": assortmentUuid,
        "assortment_name": assortmentName,
        "quantity": quantity,
        "total": total,
        "rating": rating,
        "rating_comment": ratingComment,
        "assortment_images": List<HistoryCheckAssortmentImage>.from(
            assortmentImages.map((x) => x.toJson())),
      };
}

class HistoryCheckAssortmentImage {
  HistoryCheckAssortmentImage({
    this.uuid,
    this.path,
    this.thumbnails,
  });

  String uuid;
  String path;
  AssortmentsThumbnailsModel thumbnails;

  factory HistoryCheckAssortmentImage.fromJson(Map<String, dynamic> json) =>
      HistoryCheckAssortmentImage(
        uuid: json["uuid"],
        path: json["path"],
        thumbnails: AssortmentsThumbnailsModel.fromJson(json["thumbnails"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "path": path,
        "thumbnails": thumbnails.toJson(),
      };
}
