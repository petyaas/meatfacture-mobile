class BasketListAssortmentPropertyModel {
  BasketListAssortmentPropertyModel({
    this.uuid,
    this.name,
    this.assortmentPropertyDataTypeId,
    this.availableValues,
    this.isSearchable,
    this.value,
  });

  String uuid;
  String name;

  String assortmentPropertyDataTypeId;
  List<String> availableValues;
  bool isSearchable;
  String value;

  factory BasketListAssortmentPropertyModel.fromJson(Map<String, dynamic> json) => BasketListAssortmentPropertyModel(
        uuid: json["uuid"],
        name: json["name"],
        assortmentPropertyDataTypeId: json["assortment_property_data_type_id"],
        availableValues: List<String>.from(json["available_values"].map((x) => x)),
        isSearchable: json["is_searchable"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
        "assortment_property_data_type_id": assortmentPropertyDataTypeId,
        "available_values": List<dynamic>.from(availableValues.map((x) => x)),
        "is_searchable": isSearchable,
        "value": value,
      };
}
