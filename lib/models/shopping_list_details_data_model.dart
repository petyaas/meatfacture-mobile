import 'package:smart/models/shopping_lists_assortment_model.dart';

class ShoppingListDetailsDataModel {
  ShoppingListDetailsDataModel({this.uuid, this.name, this.assortments});

  String uuid;
  String name;
  List<ShoppingListsAssortmentModel> assortments; 

  factory ShoppingListDetailsDataModel.fromJson(Map<String, dynamic> json) =>
      ShoppingListDetailsDataModel(
        uuid: json["uuid"],
        name: json["name"],
        assortments: List<ShoppingListsAssortmentModel>.from(json["assortments"]
            .map((x) => ShoppingListsAssortmentModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
        "assortments": List<dynamic>.from(assortments.map((x) => x.toJson())),
      };
}
