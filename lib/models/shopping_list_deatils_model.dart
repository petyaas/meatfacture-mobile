import 'package:smart/models/shopping_list_details_data_model.dart';

class ShoppingListDeatailsModel {
  ShoppingListDeatailsModel({
    this.data,
  });

  ShoppingListDetailsDataModel data;

  factory ShoppingListDeatailsModel.fromJson(Map<String, dynamic> json) =>
      ShoppingListDeatailsModel(
        data: ShoppingListDetailsDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}
