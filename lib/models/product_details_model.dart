import 'package:smart/models/product_details_data_model.dart';

// class ProductDetailsModel {
//   ProductDetailsModel({
//     this.data,
//   });

//   ProductDetailsDataModel data;

//   factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
//       ProductDetailsModel(
//         data: ProductDetailsDataModel.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "data": data.toJson(),
//       };
// }

class ProductDetailsModel {
  ProductDetailsModel({
    this.data,
  });

  ProductDetailsDataModel data;

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailsModel(
        data: ProductDetailsDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}
