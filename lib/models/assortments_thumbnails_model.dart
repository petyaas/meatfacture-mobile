class AssortmentsThumbnailsModel {
  String the1000X1000;
  AssortmentsThumbnailsModel({this.the1000X1000});

  factory AssortmentsThumbnailsModel.fromJson(Map<String, dynamic> json) => AssortmentsThumbnailsModel(
        the1000X1000: json["1000x1000"],
      );

  Map<String, dynamic> toJson() => {
        "1000x1000": the1000X1000,
      };
}
