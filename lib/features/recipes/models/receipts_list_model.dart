import 'dart:convert';

class ReceiptsListModel {
  List<Datum> data;
  Meta meta;

  ReceiptsListModel({
    this.data,
    this.meta,
  });

  factory ReceiptsListModel.fromJson(String str) => ReceiptsListModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReceiptsListModel.fromMap(Map<String, dynamic> json) => ReceiptsListModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
        meta: Meta.fromMap(json["meta"]),
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "meta": meta.toMap(),
      };
}

class Datum {
  String uuid;
  String name;
  String section;
  String title;
  String description;
  List<Ingredient> ingredients;
  int duration;
  bool isFavorite;
  bool clientLikeValue;
  String filePath;
  List<Assortment> assortments;
  List<Tab> tabs;
  String createdAt;
  String updatedAt;

  Datum({
    this.uuid,
    this.name,
    this.section,
    this.title,
    this.description,
    this.ingredients,
    this.duration,
    this.isFavorite,
    this.clientLikeValue,
    this.filePath,
    this.assortments,
    this.tabs,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        uuid: json["uuid"],
        name: json["name"],
        section: json["section"],
        title: json["title"],
        description: json["description"],
        ingredients: List<Ingredient>.from(json["ingredients"].map((x) => Ingredient.fromMap(x))),
        duration: json["duration"],
        isFavorite: json["is_favorite"],
        clientLikeValue: json["client_like_value"],
        filePath: json["file_path"],
        assortments: List<Assortment>.from(json["assortments"].map((x) => Assortment.fromMap(x))),
        tabs: List<Tab>.from(json["tabs"].map((x) => Tab.fromMap(x))),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "uuid": uuid,
        "name": name,
        "section": section,
        "title": title,
        "description": description,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x.toMap())),
        "duration": duration,
        "is_favorite": isFavorite,
        "client_like_value": clientLikeValue,
        "file_path": filePath,
        "assortments": List<dynamic>.from(assortments.map((x) => x.toMap())),
        "tabs": List<dynamic>.from(tabs.map((x) => x.toMap())),
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Assortment {
  String uuid;
  String name;
  String assortmentUnitId;
  String weight;
  double rating;
  List<Image> images;
  double quantity;
  num productsQuantity;
  String currentPrice;

  Assortment({
    this.uuid,
    this.name,
    this.assortmentUnitId,
    this.weight,
    this.rating,
    this.images,
    this.quantity,
    this.productsQuantity,
    this.currentPrice,
  });

  factory Assortment.fromJson(String str) => Assortment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Assortment.fromMap(Map<String, dynamic> json) => Assortment(
        uuid: json["uuid"],
        name: json["name"],
        assortmentUnitId: json["assortment_unit_id"],
        weight: json["weight"],
        rating: json["rating"] != null ? (json["rating"] as num).toDouble() : null,
        images: List<Image>.from(json["images"].map((x) => Image.fromMap(x))),
        quantity: (json["quantity"] as num).toDouble(),
        productsQuantity: json["products_quantity"],
        currentPrice: json["current_price"],
      );

  Map<String, dynamic> toMap() => {
        "uuid": uuid,
        "name": name,
        "assortment_unit_id": assortmentUnitIdValues.reverse[assortmentUnitId],
        "weight": weight,
        "rating": rating,
        "images": List<dynamic>.from(images.map((x) => x.toMap())),
        "quantity": quantity,
        "products_quantity": productsQuantity,
        "current_price": currentPrice,
      };
}

enum AssortmentUnitId { KILOGRAM }

final assortmentUnitIdValues = EnumValues({"kilogram": AssortmentUnitId.KILOGRAM});

class Image {
  String uuid;
  String path;
  Thumbnails thumbnails;

  Image({
    this.uuid,
    this.path,
    this.thumbnails,
  });

  factory Image.fromJson(String str) => Image.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Image.fromMap(Map<String, dynamic> json) => Image(
        uuid: json["uuid"],
        path: json["path"],
        thumbnails: Thumbnails.fromMap(json["thumbnails"]),
      );

  Map<String, dynamic> toMap() => {
        "uuid": uuid,
        "path": path,
        "thumbnails": thumbnails.toMap(),
      };
}

class Thumbnails {
  String the1000X1000;

  Thumbnails({
    this.the1000X1000,
  });

  factory Thumbnails.fromJson(String str) => Thumbnails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Thumbnails.fromMap(Map<String, dynamic> json) => Thumbnails(
        the1000X1000: json["1000x1000"],
      );

  Map<String, dynamic> toMap() => {
        "1000x1000": the1000X1000,
      };
}

class Ingredient {
  String name;
  String quantity;

  Ingredient({
    this.name,
    this.quantity,
  });

  factory Ingredient.fromJson(String str) => Ingredient.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ingredient.fromMap(Map<String, dynamic> json) => Ingredient(
        name: json["name"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "quantity": quantity,
      };
}

class Tab {
  String uuid;
  String title;
  String text;
  String textColor;
  int duration;
  int sequence;
  String buttonTitle;
  dynamic url;
  String filePath;
  String createdAt;
  String updatedAt;

  Tab({
    this.uuid,
    this.title,
    this.text,
    this.textColor,
    this.duration,
    this.sequence,
    this.buttonTitle,
    this.url,
    this.filePath,
    this.createdAt,
    this.updatedAt,
  });

  factory Tab.fromJson(String str) => Tab.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tab.fromMap(Map<String, dynamic> json) => Tab(
        uuid: json["uuid"],
        title: json["title"],
        text: json["text"],
        textColor: json["text_color"],
        duration: json["duration"],
        sequence: json["sequence"],
        buttonTitle: json["button_title"],
        url: json["url"],
        filePath: json["file_path"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "uuid": uuid,
        "title": title,
        "text": text,
        "text_color": textColor,
        "duration": duration,
        "sequence": sequence,
        "button_title": buttonTitle,
        "url": url,
        "file_path": filePath,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Meta {
  int currentPage;
  int from;
  int lastPage;
  int perPage;
  int to;
  int total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(String str) => Meta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Meta.fromMap(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toMap() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
