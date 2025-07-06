import 'package:smart/models/assortments_thumbnails_model.dart';

class ImageModel {
  String uuid;
  String path;
  AssortmentsThumbnailsModel thumbnails;
  ImageModel({this.uuid, this.path, this.thumbnails});

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        uuid: json["uuid"],
        path: json["path"],
        thumbnails: AssortmentsThumbnailsModel.fromJson(json["thumbnails"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "path": path,
        "thumbnails": thumbnails.toJson(),
      };
}
