import 'dart:convert';

class SingleRecipeDataModel {
  Data data;

  SingleRecipeDataModel({
    this.data,
  });

  factory SingleRecipeDataModel.fromJson(String str) => SingleRecipeDataModel.fromMap(json.decode(str));

  factory SingleRecipeDataModel.fromMap(Map<String, dynamic> json) => SingleRecipeDataModel(
        data: Data.fromMap(json["data"]),
      );
}

class Data {
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

  Data({
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

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  factory Data.fromMap(Map<String, dynamic> json) => Data(
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
}

class Assortment {
  String uuid;
  String name;
  String assortmentUnitId;
  String weight;
  dynamic rating;
  List<Image> images;
  int quantity;

  Assortment({
    this.uuid,
    this.name,
    this.assortmentUnitId,
    this.weight,
    this.rating,
    this.images,
    this.quantity,
  });

  factory Assortment.fromJson(String str) => Assortment.fromMap(json.decode(str));

  factory Assortment.fromMap(Map<String, dynamic> json) => Assortment(
        uuid: json["uuid"],
        name: json["name"],
        assortmentUnitId: json["assortment_unit_id"],
        weight: json["weight"],
        rating: json["rating"],
        images: List<Image>.from(json["images"].map((x) => Image.fromMap(x))),
        quantity: json["quantity"],
      );
}

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

  factory Image.fromMap(Map<String, dynamic> json) => Image(
        uuid: json["uuid"],
        path: json["path"],
        thumbnails: Thumbnails.fromMap(json["thumbnails"]),
      );
}

class Thumbnails {
  String the1000X1000;

  Thumbnails({
    this.the1000X1000,
  });

  factory Thumbnails.fromJson(String str) => Thumbnails.fromMap(json.decode(str));

  factory Thumbnails.fromMap(Map<String, dynamic> json) => Thumbnails(
        the1000X1000: json["1000x1000"],
      );
}

class Ingredient {
  String name;
  String quantity;

  Ingredient({
    this.name,
    this.quantity,
  });

  factory Ingredient.fromJson(String str) => Ingredient.fromMap(json.decode(str));

  factory Ingredient.fromMap(Map<String, dynamic> json) => Ingredient(
        name: json["name"],
        quantity: json["quantity"],
      );
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
}
