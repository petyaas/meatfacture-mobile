// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:smart/models/meta_model.dart';

class AssortmentBrandsListmodel {
  AssortmentBrandsListmodel({this.data, this.meta});
  List<AssortmentBrandsListDatamodel> data;
  MetaModel meta;

  factory AssortmentBrandsListmodel.fromJson(Map<String, dynamic> json) => AssortmentBrandsListmodel(
        data: List<AssortmentBrandsListDatamodel>.from(json["data"].map((x) => AssortmentBrandsListDatamodel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class AssortmentBrandsListDatamodel {
  String uuid;
  String name;
  String createdAt;
  bool isSelected = false;
  AssortmentBrandsListDatamodel({this.uuid, this.name, this.createdAt, this.isSelected});

  factory AssortmentBrandsListDatamodel.fromJson(Map<String, dynamic> json) => AssortmentBrandsListDatamodel(
        uuid: json["uuid"],
        name: json["name"],
        isSelected: false,
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {"uuid": uuid, "name": name, "created_at": createdAt};

  @override
  String toString() {
    return 'AssortmentBrandsListDatamodel(uuid: $uuid, name: $name, createdAt: $createdAt, isSelected: $isSelected)';
  }
}
