import 'package:smart/models/meta_model.dart';
import 'package:smart/core/constants/source.dart';

class StoriesListModel {
  StoriesListModel({
    this.data,
    this.meta,
  });

  List<StoriesListDataModel> data;
  MetaModel meta;

  factory StoriesListModel.fromJson(Map<String, dynamic> json) => StoriesListModel(
        data: List<StoriesListDataModel>.from(json["data"].map((x) => StoriesListDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class StoriesListDataModel {
  StoriesListDataModel({
    this.id,
    this.name,
    this.logoFilePath,
    this.tabs,
    this.createdAt,
  });

  int id;
  String name;
  String logoFilePath;
  List<TabModel> tabs;
  String createdAt;

  factory StoriesListDataModel.fromJson(Map<String, dynamic> json) => StoriesListDataModel(
        id: json["id"],
        name: json["name"],
        logoFilePath: json["logo_file_path"],
        tabs: List<TabModel>.from(json["tabs"].map((x) => TabModel.fromJson(x))),
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo_file_path": logoFilePath,
        "tabs": List<dynamic>.from(tabs.map((x) => x.toJson())),
        "created_at": createdAt,
      };
}

class TabModel {
  TabModel({this.id, this.title, this.text, this.duration, this.buttonTitle, this.url, this.logoFilePath, this.textColor});

  int id;
  String title;
  String text;
  double duration;
  String buttonTitle;
  String url;
  String logoFilePath;
  String textColor;

  factory TabModel.fromJson(Map<String, dynamic> json) => TabModel(
        id: json["id"],
        textColor: json["text_color"],
        title: json["title"] ?? "",
        text: json["text"] ?? "",
        duration: json["duration"].toString().toDouble() ?? 3.0,
        buttonTitle: json["button_title"],
        url: json["url"],
        logoFilePath: json["logo_file_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text_color": textColor,
        "title": title,
        "text": text,
        "duration": duration,
        "button_title": buttonTitle,
        "url": url,
        "logo_file_path": logoFilePath,
      };
}
