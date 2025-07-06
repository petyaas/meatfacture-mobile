class AddressesClientListModel {
  AddressesClientListModel({this.data});
  List<AddressClientModel> data;
  factory AddressesClientListModel.fromJson(Map<String, dynamic> json) => AddressesClientListModel(
        data: List<AddressClientModel>.from(
          json["data"].map((x) => AddressClientModel.fromJson(x)),
        ),
      );
  Map<String, dynamic> toJson() => {"data": List<dynamic>.from(data.map((x) => x.toJson()))};
}

class AddressClientModel {
  String uuid;
  String title;
  String city;
  String street;
  String house;
  int floor;
  int entrance;
  int apartmentNumber;
  String intercomCode;
  String createdAt;
  String updatedAt;
  AddressClientModel({this.uuid, this.title, this.city, this.street, this.house, this.floor, this.entrance, this.apartmentNumber, this.intercomCode, this.createdAt, this.updatedAt});

  factory AddressClientModel.fromJson(Map<String, dynamic> json) => AddressClientModel(
        uuid: json["uuid"],
        title: json["title"],
        city: json["city"],
        street: json["street"],
        house: json["house"],
        floor: json["floor"],
        entrance: json["entrance"],
        apartmentNumber: json["apartment_number"],
        intercomCode: json["intercom_code"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "title": title,
        "city": city,
        "street": street,
        "house": house,
        "floor": floor,
        "entrance": entrance,
        "apartment_number": apartmentNumber,
        "intercom_code": intercomCode,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  @override
  String toString() {
    return 'AddressClientModel(uuid: $uuid, title: $title, city: $city, street: $street, house: $house, floor: $floor, entrance: $entrance, apartmentNumber: $apartmentNumber, intercomCode: $intercomCode, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
