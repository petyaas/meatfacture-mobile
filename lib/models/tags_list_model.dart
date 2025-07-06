class TagsListModel {
  TagsListModel({
    this.uuid,
    this.name,
    this.fixedInFilters,
    this.createdAt,
  });

  String uuid;
  String name;
  bool fixedInFilters;
  String createdAt;

  factory TagsListModel.fromJson(Map<String, dynamic> json) => TagsListModel(
        uuid: json["uuid"],
        name: json["name"],
        fixedInFilters: json["fixed_in_filters"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
        "fixed_in_filters": fixedInFilters,
        "created_at": createdAt,
      };
}
