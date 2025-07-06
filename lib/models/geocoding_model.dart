import 'dart:convert';

GeocodingModel geocodingModelFromJson(String str) =>
    GeocodingModel.fromJson(json.decode(str));

String geocodingModelToJson(GeocodingModel data) => json.encode(data.toJson());

class GeocodingModel {
  GeocodingModel({
    this.data,
  });

  List<GeocodingDataModel> data;

  factory GeocodingModel.fromJson(Map<String, dynamic> json) => GeocodingModel(
        data: List<GeocodingDataModel>.from(
            json["data"].map((x) => GeocodingDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class GeocodingDataModel {
   GeocodingDataModel({
        this.providedBy,
        this.latitude,
        this.longitude,
        this.bounds,
        this.streetNumber,
        this.streetName,
        this.postalCode,
        this.locality,
        this.subLocality,
        this.adminLevels,
        this.country,
        this.countryCode,
        this.timezone,
    });

    String providedBy;
    double latitude;
    double longitude;
    BoundsModel bounds;
    dynamic streetNumber;
    dynamic streetName;
    dynamic postalCode;
    String locality;
    dynamic subLocality;
    dynamic adminLevels;
    String country;
    String countryCode;
    dynamic timezone;

    factory GeocodingDataModel.fromJson(Map<String, dynamic> json) => GeocodingDataModel(
        providedBy: json["providedBy"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        bounds: BoundsModel.fromJson(json["bounds"]),
        streetNumber: json["streetNumber"],
        streetName: json["streetName"],
        postalCode: json["postalCode"],
        locality: json["locality"] == null ? null : json["locality"],
        subLocality: json["subLocality"],
        adminLevels: json["adminLevels"],
        country: json["country"],
        countryCode: json["countryCode"],
        timezone: json["timezone"],
    );

    Map<String, dynamic> toJson() => {
        "providedBy": providedBy,
        "latitude": latitude,
        "longitude": longitude,
        "bounds": bounds.toJson(),
        "streetNumber": streetNumber,
        "streetName": streetName,
        "postalCode": postalCode,
        "locality": locality == null ? null : locality,
        "subLocality": subLocality,
        "adminLevels": adminLevels,
        "country": country,
        "countryCode": countryCode,
        "timezone": timezone,
    };
}

class AdminLevelModel {
  AdminLevelModel({
        this.name,
        this.code,
        this.level,
    });

    String name;
    String code;
    int level;

    factory AdminLevelModel.fromJson(Map<String, dynamic> json) => AdminLevelModel(
        name: json["name"],
        code: json["code"],
        level: json["level"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "level": level,
    };
}

class BoundsModel {
  BoundsModel({
        this.south,
        this.west,
        this.north,
        this.east,
    });

    double south;
    double west;
    double north;
    double east;

    factory BoundsModel.fromJson(Map<String, dynamic> json) => BoundsModel(
        south: json["south"].toDouble(),
        west: json["west"].toDouble(),
        north: json["north"].toDouble(),
        east: json["east"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "south": south,
        "west": west,
        "north": north,
        "east": east,
    };

}
