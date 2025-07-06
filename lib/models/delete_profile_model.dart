class DeleteProfileModel {
  DeleteProfileModel({
    this.success,
    this.data,
  });

  bool success;
  DeleteProfileDataModel data;

  factory DeleteProfileModel.fromJson(Map<String, dynamic> json) =>
      DeleteProfileModel(
        success: json["success"],
        data: DeleteProfileDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class DeleteProfileDataModel {
  DeleteProfileDataModel({
    this.newMark,
    this.markDeletedAt,
  });

  bool newMark;
  String markDeletedAt;

  factory DeleteProfileDataModel.fromJson(Map<String, dynamic> json) =>
      DeleteProfileDataModel(
        newMark: json["new_mark"],
        markDeletedAt: json["mark_deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "new_mark": newMark,
        "mark_deleted_at": markDeletedAt,
      };
}
