class DiverseFoodStatsModel {
  DiverseFoodStatsModel({
    this.data,
  });

  List<DiverseFoodStatsDataModel> data;

  factory DiverseFoodStatsModel.fromJson(Map<String, dynamic> json) =>
      DiverseFoodStatsModel(
        data: List<DiverseFoodStatsDataModel>.from(
            json["data"].map((x) => DiverseFoodStatsDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DiverseFoodStatsDataModel {
  DiverseFoodStatsDataModel({
    this.uuid,
    this.month,
    this.clientUuid,
    this.purchasedCount,
    this.ratedCount,
    this.createdAt,
    this.updatedAt,
  });

  String uuid;
  String month;
  String clientUuid;
  int purchasedCount;
  int ratedCount;
  String createdAt;
  String updatedAt;

  factory DiverseFoodStatsDataModel.fromJson(Map<String, dynamic> json) =>
      DiverseFoodStatsDataModel(
        uuid: json["uuid"],
        month: json["month"],
        clientUuid: json["client_uuid"],
        purchasedCount: json["purchased_count"],
        ratedCount: json["rated_count"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "month": month,
        "client_uuid": clientUuid,
        "purchased_count": purchasedCount,
        "rated_count": ratedCount,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
