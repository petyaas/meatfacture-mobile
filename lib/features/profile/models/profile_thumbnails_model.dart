class ProfileThumbnailsModel {
  String the200X200;
  String the500X500;
  String the1000X1000;
  ProfileThumbnailsModel({this.the200X200, this.the500X500, this.the1000X1000});

  factory ProfileThumbnailsModel.fromJson(Map<String, dynamic> json) => ProfileThumbnailsModel(
        the200X200: json["200x200"],
        the500X500: json["500x500"],
        the1000X1000: json["1000x1000"],
      );

  Map<String, dynamic> toJson() => {
        "200x200": the200X200,
        "500x500": the500X500,
        "1000x1000": the1000X1000,
      };
}
