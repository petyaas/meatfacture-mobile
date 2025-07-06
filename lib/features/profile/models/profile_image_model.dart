import 'package:smart/features/profile/models/profile_thumbnails_model.dart';

class ProfileImageModel {
  String uuid;
  String path;
  ProfileThumbnailsModel thumbnails;
  ProfileImageModel({this.uuid, this.path, this.thumbnails});

  factory ProfileImageModel.fromJson(Map<String, dynamic> json) => ProfileImageModel(
        uuid: json["uuid"],
        path: json["path"],
        thumbnails: ProfileThumbnailsModel.fromJson(json["thumbnails"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "path": path,
        "thumbnails": thumbnails.toJson(),
      };
}
