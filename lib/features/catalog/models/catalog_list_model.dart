import 'package:smart/models/Assortments_image_model.dart';

class CatalogListModel {
  String uuid;
  String catalogUuid;
  String catalogName;
  String name;
  bool isFinalLevel;
  int level;
  int assortmentsCount;
  int assortmentsCountInStore;
  ImageModel image;
  List<String> assortmentsTagsInStore;
  List<CatalogListModel> subcatalog;

  CatalogListModel({
    this.uuid,
    this.catalogUuid,
    this.catalogName,
    this.name,
    this.level,
    this.assortmentsCount,
    this.image,
    this.isFinalLevel,
    this.assortmentsCountInStore,
    this.assortmentsTagsInStore,
    this.subcatalog,
  });

  factory CatalogListModel.fromJson(Map<String, dynamic> json) {
    var subcatalogJson = json['subcatalog'] as List<dynamic>;
    List<CatalogListModel> subcatalog = subcatalogJson != null ? subcatalogJson.map((e) => CatalogListModel.fromJson(e)).toList() : null;
    return CatalogListModel(
      uuid: json["uuid"],
      assortmentsTagsInStore: json["assortments_tags_in_store"] == null ? null : List<String>.from(json["assortments_tags_in_store"].map((x) => x)),
      isFinalLevel: json["is_final_level"],
      catalogUuid: json["catalog_uuid"],
      catalogName: json["catalog_name"],
      name: json["name"],
      level: json["level"],
      assortmentsCount: json["assortments_count"],
      image: json["image"] == null ? null : ImageModel.fromJson(json["image"]),
      assortmentsCountInStore: json["assortments_count_in_store"],
      subcatalog: subcatalog,
    );
  }

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "assortments_tags_in_store": assortmentsTagsInStore,
        "is_final_level": isFinalLevel,
        "catalog_uuid": catalogUuid,
        "catalog_name": catalogName,
        "name": name,
        "level": level,
        "assortments_count": assortmentsCount,
        "image": image == null ? null : image.toJson(),
        "assortments_count_in_store": assortmentsCountInStore,
        "subcatalog": subcatalog != null ? List<dynamic>.from(subcatalog.map((x) => x.toJson())) : null,
      };
}
