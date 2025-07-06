class SmartContactsModel {
  SmartContactsModel({this.data});

  SmartContactsDataModel data;

  factory SmartContactsModel.fromJson(Map<String, dynamic> json) => SmartContactsModel(
        data: SmartContactsDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class SmartContactsDataModel {
  SmartContactsDataModel({
    this.id,
    this.email,
    this.callCenterNumber,
    this.socialNetworkInstagram,
    this.socialNetworkVk,
    this.socialNetworkFacebook,
    this.socialMessengerTelegram,
    this.deliveyInformation,
    this.androidVersion,
    this.iosVersion,
  });

  int id;
  String email;
  String callCenterNumber;
  String socialNetworkInstagram;
  String socialNetworkVk;
  String deliveyInformation;
  String socialNetworkFacebook;
  String socialMessengerTelegram;
  String iosVersion;
  String androidVersion;

  factory SmartContactsDataModel.fromJson(Map<String, dynamic> json) => SmartContactsDataModel(
      id: json["id"],
      deliveyInformation: json["delivey_information"],
      email: json["email"],
      callCenterNumber: json["call_center_number"],
      socialNetworkInstagram: json["social_network_instagram"],
      socialNetworkVk: json["social_network_vk"],
      socialNetworkFacebook: json["social_network_facebook"],
      socialMessengerTelegram: json["social_messenger_telegram"],
      androidVersion: json["android_version"],
      iosVersion: json["ios_version"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "android_version": androidVersion,
        "ios_version": iosVersion,
        "delivey_information": deliveyInformation,
        "email": email,
        "call_center_number": callCenterNumber,
        "social_network_instagram": socialNetworkInstagram,
        "social_network_vk": socialNetworkVk,
        "social_network_facebook": socialNetworkFacebook,
        "social_messenger_telegram": socialMessengerTelegram,
      };
}
