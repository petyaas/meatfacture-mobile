import 'package:smart/models/assortments_thumbnails_model.dart';

class ImageModelForCatalog {
  ImageModelForCatalog({
    this.uuid,
    this.path,
    this.thumbnails,
  });

  String uuid;
  String path;
  List<AssortmentsThumbnailsModel> thumbnails;

  factory ImageModelForCatalog.fromJson(Map<String, dynamic> json) =>
      ImageModelForCatalog(
        uuid: json["uuid"],
        path: json["path"],
        thumbnails: List<AssortmentsThumbnailsModel>.from(
            json["thumbnails"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "path": path,
        "thumbnails":
            List<AssortmentsThumbnailsModel>.from(thumbnails.map((x) => x)),
      };
}
