// To parse this JSON data, do
//
//     final notificationsListModel = notificationsListModelFromJson(jsonString);

import 'dart:convert';

NotificationsListModel notificationsListModelFromJson(String str) =>
    NotificationsListModel.fromJson(json.decode(str));

String notificationsListModelToJson(NotificationsListModel data) =>
    json.encode(data.toJson());

class NotificationsListModel {
  NotificationsListModel({
    this.data,
    this.meta,
  });

  List<NotificationsListDataModel> data;
  NotificationsListModelMeta meta;

  factory NotificationsListModel.fromJson(Map<String, dynamic> json) =>
      NotificationsListModel(
        data: List<NotificationsListDataModel>.from(
            json["data"].map((x) => NotificationsListDataModel.fromJson(x))),
        meta: NotificationsListModelMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class NotificationsListDataModel {
  NotificationsListDataModel({
    this.id,
    this.type,
    this.data,
    this.createdAt,
    this.readAt,
  });

  String id;
  String type;
  NotificationsDataModel data;
  String createdAt;
  dynamic readAt;

  factory NotificationsListDataModel.fromJson(Map<String, dynamic> json) =>
      NotificationsListDataModel(
        id: json["id"],
        type: json["type"],
        data: NotificationsDataModel.fromJson(json["data"]),
        createdAt: json["created_at"],
        readAt: json["read_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "data": data.toJson(),
        "created_at": createdAt,
        "read_at": readAt,
      };
}

class NotificationsDataModel {
  NotificationsDataModel({
    this.title,
    this.body,
    this.meta,
  });

  String title;
  String body;
  DataMeta meta;

  factory NotificationsDataModel.fromJson(Map<String, dynamic> json) =>
      NotificationsDataModel(
        title: json["title"],
        body: json["body"],
        meta: json["meta"] is List
            ? DataMeta(type: "", id: "")
            : DataMeta.fromJson(json["meta"]),
        // meta: json["meta"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "meta": meta.toJson(),
      };
}

class DataMeta {
  DataMeta({
    this.type,
    this.id,
    this.url,
  });

  String type;
  String id;
  String url;

  factory DataMeta.fromJson(Map<String, dynamic> json) => DataMeta(
        type: json["type"],
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "url": url,
      };
}

class NotificationsListModelMeta {
  NotificationsListModelMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.perPage,
    this.to,
    this.total,
  });

  int currentPage;
  int from;
  int lastPage;
  int perPage;
  int to;
  int total;

  factory NotificationsListModelMeta.fromJson(Map<String, dynamic> json) =>
      NotificationsListModelMeta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}
