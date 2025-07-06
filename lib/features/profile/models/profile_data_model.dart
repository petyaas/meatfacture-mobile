import 'package:smart/features/profile/models/profile_image_model.dart';

class ProfileDataModel {
  String uuid;
  bool isAgreeWithDiverseFoodPromo;
  String markDeletedAt;
  String phone;
  bool filledProfileBonusesAdded;
  String name;
  String email;
  String sex;
  dynamic birthDate;
  String createdAt;
  bool consentToServiceNewsletter;
  bool consentToReceivePromotionalMailings;
  String selectedStoreUserUuid;
  String selectedStoreAddress;
  ProfileImageModel image;
  int bonusBalance;
  String appVersion;

  ProfileDataModel({
    this.uuid,
    this.phone,
    this.name,
    this.email,
    this.sex,
    this.birthDate,
    this.createdAt,
    this.consentToServiceNewsletter,
    this.consentToReceivePromotionalMailings,
    this.selectedStoreUserUuid,
    this.selectedStoreAddress,
    this.image,
    this.bonusBalance,
    this.appVersion,
    this.isAgreeWithDiverseFoodPromo,
    this.filledProfileBonusesAdded,
    this.markDeletedAt,
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) => ProfileDataModel(
        isAgreeWithDiverseFoodPromo: json["is_agree_with_diverse_food_promo"],
        uuid: json["uuid"],
        markDeletedAt: json["mark_deleted_at"],
        filledProfileBonusesAdded: json["filled_profile_bonuses_added"] == null ? false : json["filled_profile_bonuses_added"],
        appVersion: json["app_version"],
        phone: json["phone"],
        name: json["name"],
        email: json["email"],
        sex: json["sex"],
        birthDate: json["birth_date"],
        createdAt: json["created_at"],
        consentToServiceNewsletter: json["consent_to_service_newsletter"],
        consentToReceivePromotionalMailings: json["consent_to_receive_promotional_mailings"],
        selectedStoreUserUuid: json["selected_store_user_uuid"],
        selectedStoreAddress: json["selected_store_address"],
        image: json["image"] == null ? null : ProfileImageModel.fromJson(json["image"]),
        bonusBalance: json["bonus_balance"],
      );

  Map<String, dynamic> toJson() => {
        "isAgreeWithDiverseFoodPromo": isAgreeWithDiverseFoodPromo,
        "uuid": uuid,
        "app_version": appVersion,
        "phone": phone,
        "filled_profile_bonuses_added": filledProfileBonusesAdded,
        "name": name,
        "email": email,
        "sex": sex,
        "birth_date": birthDate,
        "created_at": createdAt,
        "consent_to_service_newsletter": consentToServiceNewsletter,
        "consent_to_receive_promotional_mailings": consentToReceivePromotionalMailings,
        "selected_store_user_uuid": selectedStoreUserUuid,
        "selected_store_address": selectedStoreAddress,
        "image": image == null ? null : image.toJson(),
        "bonus_balance": bonusBalance,
      };

  ProfileDataModel copyWith({
    String uuid,
    bool isAgreeWithDiverseFoodPromo,
    String markDeletedAt,
    String phone,
    bool filledProfileBonusesAdded,
    String name,
    String email,
    String sex,
    dynamic birthDate,
    String createdAt,
    bool consentToServiceNewsletter,
    bool consentToReceivePromotionalMailings,
    String selectedStoreUserUuid,
    String selectedStoreAddress,
    ProfileImageModel image,
    int bonusBalance,
    String appVersion,
  }) {
    return ProfileDataModel(
      uuid: uuid ?? this.uuid,
      isAgreeWithDiverseFoodPromo: isAgreeWithDiverseFoodPromo ?? this.isAgreeWithDiverseFoodPromo,
      markDeletedAt: markDeletedAt ?? this.markDeletedAt,
      phone: phone ?? this.phone,
      filledProfileBonusesAdded: filledProfileBonusesAdded ?? this.filledProfileBonusesAdded,
      name: name ?? this.name,
      email: email ?? this.email,
      sex: sex ?? this.sex,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
      consentToServiceNewsletter: consentToServiceNewsletter ?? this.consentToServiceNewsletter,
      consentToReceivePromotionalMailings: consentToReceivePromotionalMailings ?? this.consentToReceivePromotionalMailings,
      selectedStoreUserUuid: selectedStoreUserUuid ?? this.selectedStoreUserUuid,
      selectedStoreAddress: selectedStoreAddress ?? this.selectedStoreAddress,
      image: image ?? this.image,
      bonusBalance: bonusBalance ?? this.bonusBalance,
      appVersion: appVersion ?? this.appVersion,
    );
  }

  @override
  bool operator ==(covariant ProfileDataModel other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.isAgreeWithDiverseFoodPromo == isAgreeWithDiverseFoodPromo &&
        other.markDeletedAt == markDeletedAt &&
        other.phone == phone &&
        other.filledProfileBonusesAdded == filledProfileBonusesAdded &&
        other.name == name &&
        other.email == email &&
        other.sex == sex &&
        other.birthDate == birthDate &&
        other.createdAt == createdAt &&
        other.consentToServiceNewsletter == consentToServiceNewsletter &&
        other.consentToReceivePromotionalMailings == consentToReceivePromotionalMailings &&
        other.selectedStoreUserUuid == selectedStoreUserUuid &&
        other.selectedStoreAddress == selectedStoreAddress &&
        other.image == image &&
        other.bonusBalance == bonusBalance &&
        other.appVersion == appVersion;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        isAgreeWithDiverseFoodPromo.hashCode ^
        markDeletedAt.hashCode ^
        phone.hashCode ^
        filledProfileBonusesAdded.hashCode ^
        name.hashCode ^
        email.hashCode ^
        sex.hashCode ^
        birthDate.hashCode ^
        createdAt.hashCode ^
        consentToServiceNewsletter.hashCode ^
        consentToReceivePromotionalMailings.hashCode ^
        selectedStoreUserUuid.hashCode ^
        selectedStoreAddress.hashCode ^
        image.hashCode ^
        bonusBalance.hashCode ^
        appVersion.hashCode;
  }
}
