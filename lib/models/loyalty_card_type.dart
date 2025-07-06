class LoyaltyCardType {
  LoyaltyCardType({
    this.uuid,
  });

  String uuid;

  factory LoyaltyCardType.fromJson(Map<String, dynamic> json) =>
      LoyaltyCardType(
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
      };
}
