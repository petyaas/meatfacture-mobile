// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:smart/features/profile/models/profile_data_model.dart';

class ProfileModel {
  ProfileDataModel data;
  ProfileModel({this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        data: ProfileDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"data": data.toJson()};

  ProfileModel copyWith({
    ProfileDataModel data,
  }) {
    return ProfileModel(
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(covariant ProfileModel other) {
    if (identical(this, other)) return true;

    return other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}
